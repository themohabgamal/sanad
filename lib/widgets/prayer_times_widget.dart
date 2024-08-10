import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sanad/core/theme/my_colors.dart';
import 'package:sanad/pages/prayer_times_screen.dart';

class PrayerTimesWidget extends StatelessWidget {
  const PrayerTimesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const PrayerTimesScreen()));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: MyColors.secondaryColor,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              'assets/images/mosque.png',
              width: 60.0,
            ),
            const Spacer(),
            const Text(
              'أوقات الصلاة',
              style: TextStyle(
                fontFamily: "Cairo",
                color: Colors.white,
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 500.ms),
    );
  }
}
