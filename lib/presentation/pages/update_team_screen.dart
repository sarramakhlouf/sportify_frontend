import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportify_frontend/core/constants/api_constants.dart';
import 'package:sportify_frontend/data/models/team_model.dart';
import 'package:sportify_frontend/presentation/viewmodels/team_viewmodel.dart';
import 'package:image_picker/image_picker.dart';

class UpdateTeamDialog extends StatefulWidget {
  final TeamModel team;
  final String token;

  const UpdateTeamDialog({super.key, required this.team, required this.token});

  @override
  State<UpdateTeamDialog> createState() => _UpdateTeamDialogState();
}

class _UpdateTeamDialogState extends State<UpdateTeamDialog> {
  late TextEditingController nameController;
  late TextEditingController cityController;

  File? newLogo;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.team.name);
    cityController = TextEditingController(text: widget.team.city ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    cityController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (picked != null) {
      setState(() {
        newLogo = File(picked.path);
      });
      debugPrint("Image sélectionnée: ${picked.path}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TeamViewModel>();

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Modifier l'équipe",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context, false);
                    },
                    child: const Icon(Icons.close),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFB8E6D5),
                        ),
                        child: newLogo != null
                            ? ClipOval(
                                child: Image.file(
                                  newLogo!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : (widget.team.logoUrl != null &&
                                    widget.team.logoUrl!.isNotEmpty)
                                ? ClipOval(
                                    child: Image.network(
                                      "${ApiConstants.imageUrl}${widget.team.logoUrl!}",
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : const Icon(
                                    Icons.groups,
                                    size: 40,
                                    color: Color(0xFF00C853),
                                  ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Modifiez les informations de votre\néquipe",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              _label("Nom de l'équipe"),
              _textField(controller: nameController),

              const SizedBox(height: 16),

              _label("Ville"),
              _textField(controller: cityController),

              const SizedBox(height: 16),

              _label("Logo"),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: newLogo != null
                        ? Image.file(
                            newLogo!,
                            width: 50,
                            height: 50,
                            fit: BoxFit.contain,
                          )
                        : (widget.team.logoUrl != null &&
                                widget.team.logoUrl!.isNotEmpty)
                            ? Image.network(
                                "${ApiConstants.imageUrl}${widget.team.logoUrl!}",
                                width: 50,
                                height: 50,
                                fit: BoxFit.contain,
                              )
                            : Icon(
                                Icons.cloud_upload_outlined,
                                size: 40,
                                color: Colors.grey.shade400,
                              ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.grey.shade100,
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        "Annuler",
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: vm.isLoading
                          ? null
                          : () async {
                              debugPrint(
                                "========================================",
                              );
                              debugPrint("Bouton Mettre à jour cliqué");
                              debugPrint(
                                "========================================",
                              );

                              final newName = nameController.text.trim();
                              final newCity = cityController.text.trim();

                              debugPrint("Team ID: ${widget.team.id}");
                              debugPrint("Ancien nom: ${widget.team.name}");
                              debugPrint("Nouveau nom: $newName");
                              debugPrint("Ancienne ville: ${widget.team.city}");
                              debugPrint("Nouvelle ville: $newCity");
                              debugPrint(
                                "Nouveau logo: ${newLogo != null ? 'Oui' : 'Non'}",
                              );

                              final updatedTeam = widget.team.copyWith(
                                name: newName,
                                city: newCity,
                              );

                              await vm.updateTeam(
                                teamId: widget.team.id!,
                                updatedTeam: updatedTeam,
                                image: newLogo,
                                token: widget.token,
                              );

                              if (!mounted) {
                                return;
                              }

                              if (vm.error == null) {
                                debugPrint("SUCCÈS");
                                Navigator.pop(context, true);
                              } else {
                                debugPrint("ERREUR: ${vm.error}");
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Erreur: ${vm.error}'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00C853),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: vm.isLoading
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              "Mettre à jour",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Delete button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: vm.isLoading
                      ? null
                      : () async {
                          // Show confirmation dialog
                          final confirmDelete = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              title: const Text(
                                "Supprimer l'équipe",
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                              content: Text(
                                "Êtes-vous sûr de vouloir supprimer '${widget.team.name}' ? Cette action est irréversible.",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text(
                                    "Annuler",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text(
                                    "Supprimer",
                                    style: TextStyle(color: Color(0xFFE53935)),
                                  ),
                                ),
                              ],
                            ),
                          );

                          if (confirmDelete == true && mounted) {
                            debugPrint("========================================");
                            debugPrint("Suppression de l'équipe: ${widget.team.id}");
                            debugPrint("========================================");

                            await vm.deleteTeam(
                              teamId: widget.team.id!,
                              token: widget.token,
                            );

                            if (!mounted) return;

                            if (vm.error == null) {
                              debugPrint("ÉQUIPE SUPPRIMÉE AVEC SUCCÈS");
                              
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Équipe supprimée avec succès'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              
                              // Fermer le dialog et signaler la suppression
                              Navigator.pop(context, true);
                            } else {
                              debugPrint("ERREUR SUPPRESSION: ${vm.error}");
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Erreur: ${vm.error}'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFF0F0),
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.delete_outline,
                        color: Color(0xFFE53935),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Supprimer l'équipe",
                        style: TextStyle(
                          color: Color(0xFFE53935),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _textField({required TextEditingController controller}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF00C853), width: 2),
        ),
      ),
    );
  }
}