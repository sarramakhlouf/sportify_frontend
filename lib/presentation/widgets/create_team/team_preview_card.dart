import 'dart:io';
import 'package:flutter/material.dart';

class TeamPreviewCard extends StatelessWidget {
  final String teamName;
  final Color teamColor;
  final File? teamLogo;

  const TeamPreviewCard({
    super.key,
    required this.teamName,
    this.teamColor = const Color(0xFF22C55E),
    this.teamLogo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: teamColor,
              borderRadius: BorderRadius.circular(8),
              image: teamLogo != null
                  ? DecorationImage(
                      image: FileImage(teamLogo!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: teamLogo == null
                ? const Icon(
                    Icons.group,
                    color: Colors.white,
                    size: 24,
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              teamName,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}