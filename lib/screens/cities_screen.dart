import 'package:flutter/material.dart';
import 'package:ticket_wise_admin/Model/city_model.dart';
import 'package:ticket_wise_admin/pages/city_search.dart';
import 'package:ticket_wise_admin/provider/city_provider.dart';
import 'package:ticket_wise_admin/screens/add_city_screen.dart';
import 'package:ticket_wise_admin/utils/utils.dart';
import 'package:ticket_wise_admin/widgets/city_listview.dart';
import 'package:provider/provider.dart';
import 'package:ticket_wise_admin/widgets/constants.dart';

class CityScreen extends StatefulWidget {
  const CityScreen({super.key});

  @override
  CityScreenState createState() => CityScreenState();
}

class CityScreenState extends State<CityScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _refreshCities() async {
    await Provider.of<CityProvider>(context, listen: false).fetchCities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: PrimaryColor,
        iconTheme: IconThemeData(color: Colors.white),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              Utils.navigateTo(context, CitySearchPage());
            },
          )
        ],
        title: const Text(
          'Cities',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder<List<CityModel>>(
        future: Provider.of<CityProvider>(context, listen: false).fetchCities(),
        builder:
            (BuildContext context, AsyncSnapshot<List<CityModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading cities'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Cities available'));
          } else {
            return RefreshIndicator(
              onRefresh: _refreshCities,
              child: CityListview(cities: snapshot.data!),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: PrimaryColor,
        onPressed: () {
          Utils.navigateTo(context, const AddCityScreen());
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
