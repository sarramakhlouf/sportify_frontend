import 'package:flutter/material.dart';
import 'package:sportify_frontend/core/constants/assets.dart';
import 'package:sportify_frontend/presentation/viewmodels/auth_viewmodel.dart';
import 'dart:math';
import 'package:sportify_frontend/presentation/viewmodels/splash_viewmodel.dart';
import 'package:sportify_frontend/presentation/widgets/splash/animated_ball.dart';
import 'package:sportify_frontend/presentation/widgets/splash/particle.dart';

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
