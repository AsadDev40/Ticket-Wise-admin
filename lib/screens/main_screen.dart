import 'package:flutter/material.dart';
import 'package:ticket_wise_admin/screens/category_screen.dart';
import 'package:ticket_wise_admin/screens/cities_screen.dart';
import 'package:ticket_wise_admin/screens/events_screen.dart';
import 'package:ticket_wise_admin/screens/ticket_list_screen.dart';
import 'package:ticket_wise_admin/screens/users_screen.dart';
import 'package:ticket_wise_admin/widgets/custom_bottom_navigation_bar.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  int _currentIndex = 0;
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  List<Widget> _buildScreen() {
    return [
      const EventsScreen(),
      const CategoryScreen(),
      const CityScreen(),
      TicketScreen(),
      const UsersScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildScreen()[_currentIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
