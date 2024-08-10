import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

List<Map<String, String>> phrases = [
  {
    "arabic": "بسم الله الرحمن الرحيم",
    "english": "In the name of Allah, the Most Merciful"
  },
  {
    "arabic": "اللهم صل على محمد وآل محمد",
    "english": "O Allah, send blessings upon Muhammad"
  },
  {
    "arabic": "الحمد لله رب العالمين",
    "english": "Praise be to Allah, the Lord of worlds"
  },
  {
    "arabic": "سبحان الله وبحمده",
    "english": "Glory be to Allah and praise Him"
  },
  {
    "arabic": "أستغفر الله ربي وأتوب إليه",
    "english": "I seek forgiveness from Allah, my Lord"
  },
  {"arabic": "ما شاء الله", "english": "As Allah wills"},
  {"arabic": "اللهم عافني", "english": "O Allah, grant me health"},
  {
    "arabic": "إنا لله وإنا إليه راجعون",
    "english": "Indeed, we are from Allah and to Him we return"
  },
  {
    "arabic": "اللهم اجعل عملنا خالصاً",
    "english": "O Allah, make our work sincere"
  },
  {
    "arabic": "اللهم اجعلني من المتطهرين",
    "english": "O Allah, make me among the pure"
  }
];

class HeaderPhrase extends StatefulWidget {
  const HeaderPhrase({super.key});

  @override
  _HeaderPhraseState createState() => _HeaderPhraseState();
}

class _HeaderPhraseState extends State<HeaderPhrase> {
  late Timer _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(minutes: 10), (Timer timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % phrases.length;
      });
    });
  }

  void _onTap() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % phrases.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentPhrase = phrases[_currentIndex];
    return GestureDetector(
      onTap: _onTap,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), // Optional: Rounded corners
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              currentPhrase['arabic']!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: "Cairo",
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ).animate().fadeIn(duration: 500.ms),
            const SizedBox(height: 8),
            Text(
              currentPhrase['english']!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: "Arial",
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ).animate().fadeIn(duration: 500.ms),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
