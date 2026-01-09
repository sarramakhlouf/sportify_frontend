import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:provider/provider.dart';
import 'package:sportify_frontend/core/theme/app_colors.dart';
import 'package:sportify_frontend/presentation/viewmodels/auth_viewmodel.dart';
import 'package:sportify_frontend/presentation/viewmodels/team_viewmodel.dart';

class MyTeamsScreen extends StatefulWidget {
  const MyTeamsScreen({super.key});

  @override
  State<MyTeamsScreen> createState() => _MyTeamsScreenState();
}

class _MyTeamsScreenState extends State<MyTeamsScreen> {
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      final authVM = context.read<AuthViewModel>();
      final teamVM = context.read<TeamViewModel>();

      final ownerId = authVM.currentUser?.id;

      if (ownerId == null) {
        print("Utilisateur non connecté");
        return;
      }

      authVM.getToken().then((token) {
        if (token != null) {
          teamVM.fetchTeams(ownerId: ownerId, token: token).then((_) {
            print("Teams récupérées : ${teamVM.teams.map((t) => t.id).toList()}");
          });
        } else {
          print("Token null, impossible de récupérer les équipes");
        }
      });

      _isInit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final teamVM = context.watch<TeamViewModel>();
    final authVM = context.read<AuthViewModel>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // ================= BLUR BACKGROUND =================
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(color: AppColors.background.withOpacity(0.6)),
          ),

          // ================= CONTENT =================
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ================= HEADER =================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mes Équipes',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Sélectionnez votre équipe',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.close),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ================= CREATE TEAM =================
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/create_team'),
                    child: DottedBorder(
                      color: AppColors.primary,
                      strokeWidth: 1.4,
                      dashPattern: const [6, 4],
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(18),
                      child: Container(
                        height: 82,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Center(
                          child: Text(
                            '+ Nouvelle équipe',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  const Text(
                    '🏆  MON ÉQUIPE CRÉÉE',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ================= GRID =================
                  if (teamVM.isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (teamVM.error != null)
                    Text(
                      teamVM.error!,
                      style: const TextStyle(color: Colors.red),
                    )
                  else if (teamVM.teams.isEmpty)
                    const Text('Aucune équipe créée')
                  else
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.78,
                      ),
                      itemCount: teamVM.teams.length,
                      itemBuilder: (context, index) {
                        final team = teamVM.teams[index];

                        return GestureDetector(
                          onTap: () async {
                            final token = await authVM.getToken();
                            final ownerId = authVM.currentUser?.id;

                            print("team.id: ${team.id}");
                            print("ownerId: $ownerId");
                            print("token: $token");

                            if (token == null || ownerId == null || team.id == null) {
                              print("Une valeur est null, on n'appelle pas selectTeam");
                              return;
                            }

                            if (team.isActivated) {
                              print("Désactivation de l'équipe ${team.id}");
                              await teamVM.deactivateTeam(
                                teamId: team.id!,
                                token: token,
                              );
                            } else {
                              print("Activation de l'équipe ${team.id}");
                              await teamVM.activateTeam(
                                teamId: team.id!,
                                ownerId: ownerId,
                                token: token,
                              );
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: team.isActivated
                                    ? AppColors.primary
                                    : AppColors.primary.withOpacity(0.3),
                                width: 1.6,
                              ),
                            ),
                            child: Column(
                              children: [
                                // 🔒 PLACE RÉSERVÉE POUR LE BADGE
                                SizedBox(
                                  height: 26,
                                  child: team.isActivated
                                      ? Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              'ACTIF',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        )
                                      : null,
                                ),

                                const SizedBox(height: 12),

                                Container(
                                  width: 72,
                                  height: 72,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: team.logoUrl != null
                                      ? Image.network(
                                          "https://cinderella-unfasciated-imogene.ngrok-free.dev${team.logoUrl!}",
                                          fit: BoxFit.contain,
                                        )
                                      : const Icon(Icons.sports_soccer),
                                ),

                                const SizedBox(height: 14),

                                Text(
                                  team.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  team.city ?? '',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
