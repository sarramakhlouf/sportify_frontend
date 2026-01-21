import 'package:flutter/material.dart';
import 'dart:math';

class AnimatedBall extends StatelessWidget {
  final AnimationController controller;
  final String ballAsset;

  const AnimatedBall({
    super.key,
    required this.controller,
    required this.ballAsset,
  });

  double _lerp(double a, double b, double t) {
    return a + (b - a) * t;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final value = controller.value;

        double x, y, opacity, scale, rotation;

        // times: [0, 0.3, 0.5, 0.7, 1]
        if (value <= 0.3) {
          // Phase 1: 0 -> 0.3
          final t = (value / 0.3).clamp(0.0, 1.0);
          x = _lerp(40, 20, t);
          y = _lerp(-60, -20, t);
          opacity = _lerp(0, 1, t);
          scale = _lerp(0.6, 1, t);
          rotation = _lerp(0, 360, t);
        } else if (value <= 0.5) {
          // Phase 2: 0.3 -> 0.5
          final t = ((value - 0.3) / 0.2).clamp(0.0, 1.0);
          x = _lerp(20, 0, t);
          y = _lerp(-20, 10, t);
          opacity = 1;
          scale = _lerp(1, 0.9, t);
          rotation = _lerp(360, 720, t);
        } else if (value <= 0.7) {
          // Phase 3: 0.5 -> 0.7
          final t = ((value - 0.5) / 0.2).clamp(0.0, 1.0);
          x = 0;
          y = _lerp(10, 30, t);
          opacity = 1;
          scale = _lerp(0.9, 0.7, t);
          rotation = _lerp(720, 1080, t);
        } else {
          // Phase 4: 0.7 -> 1
          final t = ((value - 0.7) / 0.3).clamp(0.0, 1.0);
          x = 0;
          y = 30;
          opacity = _lerp(1, 0, t);
          scale = _lerp(0.7, 0.4, t);
          rotation = _lerp(1080, 1440, t);
        }

        // Sécurité: clamp toutes les valeurs
        opacity = opacity.clamp(0.0, 1.0);
        scale = scale.clamp(0.0, 2.0);

        return Transform.translate(
          offset: Offset(x, y),
          child: Transform.rotate(
            angle: rotation * pi / 180,
            child: Opacity(
              opacity: opacity,
              child: Transform.scale(
                scale: scale,
                child: Image.asset(ballAsset, width: 40),
              ),
            ),
          ),
        );
      },
    );
  }
}