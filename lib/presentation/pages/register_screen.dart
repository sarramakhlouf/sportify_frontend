import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportify_frontend/core/widgets/custom_text_field.dart';
import 'package:sportify_frontend/presentation/viewmodels/auth_viewmodel.dart';
import 'package:sportify_frontend/presentation/widgets/profile_photo_picker.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
  File? selectedProfileImage;

  void _register() async {
    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneController.text.isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez remplir tous les champs")),
      );
      return;
    }

    final authVM = context.read<AuthViewModel>();

    if (authVM.selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez choisir un rôle")),
      );
      return;
    }

    try {
      await authVM.register(
        firstname: firstNameController.text,
        lastname: lastNameController.text,
        email: emailController.text,
        phone: phoneController.text,
        password: passwordController.text,
        profileImage: selectedProfileImage,
      );

      if (authVM.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur inscription : ${authVM.error}")),
        );
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Inscription réussie !")));

      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erreur inscription : $e")));
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER
            Stack(
              children: [
                Image.asset(
                  "assets/images/football_bg.jpg",
                  width: double.infinity,
                  height: 240,
                  fit: BoxFit.cover,
                ),
                Container(
                  height: 240,
                  color: Colors.green.shade900.withOpacity(0.45),
                ),
                const Positioned.fill(
                  child: Center(
                    child: Text(
                      "Inscription",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // FORM CARD
            Transform.translate(
              offset: const Offset(0, -60),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 25,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      children: [
                        ProfilePhotoPicker(
                          onImageSelected: (file) {
                            setState(() {
                              selectedProfileImage = file;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          hint: "Prénom",
                          icon: Icons.person_outline,
                          controller: firstNameController,
                        ),
                        const SizedBox(height: 12),
                        CustomTextField(
                          hint: "Nom",
                          icon: Icons.person_outline,
                          controller: lastNameController,
                        ),
                        const SizedBox(height: 12),
                        CustomTextField(
                          hint: "Email",
                          icon: Icons.email_outlined,
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 12),
                        CustomTextField(
                          hint: "Numéro de téléphone",
                          icon: Icons.phone_outlined,
                          controller: phoneController,
                        ),
                        const SizedBox(height: 12),
                        CustomTextField(
                          hint: "Mot de passe",
                          icon: Icons.lock_outline,
                          controller: passwordController,
                          obscure: !isPasswordVisible,
                          onToggleVisibility: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Au moins 6 caractères",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // REGISTER BUTTON
                        Consumer<AuthViewModel>(
                          builder: (context, authVM, child) => SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                elevation: 6,
                                shadowColor: Colors.green.withOpacity(0.4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              onPressed: authVM.isLoading ? null : _register,
                              child: authVM.isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text(
                                      "Créer mon compte",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Vous avez déjà un compte ? "),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Se connecter",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
