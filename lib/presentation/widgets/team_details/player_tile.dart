import 'package:flutter/material.dart';
import 'package:sportify_frontend/core/theme/app_colors.dart';

class PlayerTile extends StatelessWidget {
  final String name;
  final String role;
  final bool isCreator;
  final bool isYou;

  const PlayerTile({
    super.key,
    required this.name,
    required this.role,
    this.isCreator = false,
    this.isYou = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            offset: const Offset(0, 4),
            color: Colors.black.withOpacity(0.06),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 22,
            backgroundColor: Colors.grey,
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    _Tag(role.toUpperCase()),
                    if (isCreator)
                      const _Tag(
                        "👑 CRÉATEUR",
                        primary: true,
                      ),
                    if (isYou)
                      const _Tag(
                        "VOUS",
                        secondary: true,
                      ),
                  ],
                ),
              ],
            ),
          ),

          const Icon(
            Icons.emoji_events_outlined,
            size: 18,
            color: AppColors.greyText,
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  final bool primary;
  final bool secondary;

  const _Tag(
    this.text, {
    this.primary = false,
    this.secondary = false,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;

    if (primary) {
      bgColor = AppColors.primaryGreen;
      textColor = Colors.white;
    } else if (secondary) {
      bgColor = Colors.blue.shade100;
      textColor = Colors.blue.shade700;
    } else {
      bgColor = AppColors.lightGreen;
      textColor = AppColors.primaryGreen;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }
}

