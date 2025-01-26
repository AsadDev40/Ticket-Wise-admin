import 'package:flutter/material.dart';
import 'package:ticket_wise_admin/screens/category_screen.dart';
import 'package:ticket_wise_admin/screens/cities_screen.dart';
import 'package:ticket_wise_admin/screens/events_screen.dart';
import 'package:ticket_wise_admin/screens/ticket_list_screen.dart';
import 'package:ticket_wise_admin/utils/utils.dart';
import 'package:ticket_wise_admin/widgets/box.dart';
import 'package:ticket_wise_admin/widgets/constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: PrimaryColor,
        title: const Text(
          'Home Screen',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome Admin',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: PrimaryColor),
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Utils.navigateTo(context, const CityScreen());
                  },
                  child: const Custombox(
                    backgroundColor: PrimaryColor,
                    title: 'Cities',
                    bordercolor: Colors.white,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Utils.navigateTo(context, const EventsScreen());
                  },
                  child: const Custombox(
                    backgroundColor: PrimaryColor,
                    title: 'Events',
                    bordercolor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Utils.navigateTo(context, TicketScreen());
                  },
                  child: const Custombox(
                    backgroundColor: PrimaryColor,
                    title: 'Tickets',
                    bordercolor: Colors.white,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Utils.navigateTo(context, const CategoryScreen());
                  },
                  child: const Custombox(
                    backgroundColor: PrimaryColor,
                    title: 'Categories',
                    bordercolor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
