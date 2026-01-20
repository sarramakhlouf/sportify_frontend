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
    print('=== TeamCard Build ===');
    print('Team Name: $teamName');
    print('Team Logo: $teamLogo');
    print('Team Logo is null: ${teamLogo == null}');
    print('Team Logo is empty: ${teamLogo?.isEmpty}');
    print('Team Logo length: ${teamLogo?.length}');
    
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
                    color: teamLogo != null && teamLogo!.isNotEmpty
                        ? Colors.transparent
                        : Colors.black,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: _buildLogoWidget(),
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

  Widget _buildLogoWidget() {
    if (teamLogo == null || teamLogo!.isEmpty) {
      debugPrint('Logo is null or empty - showing default icon');
      return const Icon(Icons.sports_soccer, color: Colors.white);
    }

    debugPrint('Logo value: "$teamLogo"');
    debugPrint('Logo starts with http: ${teamLogo!.startsWith('http')}');
    debugPrint('Logo starts with https: ${teamLogo!.startsWith('https')}');
    debugPrint('Logo starts with assets: ${teamLogo!.startsWith('assets')}');

    if (teamLogo!.startsWith('http://') || teamLogo!.startsWith('https://')) {
      debugPrint('Loading network image from: $teamLogo');
      return Image.network(
        teamLogo!,
        width: 44,
        height: 44,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          final progress = loadingProgress.cumulativeBytesLoaded / 
              (loadingProgress.expectedTotalBytes ?? 1);
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              value: progress,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          debugPrint('ERROR loading network image:');
          debugPrint('Error: $error');
          debugPrint('StackTrace: $stackTrace');
          return const Icon(Icons.sports_soccer, color: Colors.white);
        },
      );
    }

    if (teamLogo!.startsWith('assets/')) {
      debugPrint('Loading asset image from: $teamLogo');
      return Image.asset(
        teamLogo!,
        width: 44,
        height: 44,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          debugPrint('ERROR loading asset image:');
          debugPrint('Error: $error');
          debugPrint('StackTrace: $stackTrace');
          return const Icon(Icons.sports_soccer, color: Colors.white);
        },
      );
    }
    
    return Image.network(
      teamLogo!,
      width: 44,
      height: 44,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        debugPrint('ERROR loading image (default case):');
        debugPrint('Error: $error');
        debugPrint('StackTrace: $stackTrace');
        return const Icon(Icons.sports_soccer, color: Colors.white);
      },
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