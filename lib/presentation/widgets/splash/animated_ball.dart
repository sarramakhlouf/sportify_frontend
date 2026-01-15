import 'package:flutter/material.dart';
import '../../../../../core/constants/assets.dart';

class AnimatedBall extends StatelessWidget {
  final AnimationController controller;

  const AnimatedBall({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, -0.3),
        end: const Offset(0, 0),
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut)),
      child: RotationTransition(
        turns: Tween<double>(begin: 0, end: 4).animate(controller),
        child: Image.asset(AppAssets.ball, width: 40),
      ),
    );
  }
}
