import 'package:flutter/material.dart';

class SplashViewModel {
  late AnimationController goalController;
  late AnimationController iconController;
  late AnimationController ballController;
  late AnimationController logoController;
  AnimationController? particlesController;

  bool _disposed = false;

  void init(TickerProvider vsync, VoidCallback onComplete) {
    // Goal: démarre à 2.1s, durée 2.3s
    goalController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 2300),
    );

    Future.delayed(const Duration(milliseconds: 2100), () {
      if (!_disposed) {
        try {
          goalController.forward();
        } catch (e) {
          // Controller déjà disposed
        }
      }
    });

    // Icon: démarre à 0s, durée 4.3s
    iconController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 4300),
    )..forward();

    // Ball: démarre à 0.8s, durée 3.5s
    ballController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 3500),
    );

    Future.delayed(const Duration(milliseconds: 800), () {
      if (!_disposed) {
        try {
          ballController.forward();
        } catch (e) {
          // Controller déjà disposed
        }
      }
    });

    // Logo: démarre à 3.5s, durée 0.9s
    logoController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 900),
    );

    Future.delayed(const Duration(milliseconds: 3500), () {
      if (!_disposed) {
        try {
          logoController.forward();
        } catch (e) {
          // Controller déjà disposed
        }
      }
    });

    // Particules: démarrent à 4s, durée 0.9s
    particlesController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 900),
    );

    Future.delayed(const Duration(milliseconds: 4000), () {
      if (!_disposed) {
        try {
          particlesController?.forward();
        } catch (e) {
          // Controller déjà disposed
        }
      }
    });

    // Navigation après toute l'animation (environ 5.5s)
    Future.delayed(const Duration(milliseconds: 5500), () {
      if (!_disposed) {
        onComplete();
      }
    });
  }

  void disposeControllers() {
    _disposed = true;
    goalController.dispose();
    iconController.dispose();
    ballController.dispose();
    logoController.dispose();
    particlesController?.dispose();
  }
}