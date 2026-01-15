import 'package:flutter/material.dart';

class TeamSectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  const TeamSectionTitle({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF22C55E), size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
