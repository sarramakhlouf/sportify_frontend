import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportify_frontend/presentation/viewmodels/auth_viewmodel.dart';
import 'package:sportify_frontend/presentation/viewmodels/team_viewmodel.dart';
import 'package:sportify_frontend/presentation/widgets/create_team/team_color_picker.dart';
import 'package:sportify_frontend/presentation/widgets/create_team/team_form_header.dart';
import 'package:sportify_frontend/presentation/widgets/create_team/team_image_picker.dart';
import 'package:sportify_frontend/presentation/widgets/create_team/team_preview_card.dart';
import 'package:sportify_frontend/presentation/widgets/create_team/team_section_title.dart';

class CreateTeamScreen extends StatefulWidget {
  const CreateTeamScreen({super.key});

  @override
  State<CreateTeamScreen> createState() => _CreateTeamScreenState();
}

class _CreateTeamScreenState extends State<CreateTeamScreen> {
  final nameCtrl = TextEditingController();
  final cityCtrl = TextEditingController();

  String selectedColor = '#22C55E';
  File? teamLogo;

  bool get isFormValid => nameCtrl.text.trim().isNotEmpty;

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
      bottomNavigationBar: _bottomBar(teamVM, authVM),
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
                  const TeamFormHeader(),
                  const SizedBox(height: 6),
                  const Text(
                    'Créez votre équipe et commencez à jouer',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),

                  const TeamSectionTitle(
                    icon: Icons.photo_camera_outlined,
                    title: "Logo de l'équipe",
                  ),
                  const SizedBox(height: 10),
                  TeamImagePicker(
                    image: teamLogo,
                    onPick: (file) => setState(() => teamLogo = file),
                  ),

                  const SizedBox(height: 20),
                  const TeamSectionTitle(
                    icon: Icons.badge_outlined,
                    title: "Nom de l'équipe",
                  ),
                  const SizedBox(height: 6),
                  _textField(nameCtrl, 'Nom', required: true),

                  const SizedBox(height: 16),
                  const TeamSectionTitle(
                    icon: Icons.location_on_outlined,
                    title: "Ville (optionnel)",
                  ),
                  const SizedBox(height: 6),
                  _textField(cityCtrl, 'Ex: Tunis'),

                  const SizedBox(height: 20),
                  const TeamSectionTitle(
                    icon: Icons.palette_outlined,
                    title: "Couleur de l'équipe",
                  ),
                  const SizedBox(height: 10),
                  TeamColorPicker(
                    selectedColor: selectedColor,
                    onSelect: (color) =>
                        setState(() => selectedColor = color),
                  ),

                  if (nameCtrl.text.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    TeamPreviewCard(
                      teamName: nameCtrl.text,
                      colorHex: selectedColor,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
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

  Widget _bottomBar(TeamViewModel teamVM, AuthViewModel authVM) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
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
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF22C55E),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          child: teamVM.isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
                  "Créer l'équipe",
                  style: TextStyle(color: Colors.white),
                ),
        ),
      ),
    );
  }
}
