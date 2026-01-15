import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PlayerCodeCard extends StatelessWidget {
  final String code;

  const PlayerCodeCard({super.key, required this.code});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF2563EB), width: 1.5),
      ),
      child: Column(
        children: [
          const Icon(Icons.group_outlined,
              size: 32, color: Color(0xFF2563EB)),
          const SizedBox(height: 8),
          const Text("Mon code de joueur",
              style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF2563EB)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              code,
              style: const TextStyle(
                  fontSize: 18,
                  letterSpacing: 4,
                  color: Color(0xFF2563EB),
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.copy, color: Colors.white),
              label: const Text("Copier mon code",
                  style: TextStyle(color: Colors.white)),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: code));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Code du joueur copié"),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
