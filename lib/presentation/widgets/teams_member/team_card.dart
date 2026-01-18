import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TeamCard extends StatelessWidget {
  final String teamName;
  final String? teamLogo;
  final String teamRole;
  final String? city;
  final int playersCount;
  final DateTime? createdAt;
  final VoidCallback? onTap;

  const TeamCard({
    super.key,
    required this.teamName,
    this.teamLogo,
    required this.teamRole,
    this.city,
    required this.playersCount,
    this.createdAt,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final createdText = createdAt != null
        ? DateFormat('dd MMM', 'fr').format(createdAt!)
        : '-';
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF6F8FF),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFD6E4FF)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.sports_soccer, color: Colors.white),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        teamName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2563EB),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          teamRole,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.emoji_events_outlined,
                  color: Color(0xFF2563EB),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                _infoBox(
                  icon: Icons.people_outline,
                  title: 'Joueurs',
                  value: '$playersCount/12',
                ),
                const SizedBox(width: 12),
                _infoBox(
                  icon: Icons.calendar_today_outlined,
                  title: 'Créée',
                  value: createdText,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoBox({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: const Color(0xFF2563EB)),
            const SizedBox(width: 8),
            Text('$title\n$value', style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
