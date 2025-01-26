import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ticket_wise_admin/Model/category_model.dart';
import 'package:ticket_wise_admin/provider/category_provider.dart';
import 'package:ticket_wise_admin/screens/edit_category_screen.dart';
import 'package:ticket_wise_admin/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:ticket_wise_admin/widgets/constants.dart';

class CategoryListview extends StatelessWidget {
  final List<CategoryModel> cat;

  const CategoryListview({super.key, required this.cat});

  @override
  Widget build(BuildContext context) {
    final categoryprovider = Provider.of<CategoryProvider>(context);
    return ListView.builder(
      itemCount: cat.length,
      itemBuilder: (context, index) {
        final category = cat[index];
        return InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Card(
              color: PrimaryColor, // Primary color background
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete,
                          color: Colors.white), // White icon
                      onPressed: () async {
                        await categoryprovider
                            .deleteCategory(category.categoryId);
                      },
                    ),
                    IconButton(
                      onPressed: () {
                        Utils.navigateTo(
                          context,
                          EditCategoryScreen(category: category),
                        );
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.white, // White icon
                      ),
                    ),
                  ],
                ),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Container(
                    height: 48,
                    width: 48,
                    decoration: const BoxDecoration(color: Colors.blue),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: category.categoryImageurl.toString(),
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
                title: Text(
                  category.categoryName,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white, // White text
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
