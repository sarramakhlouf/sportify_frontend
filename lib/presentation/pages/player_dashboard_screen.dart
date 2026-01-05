import 'package:flutter/material.dart';
import 'package:sportify_frontend/core/constants/assets.dart';
import 'package:sportify_frontend/core/theme/app_colors.dart';
import 'package:sportify_frontend/presentation/pages/main_layout.dart';
import 'package:sportify_frontend/presentation/widgets/action_card.dart';
import 'package:sportify_frontend/presentation/widgets/info_card.dart';

class PlayerDashboardScreen extends StatelessWidget {
  const PlayerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentIndex: 0,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= Header =================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Logo au lieu de texte + icône
                Image.asset(
                  AppAssets.logo,
                  height: 36,
                  fit: BoxFit.contain,
                ),
                CircleAvatar(
                  backgroundColor: Colors.grey.shade200,
                  child: const Icon(Icons.person, color: Colors.black87),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ================= Action Cards =================
            Row(
              children: [
                Expanded(
                  child: ActionCard(
                    title: 'CRÉER\nUNE ÉQUIPE',
                    color: Colors.black,
                    icon: Icons.group, // thin et blanc
                    iconColor: Colors.white,
                    onTap: () {
                      Navigator.pushNamed(context, '/create_team');
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ActionCard(
                    title: 'RÉSERVER\nUN TERRAIN',
                    color: AppColors.primary,
                    icon: Icons.sports_soccer, // thin et blanc
                    iconColor: Colors.white,
                    onTap: () {},
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ================= Info Cards =================
            Row(
              children: [
                Expanded(
                  child: InfoCard(
                    title: 'Mes équipes',
                    subtitle: 'Aucune équipe',
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

            // ================= Mon équipe =================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Mon équipe',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  icon: const Icon(
                    Icons.add,
                    size: 18,
                    color: Colors.white,
                  ),
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

            const SizedBox(height: 24),

            // ================= Prochain match =================
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
  }
}
