import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportify_frontend/core/widgets/custom_text_field.dart';
import 'package:sportify_frontend/core/widgets/primary_button.dart';
import '../viewmodels/auth_viewmodel.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool isPasswordVisible = false;

  void _resetPassword(String email) async {
    if (passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez remplir tous les champs")),
      );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Les mots de passe ne correspondent pas")),
      );
      return;
    }

    final authVM = context.read<AuthViewModel>();
    authVM.isLoading = true;
    setState(() {});

    try {
      // Appel du ViewModel pour reset password
      await authVM.resetPassword(email, passwordController.text);

      if (authVM.error != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Erreur : ${authVM.error}")));
        return;
      }

      // Retour vers login après reset
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Mot de passe réinitialisé avec succès !"),
        ),
      );

      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erreur lors du reset : $e")));
    } finally {
      authVM.isLoading = false;
      setState(() {});
    }
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();

    // Récupération de l'email passé depuis OTP screen
    final String email =
        ModalRoute.of(context)?.settings.arguments as String? ?? '';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER
            Stack(
              children: [
                Image.asset(
                  "assets/images/football_bg.jpg",
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                Container(
                  height: 200,
                  color: Colors.green.shade900.withOpacity(0.45),
                ),
                const Positioned.fill(
                  child: Center(
                    child: Text(
                      "NOUVEAU MOT DE PASSE",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  CustomTextField(
                    hint: "Nouveau mot de passe",
                    icon: Icons.lock_outline,
                    controller: passwordController,
                    obscure: !isPasswordVisible,
                    onToggleVisibility: () {
                      setState(() => isPasswordVisible = !isPasswordVisible);
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    hint: "Confirmer le mot de passe",
                    icon: Icons.lock_outline,
                    controller: confirmPasswordController,
                    obscure: !isPasswordVisible,
                  ),
                  const SizedBox(height: 30),
                  PrimaryButton(
                    text: "RÉINITIALISER",
                    enabled: !authVM.isLoading,
                    onPressed: authVM.isLoading
                        ? null
                        : () => _resetPassword(email),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
