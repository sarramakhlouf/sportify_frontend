import 'package:flutter/material.dart';

class ActionCard extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback onTap;
  final IconData? icon; 
  final Color? iconColor;

  const ActionCard({
    super.key,
    required this.title,
    required this.color,
    required this.onTap,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w400, 
                  height: 1.2,
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Icon(
                icon ?? Icons.add,
                color: iconColor ?? Colors.white,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
