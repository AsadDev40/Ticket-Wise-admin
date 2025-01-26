import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ticket_wise_admin/Model/city_model.dart';
import 'package:ticket_wise_admin/provider/city_provider.dart';
import 'package:ticket_wise_admin/screens/edit_city_screen.dart';
import 'package:ticket_wise_admin/utils/utils.dart';
import 'package:ticket_wise_admin/widgets/constants.dart';
import 'package:provider/provider.dart';

class CityListview extends StatelessWidget {
  final List<CityModel> cities;

  const CityListview({super.key, required this.cities});

  @override
  Widget build(BuildContext context) {
    final cityProvider = Provider.of<CityProvider>(context);
    return ListView.builder(
      itemCount: cities.length,
      itemBuilder: (context, index) {
        final city = cities[index];
        return InkWell(
          onTap: () {
            // Add your onTap functionality here, if needed
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  top: 10.0,
                ),
                child: Card(
                  color: PrimaryColor, // Set background color to primary color
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete,
                              color: Colors
                                  .white), // Set delete icon color to white
                          onPressed: () async {
                            await cityProvider.deleteCity(city.cityId);
                          },
                        ),
                        IconButton(
                          onPressed: () {
                            Utils.navigateTo(
                                context, EditCityScreen(city: city));
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.white, // Set edit icon color to white
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
                          imageUrl: city.cityImageurl.toString(),
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => const Icon(
                              Icons.error,
                              color: Colors
                                  .white), // Set error icon color to white
                        ),
                      ),
                    ),
                    title: Text(
                      city.cityName,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white, // Set title text color to white
                      ),
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
