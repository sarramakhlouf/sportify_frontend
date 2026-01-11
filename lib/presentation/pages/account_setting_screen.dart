import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sportify_frontend/presentation/viewmodels/auth_viewmodel.dart';
import 'package:sportify_frontend/presentation/widgets/profile_photo_picker.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  late TextEditingController fullnameCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController phoneCtrl;
  late TextEditingController firstnameCtrl;
  late TextEditingController lastnameCtrl;

  final currentPasswordCtrl = TextEditingController();
  final newPasswordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();

  bool editName = false;
  bool editPhone = false;
  bool editEmail = false;
  bool editPassword = false;

  bool obscureCurrent = true;
  bool obscureNew = true;
  bool obscureConfirm = true;

  File? selectedImage;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthViewModel>().currentUser!;
    fullnameCtrl = TextEditingController(
      text: "${user.firstname} ${user.lastname}",
    );
    emailCtrl = TextEditingController(text: user.email);
    phoneCtrl = TextEditingController(text: user.phone);
    firstnameCtrl = TextEditingController(text: user.firstname);
    lastnameCtrl = TextEditingController(text: user.lastname);
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthViewModel>().currentUser!;

    print("Le mot de passe actuel est : ${user.password}");

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
            _card(
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

            _infoGreenCard(user),

            const SizedBox(height: 16),

            _roleCard(),

            const SizedBox(height: 16),

            _playerCodeCard(user),

            const SizedBox(height: 16),

            _editableField(
              label: "Nom Complet",
              icon: Icons.person_outline,
              isEditing: editName,
              value: fullnameCtrl.text,
              onToggle: () {
                if (editName) {
                  fullnameCtrl.text =
                      "${firstnameCtrl.text.trim()} ${lastnameCtrl.text.trim()}";
                }
                setState(() => editName = !editName);
              },
              fields: [
                styledInputField(controller: firstnameCtrl, hint: "Prénom"),
                const SizedBox(height: 10),
                styledInputField(controller: lastnameCtrl, hint: "Nom"),
              ],
            ),
            _editableField(
              label: "Numéro de Téléphone",
              icon: Icons.phone_outlined,
              isEditing: editPhone,
              value: phoneCtrl.text,
              onToggle: () {
                setState(() => editPhone = !editPhone);
              },
              fields: [
                styledInputField(
                  controller: phoneCtrl,
                  hint: "Numéro de Téléphone",
                ),
              ],
            ),
            _editableField(
              label: "Adresse Email",
              icon: Icons.email_outlined,
              isEditing: editEmail,
              value: emailCtrl.text,
              onToggle: () {
                setState(() => editEmail = !editEmail);
              },
              fields: [
                styledInputField(controller: emailCtrl, hint: "Adresse Email"),
              ],
            ),
            _editableField(
              label: "Mot de Passe",
              icon: Icons.lock_outline,
              isEditing: editPassword,
              onToggle: () {
                setState(() => editPassword = !editPassword);
              },
              fields: [
                styledInputField(
                  hint: "Mot de passe actuel",
                  controller: currentPasswordCtrl,
                  obscure: obscureCurrent,
                  suffix: IconButton(
                    icon: Icon(
                      obscureCurrent ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        obscureCurrent = !obscureCurrent;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 8),
                styledInputField(
                  hint: "Nouveau Mot de passe",
                  controller: newPasswordCtrl,
                  obscure: obscureNew,
                  suffix: IconButton(
                    icon: Icon(
                      obscureNew ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        obscureNew = !obscureNew;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 8),
                styledInputField(
                  hint: "Confirmer le nouveau mot de passe",
                  controller: confirmPasswordCtrl,
                  obscure: obscureConfirm,
                  suffix: IconButton(
                    icon: Icon(
                      obscureConfirm ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        obscureConfirm = !obscureConfirm;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Le mot de passe doit contenir au moins 8 caractères",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check, color: Colors.white),
                label: const Text(
                  "Confirmer",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF22C55E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () async {
                  final authVM = context.read<AuthViewModel>();
                  if (currentPasswordCtrl.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Veuillez saisir le mot de passe actuel"),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    return; 
                  }
                  if (newPasswordCtrl.text.isNotEmpty && newPasswordCtrl.text != confirmPasswordCtrl.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("La confirmation du nouveau mot de passe ne correspond pas"),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    return;
                  }
                  await authVM.updateProfile(
                    firstname: firstnameCtrl.text.trim(),
                    lastname: lastnameCtrl.text.trim(),
                    email: emailCtrl.text.trim(),
                    phone: phoneCtrl.text.trim(),
                    currentPassword: currentPasswordCtrl.text.trim(),
                    newPassword: newPasswordCtrl.text.isNotEmpty ? newPasswordCtrl.text.trim() : null,
                    image: selectedImage,
                  );

                  if (authVM.error != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(authVM.error!),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Profil mis à jour avec succès !"),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }

                  setState(() {
                    editName = false;
                    editEmail = false;
                    editPhone = false;
                    editPassword = false;
                    currentPasswordCtrl.clear();
                    newPasswordCtrl.clear();
                    confirmPasswordCtrl.clear();
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: child,
    );
  }

  Widget _infoGreenCard(user) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE9FBEF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF16A34A), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.calendar_month, color: Color(0xFF22C55E)),
              SizedBox(width: 10),
              Text(
                "Membre depuis",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            _formatDate(user.registrationDate),
            style: const TextStyle(
              color: Color(0xFF16A34A),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("ID du compte", style: TextStyle(fontSize: 12)),
              Text(
                "user-${user.id}",
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _roleCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3E8FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF9333EA), width: 1.5),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xFF9333EA),
            child: Icon(Icons.emoji_events, color: Colors.white),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Créateur d'Équipe",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Text("Vous avez créé l'équipe", style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF9333EA),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "ACTIF",
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _playerCodeCard(user) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF2563EB), width: 1.5),
      ),
      child: Column(
        children: [
          const Icon(Icons.group_outlined, size: 32, color: Color(0xFF2563EB)),
          const SizedBox(height: 8),
          const Text(
            "Mon code de joueur",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          const Text(
            "Partagez ce code pour permettre à d'autres de vous inviter dans leur équipe",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF2563EB)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              user.playerCode ?? "—",
              style: const TextStyle(
                fontSize: 18,
                letterSpacing: 4,
                color: Color(0xFF2563EB),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.copy, color: Colors.white),
              label: const Text(
                "Copier mon code",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                if (user.playerCode == null || user.playerCode!.isEmpty) return;

                Clipboard.setData(ClipboardData(text: user.playerCode!));

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Code du joueur copié"),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _editableField({
    required String label,
    required IconData icon,
    required bool isEditing,
    required VoidCallback onToggle,
    required List<Widget> fields,
    String? value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _iconBgColor(icon),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: _iconColor(icon), size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              ElevatedButton.icon(
                icon: Icon(isEditing ? Icons.save : Icons.edit, size: 16),
                label: Text(isEditing ? "Enregistrer" : "Modifier"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isEditing
                      ? const Color(0xFF22C55E)
                      : const Color(0xFFE5E7EB),
                  foregroundColor: isEditing
                      ? Colors.white
                      : const Color(0xFF374151),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  elevation: isEditing ? 2 : 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: onToggle,
              ),
            ],
          ),

          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState: isEditing
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: value == null
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(value, style: const TextStyle(fontSize: 14)),
                    ),
                  ),
            secondChild: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(children: fields),
            ),
          ),
        ],
      ),
    );
  }

  Widget styledInputField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    bool obscure = false,
    Widget? suffix,
  }) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
          suffixIcon: suffix,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "-";
    return "${date.day} ${_month(date.month)} ${date.year}";
  }

  Color _iconColor(IconData icon) {
    if (icon == Icons.person_outline) return const Color(0xFF22C55E); // vert
    if (icon == Icons.phone_outlined) return const Color(0xFF2563EB); // bleu
    if (icon == Icons.email_outlined) return const Color(0xFF9333EA); // violet
    if (icon == Icons.lock_outline) return const Color(0xFFEF4444); // rouge
    return Colors.grey;
  }

  Color _iconBgColor(IconData icon) {
    Color c = _iconColor(icon);
    return c.withOpacity(0.15); // cercle plus clair
  }

  String _month(int m) {
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
      "décembre",
    ];
    return months[m - 1];
  }
}
