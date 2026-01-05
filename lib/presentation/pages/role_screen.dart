import 'package:flutter/material.dart';
import 'package:sportify_frontend/core/widgets/primary_button.dart';
import 'package:sportify_frontend/presentation/widgets/role_card.dart';

class RoleScreen extends StatefulWidget {
  const RoleScreen({super.key});

  @override
  State<RoleScreen> createState() => _RoleScreenState();
}

class _RoleScreenState extends State<RoleScreen> {
  String? selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              const Text(
                "JE SUIS UN",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
              ),

              const SizedBox(height: 10),

              const Text(
                "Choisissez votre rôle pour continuer",
                style: TextStyle(fontSize: 15, color: Colors.black54),
              ),

              const SizedBox(height: 32),

              /// JOUEUR
              RoleCard(
                icon: Icons.sports_soccer,
                title: "Joueur",
                subtitle: "Connectez-vous pour jouer",
                selected: selectedRole == "PLAYER",
                onTap: () => setState(() => selectedRole = "PLAYER"),
              ),

              const SizedBox(height: 20),

              /// RESPONSABLE
              RoleCard(
                icon: Icons.stadium,
                title: "Responsable de terrain",
                subtitle: "Gérez votre terrain et vos matchs",
                selected: selectedRole == "MANAGER",
                onTap: () => setState(() => selectedRole = "MANAGER"),
              ),

              const Spacer(),

              PrimaryButton(
                text: "CONTINUER",
                enabled: selectedRole != null,
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/login',
                    arguments: selectedRole,
                  );
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
