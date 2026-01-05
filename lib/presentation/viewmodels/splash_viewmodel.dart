import 'package:flutter/material.dart';

class SplashViewModel extends ChangeNotifier {
  late AnimationController iconController;
  late AnimationController ballController;
  late AnimationController logoController;
  AnimationController? particlesController;

  void init(TickerProvider vsync, VoidCallback onSplashEnd) {
    iconController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 1200),
    );

    ballController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 1500),
    );

    logoController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 800),
    );

    particlesController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 1000),
    );

    _startSequence(onSplashEnd);
  }

  Future<void> _startSequence(VoidCallback onSplashEnd) async {
    await iconController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    await ballController.forward();
    await Future.delayed(const Duration(milliseconds: 400));
    await logoController.forward();
    await Future.delayed(const Duration(milliseconds: 100));
    await particlesController?.forward();

    // Splash terminé → appeler la callback pour navigation
    await Future.delayed(const Duration(milliseconds: 500));
    onSplashEnd();
  }

  void disposeControllers() {
    iconController.dispose();
    ballController.dispose();
    logoController.dispose();
    particlesController?.dispose();
  }
}
