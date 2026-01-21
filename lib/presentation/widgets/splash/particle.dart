import 'package:flutter/material.dart';
import 'dart:math';

class Particle extends StatelessWidget {
  final AnimationController controller;
  final double angle; // angle en radians
  final double radius;
  final double delay;

  const Particle({
    super.key,
    required this.controller,
    required this.angle,
    required this.radius,
    this.delay = 0,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        // Normalise le delay (0.06s sur une durée de 0.9s)
        final normalizedDelay = delay / 0.9;
        final progress = (controller.value - normalizedDelay).clamp(0.0, 1.0);

        // Position
        final x = cos(angle) * radius * progress;
        final y = sin(angle) * radius * progress;

        // Animation en courbe: monte puis descend
        // 0 -> 0.5: monte de 0 à 1
        // 0.5 -> 1: descend de 1 à 0
        final curve = progress < 0.5 
            ? progress * 2  // 0 -> 1
            : (1 - progress) * 2; // 1 -> 0

        final opacity = curve.clamp(0.0, 1.0);
        final scale = (curve * 1.3).clamp(0.0, 1.3);

        return Transform.translate(
          offset: Offset(x, y),
          child: Opacity(
            opacity: opacity,
            child: Transform.scale(
              scale: scale,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF22C55E),
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