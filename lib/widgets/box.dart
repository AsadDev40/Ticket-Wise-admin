import 'package:flutter/material.dart';

class Custombox extends StatelessWidget {
  final Color bordercolor;
  final String title;
  final Color backgroundColor; // Add background color parameter
  const Custombox({
    super.key,
    required this.bordercolor,
    required this.title,
    required this.backgroundColor, // Add backgroundColor to constructor
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: 150,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: backgroundColor, // Set the background color here
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: bordercolor),
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(fontSize: 20, color: Colors.white),
          textAlign: TextAlign.center, // Center the text
        ),
      ),
    );
  }
}
