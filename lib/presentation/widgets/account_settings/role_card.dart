import 'package:flutter/material.dart';

class RoleCard extends StatelessWidget {
  const RoleCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3E8FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF9333EA), width: 1.5),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xFF9333EA),
            child: Icon(Icons.emoji_events, color: Colors.white),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Créateur d'Équipe",
                    style: TextStyle(fontWeight: FontWeight.w600)),
                Text("Vous avez créé l'équipe",
                    style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF9333EA),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text("ACTIF",
                style: TextStyle(color: Colors.white, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
