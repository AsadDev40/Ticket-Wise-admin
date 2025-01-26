import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ticket_wise_admin/widgets/constants.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Check the platform (iOS or Android) and adjust the height
    double height = Platform.isIOS ? 70.0 : 60.0;

    return Container(
      height: height,
      decoration: const BoxDecoration(
        color: PrimaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceEvenly, // Evenly space the icons
        children: [
          _buildNavItem(Icons.event_sharp, 'Events', 0, onTap),
          _buildNavItem(Icons.category, 'Categories', 1, onTap),
          _buildNavItem(Icons.location_city, 'Cities', 2, onTap),
          // _buildNavItem(Icons.add, 'Add Event', 2, onTap),
          _buildNavItem(FontAwesomeIcons.ticket, 'Tickets', 3, onTap),
          _buildNavItem(Icons.person, 'Users', 4, onTap),
        ],
      ),
    );
  }

  Widget _buildNavItem(
      IconData icon, String label, int index, Function(int) onTap) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: currentIndex == index ? Colors.white : Colors.grey,
          ),
          Text(
            label,
            style: TextStyle(
              color: currentIndex == index ? Colors.white : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
