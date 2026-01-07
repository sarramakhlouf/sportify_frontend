import 'package:flutter/material.dart';

class PlayerAvatar extends StatelessWidget {
  final String? imageUrl;
  final double size;

  const PlayerAvatar({super.key, this.imageUrl, this.size = 60});

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return CircleAvatar(
        radius: size / 2,
        child: Icon(Icons.person, size: size / 2),
      );
    }

    return ClipOval(
      child: Image.network(
        imageUrl!,
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
          return CircleAvatar(
            radius: size / 2,
            child: Icon(Icons.person, size: size / 2),
          );
        },
      ),
    );
  }
}
