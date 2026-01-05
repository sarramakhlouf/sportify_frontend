import 'package:flutter/material.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF22C55E),
      unselectedItemColor: Colors.grey,
      selectedIconTheme: const IconThemeData(
        size: 22, // icône fine
        color: Color(0xFF22C55E),
      ),
      unselectedIconTheme: const IconThemeData(
        size: 20, // icône fine non sélectionnée
        color: Colors.grey,
      ),
      selectedLabelStyle: const TextStyle(
        fontSize: 10, // texte plus petit
        fontWeight: FontWeight.w300, // thin
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w300,
      ),
      iconSize: 22, // taille globale icônes
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.groups_outlined),
          label: 'Formation',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.location_on_outlined),
          label: 'Terrain',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu_outlined),
          label: 'Menu',
        ),
      ],
    );
  }
}
