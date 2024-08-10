import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LoadingSanad extends StatelessWidget {
  const LoadingSanad({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Image.asset('assets/images/sanad.png')
            .animate()
            .fade(duration: 900.ms));
  }
}
