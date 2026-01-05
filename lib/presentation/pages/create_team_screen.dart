import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sportify_frontend/presentation/viewmodels/auth_viewmodel.dart';
import 'package:sportify_frontend/presentation/viewmodels/team_viewmodel.dart';

class CreateTeamScreen extends StatefulWidget {
  const CreateTeamScreen({super.key});

  @override
  State<CreateTeamScreen> createState() => _CreateTeamScreenState();
}

class _CreateTeamScreenState extends State<CreateTeamScreen> {
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController cityCtrl = TextEditingController();

  String selectedColor = '#22C55E';
  File? teamLogo;

  final List<String> colors = [
    '#22C55E',
    '#3B82F6',
    '#EF4444',
    '#F59E0B',
    '#8B5CF6',
    '#06B6D4',
  ];

  Color hexToColor(String hex) =>
      Color(int.parse(hex.replaceFirst('#', '0xff')));

  bool get isFormValid => nameCtrl.text.trim().isNotEmpty;

  Future<void> pickLogo() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (image != null) {
      setState(() => teamLogo = File(image.path));
    }
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    cityCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final teamVM = context.watch<TeamViewModel>();
    final authVM = context.read<AuthViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 12,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 12,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Annuler'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isFormValid
                        ? const Color(0xFF22C55E)
                        : Colors.grey.shade400,
                    disabledBackgroundColor: Colors.grey.shade400,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: (!isFormValid || teamVM.isLoading)
                      ? null
                      : () async {
                          final user = authVM.currentUser;
                          final token = await authVM.getToken();
                          if (user == null || token == null) return;

                          await teamVM.createTeam(
                            name: nameCtrl.text.trim(),
                            city: cityCtrl.text.trim(),
                            color: selectedColor,
                            ownerId: user.id,
                            token: token,
                            image: teamLogo,
                          );

                          if (teamVM.error == null && mounted) {
                            Navigator.pop(context);
                          }
                        },
                  child: teamVM.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Créer l\'équipe',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
          child: Center(
            child: Container(
              width: 520,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 20),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(context),
                  const SizedBox(height: 6),
                  const Text(
                    'Créez votre équipe et commencez à jouer',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  _sectionTitle(
                      icon: Icons.photo_camera_outlined,
                      title: 'Logo de l\'équipe'),
                  const SizedBox(height: 10),
                  _imagePicker(),
                  const SizedBox(height: 20),
                  _sectionTitle(
                      icon: Icons.badge_outlined,
                      title: 'Nom de l\'équipe'),
                  const SizedBox(height: 6),
                  _textField(nameCtrl, 'Nom', required: true),
                  const SizedBox(height: 16),
                  _sectionTitle(
                      icon: Icons.location_on_outlined,
                      title: 'Ville (optionnel)'),
                  const SizedBox(height: 6),
                  _textField(cityCtrl, 'Ex: Tunis'),
                  const SizedBox(height: 20),
                  _sectionTitle(
                      icon: Icons.palette_outlined,
                      title: 'Couleur de l\'équipe'),
                  const SizedBox(height: 10),
                  _colorPicker(),
                  if (nameCtrl.text.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _previewCard(),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Créer une équipe',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.close,
              size: 20,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle({required IconData icon, required String title}) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFF22C55E),
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  Widget _imagePicker() {
    return GestureDetector(
      onTap: pickLogo,
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFE5E7EB),
          borderRadius: BorderRadius.circular(12),
          image: teamLogo != null
              ? DecorationImage(
                  image: FileImage(teamLogo!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: teamLogo == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.cloud_upload,
                      color: Colors.grey,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Ajouter une photo',
                    style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Cliquez pour choisir une image',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              )
            : null,
      ),
    );
  }

  Widget _textField(TextEditingController ctrl, String hint,
      {bool required = false}) {
    return TextField(
      controller: ctrl,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: required && ctrl.text.isNotEmpty
            ? const Icon(Icons.check_circle, color: Colors.green)
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _colorPicker() {
    return Row(
      children: colors.map((hex) {
        final isSelected = selectedColor == hex;
        return GestureDetector(
          onTap: () => setState(() => selectedColor = hex),
          child: Container(
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(color: hexToColor(hex), width: 3)
                  : null,
            ),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: hexToColor(hex),
              child: isSelected
                  ? const Icon(Icons.check,
                      color: Colors.white, size: 16)
                  : null,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _previewCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8),
        ],
        color: Colors.white,
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: hexToColor(selectedColor),
            child: const Icon(Icons.group, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('APERÇU',
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
                Text(
                  nameCtrl.text.trim(),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
