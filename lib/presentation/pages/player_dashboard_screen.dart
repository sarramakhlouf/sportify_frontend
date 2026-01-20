import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportify_frontend/core/constants/api_constants.dart';
import 'package:sportify_frontend/core/constants/assets.dart';
import 'package:sportify_frontend/core/theme/app_colors.dart';
import 'package:sportify_frontend/presentation/layouts/main_layout.dart';
import 'package:sportify_frontend/presentation/pages/invite_player_sheet.dart';
import 'package:sportify_frontend/presentation/pages/my_teams_screen.dart';
import 'package:sportify_frontend/presentation/pages/teams_screen.dart';
import 'package:sportify_frontend/presentation/viewmodels/auth_viewmodel.dart';
import 'package:sportify_frontend/presentation/widgets/player_dashboard/action_card.dart';
import 'package:sportify_frontend/presentation/widgets/player_dashboard/info_card.dart';
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
    final authVM = context.read<AuthViewModel>();
    return Consumer<TeamViewModel>(
      builder: (context, teamVM, child) {
        final team = teamVM.selectedTeam;

        debugPrint("UI: selectedTeam=${team?.name}, players=${teamVM.players.length}");
        debugPrint("url image: ${authVM.currentUser!.profileImageUrl}");

        return MainLayout(
          currentIndex: 0,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      AppAssets.logoRemovebg,
                      height: 36,
                      fit: BoxFit.contain,
                    ),
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
                                  "${ApiConstants.imageUrl}${team.logoUrl!}",
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

                Row(
                  children: [
                    Expanded(
                      child: ActionCard(
                        title: 'CRÉER\nUNE ÉQUIPE',
                        background: const Color(0xFF0E1621),
                        onTap: () => Navigator.pushNamed(context, '/create_team'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ActionCard(
                        title: 'RÉSERVER\nUN TERRAIN',
                        background: const Color(0xFF1DB954),
                        onTap: () {},
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TeamsScreen(),
                            ),
                          );
                        },
                        child: InfoCard(
                          title: 'Mes équipes',
                          subtitle: teamVM.teams.isEmpty
                              ? 'Aucune équipe créée'
                              : '${teamVM.teams.length} équipes créées',
                          background: const Color(0xFF1DB954),
                          icon: Icons.emoji_events,
                          badgeText: teamVM.teams.isEmpty ? null : '${teamVM.teams.length}',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InfoCard(
                        title: 'Dernier Match',
                        subtitle: 'Aucun vote reçu',
                        background: const Color(0xFF8B5CF6),
                        avatarUrl: (authVM.currentUser?.profileImageUrl != null &&
                                authVM.currentUser!.profileImageUrl!.isNotEmpty)
                            ? '${authVM.currentUser!.profileImageUrl}'
                            : null,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Mon équipe',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (team == null || team.id == null) {
                          debugPrint("Il faut sélectionner une équipe");
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Veuillez sélectionner une équipe'),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 2),
                            ),
                          );
                          return;
                        }
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

                if (team != null && teamVM.players.isNotEmpty)
                  SizedBox(
                    height: 120,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: teamVM.players.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 14),
                      itemBuilder: (context, index) {
                        final player = teamVM.players[index];
                        return Column(
                          children: [
                            Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: AppColors.primary,
                                  width: 2,
                                ),
                              ),
                              child: player.avatarUrl != null && player.avatarUrl!.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.network(
                                        "${ApiConstants.imageUrl}${player.avatarUrl!}",
                                        width: 72,
                                        height: 72,
                                        fit: BoxFit.cover,
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return const Center(
                                            child: CircularProgressIndicator(strokeWidth: 2),
                                          );
                                        },
                                        errorBuilder: (context, error, stackTrace) {
                                          print('Erreur chargement image: $error');
                                          return Center(
                                            child: Text(
                                              player.name.isNotEmpty
                                                  ? player.name[0].toUpperCase()
                                                  : '?',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  : Center(
                                      child: Text(
                                        player.name.isNotEmpty
                                            ? player.name[0].toUpperCase()
                                            : '?',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24,
                                        ),
                                      ),
                                    ),
                            ),
                            const SizedBox(height: 4),
                            Flexible(
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

                const SizedBox(height: 30),

                // Boutons Matchs planifiés / Matchs joués
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          // Action pour matchs planifiés
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey.shade300, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(
                          'Matchs planifiés',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Action pour matchs joués
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Matchs joués',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Carte de match (VS)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // Équipe 1
                          Column(
                            children: [
                              Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                    width: 2,
                                  ),
                                ),
                                child: team?.logoUrl != null && team!.logoUrl!.isNotEmpty
                                    ? ClipOval(
                                        child: Image.network(
                                          "${ApiConstants.imageUrl}${team.logoUrl!}",
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) => const Icon(
                                            Icons.sports_soccer,
                                            size: 35,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      )
                                    : const Icon(
                                        Icons.sports_soccer,
                                        size: 35,
                                        color: Colors.grey,
                                      ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                team?.name ?? 'FC Makina',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),

                          // VS
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              'vs',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),

                          // Équipe 2
                          Column(
                            children: [
                              Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.sports_soccer,
                                  size: 35,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'FC Mayorka',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Bouton d'action (ex: voir détails)
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}