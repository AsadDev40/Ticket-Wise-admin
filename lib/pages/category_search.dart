// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticket_wise_admin/Model/event_model.dart';
import 'package:ticket_wise_admin/provider/event_provider.dart';
import 'package:ticket_wise_admin/screens/event_detail_screen.dart';
import 'package:ticket_wise_admin/utils/utils.dart';
import 'package:ticket_wise_admin/widgets/constants.dart';

class CategorySearchPage extends StatefulWidget {
  const CategorySearchPage({super.key});

  @override
  _CategorySearchPageState createState() => _CategorySearchPageState();
}

class _CategorySearchPageState extends State<CategorySearchPage> {
  List<EventModel> _events = [];
  bool _isLoading = true;
  String? _selectedCategory;
  List<String> _categories = [];
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
      _categories = _getCategories(events);
      _isLoading = false;
    });
  }

  // Get a list of unique categories from the events
  List<String> _getCategories(List<EventModel> events) {
    Set<String> categories = {};
    for (var event in events) {
      if (event.category.isNotEmpty) {
        categories.add(event.category);
      }
    }
    return categories.toList();
  }

  // Filter events by the selected category
  void _filterByCategory(String? category) {
    setState(() {
      _selectedCategory = category;
      if (category == null || category.isEmpty) {
        _filteredEvents = _events;
      } else {
        _filteredEvents =
            _events.where((event) => event.category == category).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search Events by Category',
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
                  // Category Filter Dropdown
                  DropdownButton<String>(
                    hint: const Text('Select Category'),
                    value: _selectedCategory,
                    onChanged: (String? newCategory) {
                      _filterByCategory(newCategory);
                    },
                    items: _categories
                        .map<DropdownMenuItem<String>>((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
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
