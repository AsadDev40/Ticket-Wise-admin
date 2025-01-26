import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticket_wise_admin/Model/event_model.dart';
import 'package:ticket_wise_admin/provider/event_provider.dart';
import 'package:ticket_wise_admin/screens/event_detail_screen.dart';
import 'package:ticket_wise_admin/utils/utils.dart';
import 'package:ticket_wise_admin/widgets/constants.dart';

class CitySearchPage extends StatefulWidget {
  @override
  _CitySearchPageState createState() => _CitySearchPageState();
}

class _CitySearchPageState extends State<CitySearchPage> {
  List<EventModel> _events = [];
  bool _isLoading = true;
  String? _selectedCity;
  List<String> _cities = [];
  List<EventModel> _filteredEvents = [];

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    List<EventModel> events = await eventProvider.fetchEvents();

    setState(() {
      _events = events;
      _filteredEvents = events;
      _cities = _getCities(events);
      _isLoading = false;
    });
  }

  // Get a list of unique cities from the events
  List<String> _getCities(List<EventModel> events) {
    Set<String> cities = {};
    for (var event in events) {
      if (event.city != null && event.city!.isNotEmpty) {
        cities.add(event.city!);
      }
    }
    return cities.toList();
  }

  // Filter events by the selected city
  void _filterByCity(String? city) {
    setState(() {
      _selectedCity = city;
      if (city == null || city.isEmpty) {
        _filteredEvents = _events;
      } else {
        _filteredEvents = _events.where((event) => event.city == city).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search Events by City',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: PrimaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // City Filter Dropdown
                  DropdownButton<String>(
                    hint: const Text('Select City'),
                    value: _selectedCity,
                    onChanged: (String? newCity) {
                      _filterByCity(newCity);
                    },
                    items: _cities.map<DropdownMenuItem<String>>((String city) {
                      return DropdownMenuItem<String>(
                        value: city,
                        child: Text(city),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  // Event List View
                  Expanded(
                    child: ListView.builder(
                      itemCount: _filteredEvents.length,
                      itemBuilder: (context, index) {
                        final event = _filteredEvents[index];
                        return Card(
                          color: PrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                event.eventImageUrls.first,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              event.title,
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              event.location,
                              style: const TextStyle(color: Colors.white70),
                            ),
                            onTap: () {
                              Utils.navigateTo(
                                  context, EventDetailScreen(event: event));
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
