import 'package:flutter/material.dart';
import 'package:sanad/pages/mushaf/msuhaf_screen.dart';
import 'package:sanad/pages/quran/audio_quran_screen.dart';
import 'package:sanad/widgets/section_tile_widget.dart';

class SectionGrid extends StatelessWidget {
  final List<Map<String, String>> sections;
  var surahJsonData;
  SectionGrid({
    super.key,
    required this.sections,
    required this.surahJsonData,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300.0,
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 0.9,
        ),
        itemCount: sections.length,
        itemBuilder: (context, index) {
          final section = sections[index];
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, section['routeName']!);
            },
            child: SectionTileWidget(
              title: section['title']!,
              imagePath: section['imagePath']!,
            ),
          );
        },
      ),
    );
  }
}
