import 'package:flutter/material.dart';

class TeamPreviewCard extends StatelessWidget {
  final String teamName;
  final String colorHex;

  const TeamPreviewCard({
    super.key,
    required this.teamName,
    required this.colorHex,
  });

  Color get color =>
      Color(int.parse(colorHex.replaceFirst('#', '0xff')));

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color,
            child: const Icon(Icons.group, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              teamName,
              style: const TextStyle(fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
