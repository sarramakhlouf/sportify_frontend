import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportify_frontend/core/constants/assets.dart';
import 'package:sportify_frontend/core/constants/api_constants.dart';
import 'package:sportify_frontend/core/theme/app_colors.dart';
import 'package:sportify_frontend/presentation/layouts/main_layout.dart';
import 'package:sportify_frontend/presentation/pages/invite_player_sheet.dart';
import 'package:sportify_frontend/presentation/pages/my_teams_screen.dart';
import 'package:sportify_frontend/presentation/viewmodels/auth_viewmodel.dart';
import 'package:sportify_frontend/presentation/widgets/action_card.dart';
import 'package:sportify_frontend/presentation/widgets/info_card.dart';
import 'package:sportify_frontend/presentation/viewmodels/team_viewmodel.dart';

class PlayerDashboardScreen extends StatefulWidget {
  const PlayerDashboardScreen({super.key});

  @override
  State<PlayerDashboardScreen> createState() => _PlayerDashboardScreenState();
}


class _PlayerDashboardScreenState extends State<PlayerDashboardScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final teamVM = context.read<TeamViewModel>();
      final authVM = context.read<AuthViewModel>();

      final userId = authVM.currentUser?.id;
      final token = await authVM.getToken();

      if (userId != null && token != null) {
        await teamVM.fetchTeams(
          ownerId: userId,
          token: token,
        );
      } else {
        debugPrint("User ou token manquant");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TeamViewModel>(
      builder: (context, teamVM, child) {
        final team = teamVM.selectedTeam;

        debugPrint("UI: selectedTeam=${team?.name}, players=${teamVM.players.length}");

        return MainLayout(
          currentIndex: 0,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ================= HEADER =================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      AppAssets.logo,
                      height: 36,
                      fit: BoxFit.contain,
                    ),
                    // ===== AVATAR → OPEN MY TEAMS =====
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            opaque: false,
                            barrierColor: Colors.black.withOpacity(0.25),
                            pageBuilder: (_, __, ___) => const MyTeamsScreen(),
                            transitionsBuilder: (_, animation, __, child) =>
                                FadeTransition(opacity: animation, child: child),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        radius: 21,
                        backgroundColor: Colors.white,
                        child: ClipOval(
                          child: team?.logoUrl != null && team!.logoUrl!.isNotEmpty
                              ? Image.network(
                                  '${ApiConstants.baseUrl}${team.logoUrl!}',
                                  width: 42,
                                  height: 42,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      const Icon(Icons.group, size: 28, color: Colors.grey),
                                )
                              : const Icon(Icons.group, size: 28, color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // ================= ACTION CARDS =================
                Row(
                  children: [
                    Expanded(
                      child: ActionCard(
                        title: 'CRÉER\nUNE ÉQUIPE',
                        color: Colors.black,
                        icon: Icons.group,
                        iconColor: Colors.white,
                        onTap: () => Navigator.pushNamed(context, '/create_team'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ActionCard(
                        title: 'RÉSERVER\nUN TERRAIN',
                        color: AppColors.primary,
                        icon: Icons.sports_soccer,
                        iconColor: Colors.white,
                        onTap: () {},
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // ================= INFO CARDS =================
                Row(
                  children: [
                    Expanded(
                      child: InfoCard(
                        title: 'Mes équipes',
                        subtitle: teamVM.teams.isEmpty ? 'Aucune équipe' : '${teamVM.teams.length} équipes',
                        color: AppColors.primary,
                        icon: Icons.emoji_events,
                        iconColor: Colors.white,
                        iconBackgroundColor: AppColors.primary.withOpacity(0.2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InfoCard(
                        title: 'Dernier Match',
                        subtitle: 'Aucun vote reçu',
                        color: Colors.purple,
                        icon: Icons.star,
                        iconColor: Colors.white,
                        iconBackgroundColor: Colors.purple.withOpacity(0.2),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // ================= MON ÉQUIPE =================
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Mon équipe',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton.icon(
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
                                  teamId: team!.id!,
                                  senderId: context.read<AuthViewModel>().currentUser!.id,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      icon: const Icon(Icons.add, size: 18, color: Colors.white),
                      label: const Text(
                        'Inviter',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // ================= LISTE DES JOUEURS =================
                if (team != null && teamVM.players.isNotEmpty)
                  SizedBox(
                    height: 110,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: teamVM.players.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 14),
                      itemBuilder: (context, index) {
                        final player = teamVM.players[index];
                        return Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.primary, // ✅ bordure verte
                                  width: 2,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 28,
                                backgroundColor: Colors.grey.shade200,
                                backgroundImage: player.avatarUrl != null &&
                                        player.avatarUrl!.isNotEmpty
                                    ? NetworkImage(
                                        '${ApiConstants.baseUrl}${player.avatarUrl!}',
                                      )
                                    : null,
                                child: player.avatarUrl == null ||
                                        player.avatarUrl!.isEmpty
                                    ? Text(
                                        player.name.isNotEmpty
                                            ? player.name[0].toUpperCase()
                                            : '?',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      )
                                    : null,
                              ),
                            ),
                            const SizedBox(height: 6),
                            SizedBox(
                              width: 70,
                              child: Text(
                                player.name,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  )
                else if (team != null)
                  const Text(
                    'Aucun joueur dans cette équipe',
                    style: TextStyle(color: Colors.grey),
                  )
                else
                  const Text(
                    'Sélectionnez une équipe pour voir les joueurs',
                    style: TextStyle(color: Colors.grey),
                  ),


                const SizedBox(height: 24),

                // ================= PROCHAIN MATCH =================
                const Text(
                  'Le prochain match',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 140,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.emoji_events, size: 40, color: Colors.grey),
                      SizedBox(height: 10),
                      Text('Commencez votre aventure'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
