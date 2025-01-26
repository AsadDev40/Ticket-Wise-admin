import 'package:flutter/material.dart';
import 'package:ticket_wise_admin/Model/category_model.dart';
import 'package:ticket_wise_admin/pages/category_search.dart';
import 'package:ticket_wise_admin/provider/category_provider.dart';
import 'package:ticket_wise_admin/screens/add_category_screen.dart';
import 'package:ticket_wise_admin/utils/utils.dart';
import 'package:ticket_wise_admin/widgets/category_listview.dart';
import 'package:provider/provider.dart';
import 'package:ticket_wise_admin/widgets/constants.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  CategoryScreenState createState() => CategoryScreenState();
}

class CategoryScreenState extends State<CategoryScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _refreshProducts() async {
    await Provider.of<CategoryProvider>(context, listen: false)
        .fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: PrimaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              Utils.navigateTo(context, CategorySearchPage());
            },
          )
        ],
        title: const Text(
          'Categories',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder<List<CategoryModel>>(
        future: Provider.of<CategoryProvider>(context, listen: false)
            .fetchCategories(),
        builder: (BuildContext context,
            AsyncSnapshot<List<CategoryModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading products'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Categories available'));
          } else {
            return RefreshIndicator(
              onRefresh: _refreshProducts,
              child: CategoryListview(cat: snapshot.data!),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: PrimaryColor,
        onPressed: () {
          Utils.navigateTo(context, const AddCategoryScreen());
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
