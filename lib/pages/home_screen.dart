import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sanad/core/theme/my_colors.dart';
import 'package:sanad/widgets/azkar_horizontal_list.dart';
import 'package:sanad/widgets/header_phrase.dart';
import 'package:sanad/widgets/prayer_times_widget.dart';
import 'package:sanad/widgets/section_grid.dart';
import 'package:sanad/widgets/youtube_video_player.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/HomeScreen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, String>> zekrTiles = [
    {"title": "أذكار الصباح", "imagePath": "assets/images/azkar_morning.png"},
    {"title": "أذكار المساء", "imagePath": "assets/images/azkar_night.png"},
    {"title": "أذكار النوم", "imagePath": "assets/images/azkar_sleep.png"},
    {"title": "أذكار متنوعة", "imagePath": "assets/images/azkar_variety.png"},
  ];

  final List<Map<String, String>> sections = [
    {
      "title": "السبحة",
      "imagePath": "assets/images/sebha.png",
      "routeName": "SebhaScreen"
    },
    {
      "title": "أحاديث",
      "imagePath": "assets/images/hadeth.png",
      "routeName": "HadethScreen"
    },
    {
      "title": "القرآن",
      "imagePath": "assets/images/audio.png",
      "routeName": "AudioQuranScreen"
    },
    {
      "title": "القبلة",
      "imagePath": "assets/images/qibla.png",
      "routeName": "QiblahScreen"
    },
    {
      "title": "التقويم",
      "imagePath": "assets/images/calendar.png",
      "routeName": "CalendarScreen"
    },
    {
      "title": "المصحف",
      "imagePath": "assets/images/mushaf.png",
      "routeName": "MushafScreen"
    },
  ];
  var surahJsonData;
  Future<void> loadJsonAsset() async {
    final String response =
        await rootBundle.loadString('assets/json/surahs.json');
    final data = await jsonDecode(response);
    setState(() {
      surahJsonData = jsonEncode(data);
    });
  }

  @override
  void initState() {
    super.initState();
    loadJsonAsset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: MyColors.primaryColor,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Image.asset(
                    "assets/images/lantern.png",
                    width: 70,
                  ).animate().fadeIn(duration: 500.ms),
                ),
                const HeaderPhrase().animate().fadeIn(duration: 500.ms),
                Column(
                  children: [
                    // White container with rounded top corners
                    Container(
                      margin: const EdgeInsets.only(top: 20.0),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Rounded container on top of the white container
                          const PrayerTimesWidget(),
                          Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: const Text(
                              "الأذكار",
                              style: TextStyle(
                                  fontFamily: "Cairo",
                                  fontSize: 20,
                                  color: MyColors.primaryColor,
                                  fontWeight: FontWeight.w700),
                            ).animate().fadeIn(duration: 500.ms),
                          ),
                          // Horizontal list of cards
                          AzkarHorizontalList(zekrTiles: zekrTiles),
                          const Padding(
                            padding: EdgeInsets.only(right: 16),
                            child: Text(
                              "الأقسام",
                              style: TextStyle(
                                  fontFamily: "Cairo",
                                  fontSize: 20,
                                  color: MyColors.primaryColor,
                                  fontWeight: FontWeight.w700),
                            ),
                          ).animate().fadeIn(duration: 500.ms),
                          SectionGrid(
                            sections: sections,
                            surahJsonData: surahJsonData,
                          ),
                          const SizedBox(height: 20),
                          const SizedBox(
                            height: 400,
                            child: YTVideoPlayer(
                                videoUrl:
                                    "https://www.youtube.com/watch?v=LoO8Fpg9Z4I"),
                          ),
                        ],
                      ),
                    ),
                    // Other widgets can be added here
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
