import 'package:flutter/material.dart';
import 'package:sanad/core/theme/my_colors.dart';

class SectionTileWidget extends StatelessWidget {
  final String title;
  final String imagePath;

  const SectionTileWidget({
    super.key,
    required this.title,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    // Calculate responsive sizes based on screen width
    final double imageSize = screenWidth * 0.10; // 15% of screen width
    final double margin = screenWidth * 0.02; // 2% of screen width
    final double padding = screenWidth * 0.02; // 4% of screen width
    final double fontSize = screenWidth * 0.04; // 4% of screen width

    return Container(
      margin: EdgeInsets.all(margin),
      decoration: BoxDecoration(
        color: MyColors.primaryColor,
        borderRadius: BorderRadius.circular(12.0), // Fixed radius
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: imageSize,
              height: imageSize,
            ),
            SizedBox(height: screenHeight * 0.02), // Responsive spacing
            Text(
              title,
              style: TextStyle(
                fontFamily: "Cairo",
                fontSize: fontSize,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
