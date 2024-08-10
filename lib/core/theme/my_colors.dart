import 'package:flutter/material.dart';

class MyColors {
  static const Color primaryColor = Color.fromARGB(255, 31, 2, 113);
  static const Color primaryHeavyColor = Color.fromARGB(255, 15, 0, 54);
  static const Color secondaryColor = Color(0xFFFEAC2D);
  static BoxShadow boxShadow = BoxShadow(
    color: Colors.black.withOpacity(0.4),
    spreadRadius: 2,
    offset: const Offset(0, 3), // Shadow position
  );
}
