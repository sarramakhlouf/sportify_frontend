import 'package:flutter/material.dart';

class MemberInfoCard extends StatelessWidget {
  const MemberInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF2FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBFD3FF)),
      ),
      child: Row(
        children: const [
          Icon(Icons.person_outline, color: Color(0xFF2F80FF)),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Vous êtes membre\n\n'
              'En tant que membre, vous pouvez participer aux matchs '
              'et consulter les performances de l\'équipe.',
              style: TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
