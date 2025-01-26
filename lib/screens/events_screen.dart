import 'package:flutter/material.dart';
import 'package:ticket_wise_admin/Model/event_model.dart';
import 'package:ticket_wise_admin/pages/search_events.dart';
import 'package:ticket_wise_admin/provider/category_provider.dart';
import 'package:ticket_wise_admin/provider/city_provider.dart';
import 'package:ticket_wise_admin/provider/event_provider.dart';
import 'package:ticket_wise_admin/screens/add_event_screen.dart';
import 'package:ticket_wise_admin/utils/utils.dart';
import 'package:ticket_wise_admin/widgets/event_widget.dart';
import 'package:provider/provider.dart';
import 'package:ticket_wise_admin/widgets/constants.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _refreshProducts() async {
    await Provider.of<EventProvider>(context, listen: false).fetchEvents();
  }

  String? selectedCity;
  String? selectedCategory;
  DateTime? selectedDate;

  late Future<List<EventModel>> _eventsFuture;

  @override
  void initState() {
    super.initState();
    _eventsFuture =
        Provider.of<EventProvider>(context, listen: false).fetchEvents();
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
              Utils.navigateTo(context, SearchEventsPage());
            },
          ),
          IconButton(
            icon: const Icon(Icons.location_city, color: Colors.white),
            onPressed: () {
              _selectCity(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.category, color: Colors.white),
            onPressed: () {
              _selectCategory(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.date_range, color: Colors.white),
            onPressed: () {
              _selectDate(context);
            },
          ),
        ],
        title: const Text(
          'Events',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder<List<EventModel>>(
        future: _eventsFuture,
        builder:
            (BuildContext context, AsyncSnapshot<List<EventModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading Events'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Events available'));
          } else {
            List<EventModel> events = snapshot.data!;

            // Apply filters if selected
            if (selectedCity != null) {
              events =
                  events.where((event) => event.city == selectedCity).toList();
            }
            if (selectedCategory != null) {
              events = events
                  .where((event) => event.category == selectedCategory)
                  .toList();
            }
            if (selectedDate != null) {
              events = events
                  .where((event) => event.eventDate == selectedDate)
                  .toList();
            }

            return RefreshIndicator(
              onRefresh: _refreshProducts,
              child: EventListView(events: events),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: PrimaryColor,
        onPressed: () {
          Utils.navigateTo(context, const AddEventScreen());
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  // Show City Filter Dropdown
  void _selectCity(BuildContext context) {
    final cityProvider = Provider.of<CityProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: PrimaryColor,
          title:
              const Text('Select City', style: TextStyle(color: Colors.white)),
          content: DropdownButton<String>(
            hint: const Text(
              "Select City",
              style: TextStyle(color: Colors.white),
            ),
            value: selectedCity,
            onChanged: (value) {
              setState(() {
                selectedCity = value;
              });
              cityProvider.updateSelectedValue(value ?? "");
              Navigator.pop(context);
            },
            items: cityProvider.cityNames.map((cityName) {
              return DropdownMenuItem<String>(
                value: cityName,
                child: Text(
                  cityName,
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }).toList(),
            dropdownColor: PrimaryColor,
          ),
        );
      },
    );
  }

  // Show Category Filter Dropdown
  void _selectCategory(BuildContext context) {
    final categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: PrimaryColor,
          title: const Text('Select Category',
              style: TextStyle(color: Colors.white)),
          content: DropdownButton<String>(
            hint: const Text(
              "Select Category",
              style: TextStyle(color: Colors.white),
            ),
            value: selectedCategory,
            onChanged: (value) {
              setState(() {
                selectedCategory = value;
              });
              categoryProvider.updateSelectedValue(value ?? "");
              Navigator.pop(context);
            },
            items: categoryProvider.categoryNames.map((categoryName) {
              return DropdownMenuItem<String>(
                value: categoryName,
                child: Text(
                  categoryName,
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }).toList(),
            dropdownColor: PrimaryColor,
          ),
        );
      },
    );
  }

  // Show Date Picker for Date Filter
  void _selectDate(BuildContext context) async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }
}
