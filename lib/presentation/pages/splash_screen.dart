import 'package:flutter/material.dart';
import 'package:sportify_frontend/core/constants/assets.dart';
import 'package:sportify_frontend/presentation/viewmodels/auth_viewmodel.dart';
import 'dart:math';
import 'package:sportify_frontend/presentation/viewmodels/splash_viewmodel.dart';
import 'package:sportify_frontend/presentation/widgets/splash/animated_ball.dart';
import 'package:sportify_frontend/presentation/widgets/splash/animated_green_icon.dart';
import 'package:sportify_frontend/presentation/widgets/splash/particle.dart';
import 'package:sportify_frontend/presentation/widgets/splash/goal_net.dart';

class SplashScreen extends StatefulWidget {
  final AuthViewModel authVM;

  const SplashScreen({
    super.key,
    required this.authVM,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late SplashViewModel viewModel;
  final int particleCount = 8;

  @override
  void initState() {
    super.initState();
    viewModel = SplashViewModel();

    viewModel.init(this, () async {
      await widget.authVM.tryAutoLogin();

      if (!mounted) return;

      final user = widget.authVM.currentUser;

      if (user != null) {
        if (widget.authVM.isPlayer) {
          Navigator.pushReplacementNamed(context, '/player_dashboard');
        } else if (widget.authVM.isManager) {
          Navigator.pushReplacementNamed(context, '/create_team');
        }
      } else {
        Navigator.pushReplacementNamed(context, '/role');
      }
    });
  }

  @override
  void dispose() {
    viewModel.disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            /// BUT DE FOOTBALL (Goal Net)
            /// Apparaît au milieu, puis disparaît
            GoalNet(controller: viewModel.goalController),

            /// ICÔNE VERTE
            /// Rotation, tire le ballon, puis se place à côté du logo
            AnimatedGreenIcon(
              controller: viewModel.iconController,
              iconAsset: AppAssets.icon,
            ),

            /// BALLON TIRÉ
            /// L'icône tire le ballon vers le but
            AnimatedBall(
              controller: viewModel.ballController,
              ballAsset: AppAssets.ball,
            ),

            /// LOGO SPORTIFY COMPLET
            /// Apparaît après l'animation du tir
            FadeTransition(
              opacity: Tween<double>(begin: 0, end: 1).animate(
                CurvedAnimation(
                  parent: viewModel.logoController,
                  curve: const Interval(0, 1, curve: Curves.easeInOut),
                ),
              ),
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.8, end: 1).animate(
                  CurvedAnimation(
                    parent: viewModel.logoController,
                    curve: const Cubic(0.34, 1.56, 0.64, 1),
                  ),
                ),
                child: Image.asset(AppAssets.sportify, width: 180),
              ),
            ),

            /// PARTICULES DE CÉLÉBRATION
            /// 8 particules qui explosent en cercle
            ...List.generate(particleCount, (i) {
              double angle = (2 * pi / particleCount) * i;
              return viewModel.particlesController != null
                  ? Particle(
                      controller: viewModel.particlesController!,
                      angle: angle,
                      radius: 110,
                      delay: i * 0.06,
                    )
                  : const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }
}