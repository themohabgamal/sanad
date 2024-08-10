import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sanad/core/theme/my_colors.dart';
import 'package:sanad/models/zekr.dart';

class ZekrList extends StatelessWidget {
  final List<Zekr> zekrList;

  const ZekrList({super.key, required this.zekrList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: zekrList.length,
      itemBuilder: (context, index) {
        Zekr zekr = zekrList[index];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                spreadRadius: 2,
                offset: const Offset(0, 3), // Shadow position
              ),
            ],
          ),
          child: ListTile(
            title: Text(
              zekr.zekr,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontFamily: "Cairo", color: Colors.white, fontSize: 20),
            ),
            subtitle: Column(
              children: [
                Text(
                  zekr.description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontFamily: "Cairo",
                      color: MyColors.secondaryColor,
                      fontSize: 14),
                ),
                zekr.count > 0
                    ? Text(
                        zekr.count.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontFamily: "Cairo",
                            color: Colors.cyan,
                            fontSize: 14),
                      )
                    : const SizedBox.shrink()
              ],
            ),
          ),
        );
      },
    ).animate().shimmer(
          duration: const Duration(milliseconds: 700),
        );
  }
}
