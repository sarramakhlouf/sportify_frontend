import 'package:flutter/material.dart';

class InfoGreenCard extends StatelessWidget {
  final String memberSince;
  final String accountId;

  const InfoGreenCard({
    super.key,
    required this.memberSince,
    required this.accountId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE9FBEF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF16A34A), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.calendar_month, color: Color(0xFF22C55E)),
              SizedBox(width: 10),
              Text("Membre depuis",
                  style: TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 6),
          Text(memberSince,
              style: const TextStyle(
                  color: Color(0xFF16A34A),
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("ID du compte", style: TextStyle(fontSize: 12)),
              Text(accountId,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}
