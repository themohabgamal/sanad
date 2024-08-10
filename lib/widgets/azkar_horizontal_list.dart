import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sanad/pages/azkar_screen.dart';
import 'package:sanad/widgets/zekr_tile_widget.dart';

class AzkarHorizontalList extends StatelessWidget {
  final List<Map<String, String>> zekrTiles;
  const AzkarHorizontalList({super.key, required this.zekrTiles});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      height: 150.0,
      padding: const EdgeInsets.only(right: 16),
      child: ListView.builder(
        reverse: true,
        scrollDirection: Axis.horizontal,
        itemCount: zekrTiles.length, // Number of cards
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AzkarScreen(
                      azkarName: zekrTiles[index]['title'].toString(),
                    ),
                  ));
            },
            child: ZekrTileWidget(
              title: zekrTiles[index]['title'].toString(),
              imagePath: zekrTiles[index]['imagePath'].toString(),
            ),
          ).animate().fadeIn(duration: 700.ms);
        },
      ),
    );
  }
}
