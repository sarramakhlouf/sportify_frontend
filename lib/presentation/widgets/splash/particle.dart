import 'package:flutter/material.dart';
import 'dart:math';

class Particle extends StatelessWidget {
  final AnimationController controller;
  final double angle; // angle en radians
  final double radius;

  const Particle({
    super.key,
    required this.controller,
    required this.angle,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    final xAnim = Tween<double>(
      begin: 0,
      end: cos(angle) * radius,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));
    final yAnim = Tween<double>(
      begin: 0,
      end: sin(angle) * radius,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));
    //final scaleAnim = Tween<double>(begin: 0, end: 1.3).animate(controller);
    //final opacityAnim = Tween<double>(begin: 0, end: 1).animate(controller);

    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return Positioned(
          left: xAnim.value,
          top: yAnim.value,
          child: Opacity(
            opacity: 1 - controller.value,
            child: Transform.scale(
              scale: 1 - controller.value,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
