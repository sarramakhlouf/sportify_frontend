import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportify_frontend/presentation/pages/my_created_teams_screen.dart';
import 'package:sportify_frontend/presentation/viewmodels/auth_viewmodel.dart';
import 'package:sportify_frontend/presentation/viewmodels/team_viewmodel.dart';

class TeamsScreen extends StatelessWidget {
  const TeamsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: const BackButton(),
        centerTitle: true,
        title: const Text(
          "Équipes",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _actionCard(
              borderColor: const Color(0xFFB7E4C7),
              iconBg: const Color(0xFFEFFAF3),
              icon: Icons.emoji_events_outlined,
              iconColor: const Color(0xFF22C55E),
              title: "Mon équipe créée",
              subtitle: "Gérer mes équipes",
              onTap: () async {
                final authVM = context.read<AuthViewModel>();
                final teamVM = context.read<TeamViewModel>();

                final user = authVM.currentUser;
                final token = await authVM.getToken();

                if (user == null || token == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Utilisateur non connecté")),
                  );
                  return;
                }

                await teamVM.fetchTeams(
                  ownerId: user.id,
                  token: token,
                );

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MyCreatedTeamsScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            _actionCard(
              borderColor: const Color(0xFFD6E4FF),
              iconBg: const Color(0xFFF3F6FF),
              icon: Icons.group_outlined,
              iconColor: const Color(0xFF3B82F6),
              title: "Équipes dont je suis membre",
              subtitle: "Voir les équipes où je joue",
            ),

            const SizedBox(height: 16),

            _infoCard(),
          ],
        ),
      ),
    );
  }

  Widget _actionCard({
    required Color borderColor,
    required Color iconBg,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }


  Widget _infoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.groups_outlined,
              color: Colors.white,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Gérez vos équipes",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Créez votre équipe, rejoignez d'autres équipes et suivez vos adversaires pour améliorer vos performances.",
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF475569),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
