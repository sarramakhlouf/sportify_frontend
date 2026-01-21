import 'package:flutter/material.dart';
import 'dart:math';

class AnimatedGreenIcon extends StatelessWidget {
  final AnimationController controller;
  final String iconAsset;

  const AnimatedGreenIcon({
    super.key,
    required this.controller,
    required this.iconAsset,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        double opacity = 0;
        double scale = 0;
        double rotation = 0;
        double x = 0;
        double y = -60;

        final value = controller.value;

        // times: [0, 0.12, 0.4, 0.55, 0.7, 1]
        // opacity: [0, 1, 1, 1, 1, 1]
        // scale: [0, 1.2, 1.2, 1.2, 1.2, 0.5]
        // rotate: [0, 0, -360, -360, -360, -360]
        // x: [0, 0, 0, 0, 0, -125]
        // y: [-60, -60, -60, -60, -60, 0]

        if (value < 0.12) {
          // 0 -> 0.12: apparition
          final t = value / 0.12;
          opacity = t;
          scale = 1.2 * t;
          rotation = 0;
          x = 0;
          y = -60;
        } else if (value < 0.4) {
          // 0.12 -> 0.4: rotation
          final t = (value - 0.12) / (0.4 - 0.12);
          opacity = 1;
          scale = 1.2;
          rotation = -360 * t;
          x = 0;
          y = -60;
        } else if (value < 0.7) {
          // 0.4 -> 0.7: maintien
          opacity = 1;
          scale = 1.2;
          rotation = -360;
          x = 0;
          y = -60;
        } else {
          // 0.7 -> 1: déplacement vers la gauche et réduction
          final t = (value - 0.7) / (1 - 0.7);
          opacity = 1;
          scale = 1.2 - (1.2 - 0.5) * t;
          rotation = -360;
          x = -125 * t;
          y = -60 + 60 * t;
        }

        // Sécurité: clamp opacity
        opacity = opacity.clamp(0.0, 1.0);
        scale = scale.clamp(0.0, 2.0);

        return Transform.translate(
          offset: Offset(x, y),
          child: Transform.rotate(
            angle: rotation * pi / 180,
            child: Transform.scale(
              scale: scale,
              child: Opacity(
                opacity: opacity,
                child: Image.asset(iconAsset, width: 80),
              ),
            ),
          ),
        );
      },
    );
  }
}