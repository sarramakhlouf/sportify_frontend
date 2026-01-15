import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportify_frontend/presentation/viewmodels/auth_viewmodel.dart';
import 'package:sportify_frontend/presentation/widgets/account_settings/account_cart.dart';
import 'package:sportify_frontend/presentation/widgets/account_settings/info_green_card.dart';
import 'package:sportify_frontend/presentation/widgets/account_settings/role_card.dart';
import 'package:sportify_frontend/presentation/widgets/account_settings/player_code_card.dart';
import 'package:sportify_frontend/presentation/widgets/account_settings/editable_field.dart';
import 'package:sportify_frontend/presentation/widgets/account_settings/styled_input_field.dart';
import 'package:sportify_frontend/presentation/widgets/profile_photo_picker.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  late TextEditingController firstnameCtrl;
  late TextEditingController lastnameCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController phoneCtrl;

  final currentPasswordCtrl = TextEditingController();
  final newPasswordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();

  bool editName = false;
  bool editEmail = false;
  bool editPhone = false;
  bool editPassword = false;

  bool obscureCurrent = true;
  bool obscureNew = true;
  bool obscureConfirm = true;

  File? selectedImage;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthViewModel>().currentUser!;
    firstnameCtrl = TextEditingController(text: user.firstname);
    lastnameCtrl = TextEditingController(text: user.lastname);
    emailCtrl = TextEditingController(text: user.email);
    phoneCtrl = TextEditingController(text: user.phone);
  }

  Future<void> _saveProfile() async {
    final authVM = context.read<AuthViewModel>();

    final String? currentPassword = newPasswordCtrl.text.isNotEmpty
      ? currentPasswordCtrl.text.trim()
      : null;

    final String? newPassword = newPasswordCtrl.text.isNotEmpty
      ? newPasswordCtrl.text.trim()
      : null;

    await authVM.updateProfile(
      firstname: firstnameCtrl.text.trim(),
      lastname: lastnameCtrl.text.trim(),
      email: emailCtrl.text.trim(),
      phone: phoneCtrl.text.trim(),
      currentPassword: currentPassword,
      newPassword: newPassword,
      image: selectedImage,
    );

    if (authVM.error != null) {
      _snack(authVM.error!);
    } else {
      _snack("Modifications enregistrées");
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthViewModel>().currentUser!;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        title: const Text(
          "Paramètres du Compte",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            AccountCard(
              child: Column(
                children: [
                  ProfilePhotoPicker(
                    imageUrl: user.profileImageUrl,
                    onImageSelected: (file) => selectedImage = file,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Cliquez sur l'icône pour changer votre photo",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            InfoGreenCard(
              memberSince: _formatDate(user.registrationDate),
              accountId: "user-${user.id}",
            ),

            const SizedBox(height: 16),
            const RoleCard(),
            const SizedBox(height: 16),
            PlayerCodeCard(code: user.playerCode ?? "—"),
            const SizedBox(height: 16),

            EditableField(
              label: "Nom Complet",
              icon: Icons.person_outline,
              isEditing: editName,
              value: "${firstnameCtrl.text} ${lastnameCtrl.text}",
              onToggle: () async {
                if (editName) await _saveProfile();
                setState(() => editName = !editName);
              },
              fields: [
                StyledInputField(controller: firstnameCtrl, hint: "Prénom"),
                const SizedBox(height: 10),
                StyledInputField(controller: lastnameCtrl, hint: "Nom"),
              ],
            ),

            EditableField(
              label: "Numéro de Téléphone",
              icon: Icons.phone_outlined,
              isEditing: editPhone,
              value: phoneCtrl.text,
              onToggle: () async {
                if (editPhone) await _saveProfile();
                setState(() => editPhone = !editPhone);
              },
              fields: [
                StyledInputField(
                  controller: phoneCtrl,
                  hint: "Numéro de téléphone",
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),

            EditableField(
              label: "Adresse Email",
              icon: Icons.email_outlined,
              isEditing: editEmail,
              value: emailCtrl.text,
              onToggle: () async {
                if (editEmail) await _saveProfile();
                setState(() => editEmail = !editEmail);
              },
              fields: [
                StyledInputField(
                  controller: emailCtrl,
                  hint: "Adresse Email",
                  keyboardType: TextInputType.emailAddress,
                ),
              ],
            ),

            EditableField(
              label: "Mot de Passe",
              icon: Icons.lock_outline,
              isEditing: editPassword,
              onToggle: () async {
                if (editPassword) {
                  if (currentPasswordCtrl.text.isEmpty) {
                    _snack("Veuillez saisir le mot de passe actuel");
                    return;
                  }
                  if (newPasswordCtrl.text.length < 8) {
                    _snack(
                        "Le mot de passe doit contenir au moins 8 caractères");
                    return;
                  }
                  if (newPasswordCtrl.text != confirmPasswordCtrl.text) {
                    _snack(
                        "La confirmation du mot de passe ne correspond pas");
                    return;
                  }

                  await _saveProfile();

                  currentPasswordCtrl.clear();
                  newPasswordCtrl.clear();
                  confirmPasswordCtrl.clear();
                }
                setState(() => editPassword = !editPassword);
              },
              fields: [
                StyledInputField(
                  controller: currentPasswordCtrl,
                  hint: "Mot de passe actuel",
                  obscure: obscureCurrent,
                  suffix: IconButton(
                    icon: Icon(obscureCurrent
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () =>
                        setState(() => obscureCurrent = !obscureCurrent),
                  ),
                ),
                const SizedBox(height: 8),
                StyledInputField(
                  controller: newPasswordCtrl,
                  hint: "Nouveau mot de passe",
                  obscure: obscureNew,
                  suffix: IconButton(
                    icon: Icon(
                        obscureNew ? Icons.visibility_off : Icons.visibility),
                    onPressed: () =>
                        setState(() => obscureNew = !obscureNew),
                  ),
                ),
                const SizedBox(height: 8),
                StyledInputField(
                  controller: confirmPasswordCtrl,
                  hint: "Confirmer le mot de passe",
                  obscure: obscureConfirm,
                  suffix: IconButton(
                    icon: Icon(obscureConfirm
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () =>
                        setState(() => obscureConfirm = !obscureConfirm),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // -----------------------------CONFIRMER-----------------
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () async {
                  await _saveProfile();
                  setState(() {
                    editName = false;
                    editEmail = false;
                    editPhone = false;
                    editPassword = false;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF22C55E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "Confirmer",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        elevation: 4,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(
          children: [
            //const Icon(Icons.error_outline, color: Colors.black87),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                (msg),
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "-";
    const months = [
      "janvier",
      "février",
      "mars",
      "avril",
      "mai",
      "juin",
      "juillet",
      "août",
      "septembre",
      "octobre",
      "novembre",
      "décembre"
    ];
    return "${date.day} ${months[date.month - 1]} ${date.year}";
  }
}
