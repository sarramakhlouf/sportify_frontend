import 'package:flutter/material.dart';

class TeamLogo extends StatelessWidget {
  final String? logoUrl;
  final double size;

  const TeamLogo({super.key, this.logoUrl, this.size = 42});

  @override
  Widget build(BuildContext context) {
    if (logoUrl == null || logoUrl!.isEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(size / 2),
        ),
        child: const Icon(Icons.group, color: Colors.grey),
      );
    }

    return ClipOval(
      child: Image.network(
        logoUrl!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return SizedBox(
            width: size,
            height: size,
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(size / 2),
            ),
            child: const Icon(Icons.group, color: Colors.grey),
          );
        },
      ),
    );
  }
}
