import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportify_frontend/core/theme/app_colors.dart';
import 'package:sportify_frontend/data/models/player_model.dart';
import 'package:sportify_frontend/data/models/team_model.dart';
import 'package:sportify_frontend/presentation/pages/invite_player_sheet.dart';
import 'package:sportify_frontend/presentation/viewmodels/auth_viewmodel.dart';
import 'player_tile.dart';

class PlayersSection extends StatelessWidget {
  final List<PlayerModel> players;
  final TeamModel team;

  const PlayersSection({super.key, required this.players, required this.team});

  @override
  Widget build(BuildContext context) {
    final currentUserId = context.read<AuthViewModel>().currentUser?.id;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.groups_2_outlined,
                size: 30,
                color: AppColors.primaryGreen,
              ),
              const SizedBox(width: 6),
              Text(
                "Joueurs (${players.length})",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.lightGreen,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => Center(
                            child: FractionallySizedBox(
                              widthFactor: 0.9,
                              child: Material(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                                child: InvitePlayerSheet(
                                  teamId: team.id!,
                                  senderId: context
                                      .read<AuthViewModel>()
                                      .currentUser!
                                      .id,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.add,
                        size: 12,
                        color: AppColors.primaryGreen,
                      ),
                      label: const Text(
                        "Ajouter",
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.primaryGreen,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        minimumSize: const Size(0, 28),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (players.isEmpty)
            const Text("Aucun joueur", style: TextStyle(color: Colors.grey)),

          ...players.map(
            (player) => PlayerTile(
              name: player.name,
              avatarUrl: player.avatarUrl,
              role: player.role ?? 'MEMBRE',
              isCreator: player.role?.toUpperCase() == 'OWNER',
              isYou: player.id == currentUserId,
            ),
          ),
        ],
      ),
    );
  }
}