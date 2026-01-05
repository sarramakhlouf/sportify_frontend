import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportify_frontend/core/constants/assets.dart';
import 'package:sportify_frontend/presentation/viewmodels/auth_viewmodel.dart';
import 'dart:math';

import 'package:sportify_frontend/presentation/viewmodels/splash_viewmodel.dart';
import 'package:sportify_frontend/presentation/widgets/animated_ball.dart';
import 'package:sportify_frontend/presentation/widgets/particle.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

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
      final authVM = Provider.of<AuthViewModel>(context, listen: false);
      await authVM.tryAutoLogin();

      if (!mounted) return;

      final user = authVM.currentUser;

      if (user != null) {
        if (authVM.isPlayer) {
          Navigator.pushReplacementNamed(context, '/player_dashboard');
        } else if (authVM.isManager) {
          Navigator.pushReplacementNamed(context, '/create_team');
        }  
      } else {
        Navigator.pushReplacementNamed(
          context,
          '/role',
        );
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
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            /// ICONE
            ScaleTransition(
              scale: Tween<double>(begin: 0, end: 1.2).animate(
                CurvedAnimation(
                  parent: viewModel.iconController,
                  curve: Curves.easeOutBack,
                ),
              ),
              child: Image.asset(AppAssets.icon, width: 80),
            ),

            /// BALLON
            AnimatedBall(controller: viewModel.ballController),

            /// LOGO
            FadeTransition(
              opacity: Tween<double>(begin: 0, end: 1).animate(
                CurvedAnimation(
                  parent: viewModel.logoController,
                  curve: Curves.easeIn,
                ),
              ),
              child: Image.asset(AppAssets.logo, width: 180),
            ),

            /// PARTICULES
            ...List.generate(particleCount, (i) {
              double angle = (2 * pi / particleCount) * i;
              return viewModel.particlesController != null
                  ? Particle(
                      controller: viewModel.particlesController!,
                      angle: angle,
                      radius: 110,
                    )
                  : const SizedBox();
            }),
          ],
        ),
      ),
    );
  }
}
