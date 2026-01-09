import 'package:flutter/material.dart';

class MenuItemModel {
  final String title;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String? badge;
  final Widget screen;

  MenuItemModel({
    required this.title,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    this.badge,
    required this.screen,
  });
}
