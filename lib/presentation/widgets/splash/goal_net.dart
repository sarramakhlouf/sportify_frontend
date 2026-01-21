import 'package:flutter/material.dart';

class GoalNet extends StatelessWidget {
  final AnimationController controller;

  const GoalNet({super.key, required this.controller});

  double _lerp(double a, double b, double t) {
    return a + (b - a) * t.clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final value = controller.value;

        double opacity;
        double scale;

        // times: [0, 0.3, 0.7, 1]
        if (value <= 0.3) {
          // Phase 1: 0 -> 0.3 (apparition)
          final t = (value / 0.3).clamp(0.0, 1.0);
          opacity = _lerp(0, 1, t);
          scale = _lerp(0, 1.3, t);
        } else if (value <= 0.7) {
          // Phase 2: 0.3 -> 0.7 (maintien avec légère réduction)
          final t = ((value - 0.3) / 0.4).clamp(0.0, 1.0);
          opacity = 1;
          scale = _lerp(1.3, 1.1, t);
        } else {
          // Phase 3: 0.7 -> 1 (disparition)
          final t = ((value - 0.7) / 0.3).clamp(0.0, 1.0);
          opacity = _lerp(1, 0, t);
          scale = _lerp(1.1, 0, t);
        }

        // Double sécurité
        opacity = opacity.clamp(0.0, 1.0);
        scale = scale.clamp(0.0, 2.0);

        return Opacity(
          opacity: opacity,
          child: Transform.scale(
            scale: scale,
            child: CustomPaint(
              size: const Size(280, 140),
              painter: GoalNetPainter(),
            ),
          ),
        );
      },
    );
  }
}

class GoalNetPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final postPaint = Paint()
      ..color = const Color(0xFF999999)
      ..style = PaintingStyle.fill;

    final netPaint = Paint()
      ..color = const Color(0xFFAAAAAA).withOpacity(0.2)
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke;

    // Poteau gauche
    canvas.drawRect(const Rect.fromLTWH(10, 20, 7, 120), postPaint);

    // Poteau droit
    canvas.drawRect(const Rect.fromLTWH(263, 20, 7, 120), postPaint);

    // Barre horizontale
    canvas.drawRect(const Rect.fromLTWH(10, 20, 260, 7), postPaint);

    // Lignes verticales du filet
    for (int i = 0; i < 13; i++) {
      canvas.drawLine(
        Offset(17 + i * 20.0, 27),
        Offset(21 + i * 20.0, 140),
        netPaint,
      );
    }

    // Lignes horizontales du filet
    for (int i = 0; i < 7; i++) {
      canvas.drawLine(
        Offset(17, 27 + i * 17.0),
        Offset(263, 27 + i * 17.0),
        netPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}