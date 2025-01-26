import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ticket_wise_admin/Model/brand_model.dart'; // Assuming you have a brand model
import 'package:ticket_wise_admin/provider/brand_provider.dart'; // Update to your brand provider
import 'package:ticket_wise_admin/screens/edit_brand_screen.dart'; // Assuming you have an edit brand screen
import 'package:ticket_wise_admin/utils/utils.dart';
import 'package:ticket_wise_admin/widgets/constants.dart';
import 'package:provider/provider.dart';

class BrandListView extends StatelessWidget {
  final List<BrandModel> brands; // Change from cities to brands

  const BrandListView(
      {super.key, required this.brands}); // Update parameter type

  @override
  Widget build(BuildContext context) {
    final brandProvider =
        Provider.of<BrandProvider>(context); // Update provider
    return ListView.builder(
      itemCount: brands.length,
      itemBuilder: (context, index) {
        final brand = brands[index]; // Change city to brand
        return InkWell(
          onTap: () {
            // Add your onTap functionality here, if needed
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Divider(height: 0),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: ListTile(
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.purple),
                        onPressed: () async {
                          await brandProvider.deleteBrand(
                              brand.brandId); // Update delete method
                        },
                      ),
                      IconButton(
                        onPressed: () {
                          Utils.navigateTo(
                              context,
                              EditBrandScreen(
                                  brand: brand)); // Update to edit brand screen
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: PrimaryColor,
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
                        imageUrl: brand.brandImageurl
                            .toString(), // Update to brand image URL
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                  title: Text(
                    brand.brandName, // Update to brand name
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
