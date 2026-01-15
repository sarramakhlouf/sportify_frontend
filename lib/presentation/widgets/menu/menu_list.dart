import 'package:flutter/material.dart';
import 'package:sportify_frontend/data/models/menuItem_model.dart';
import 'package:sportify_frontend/presentation/widgets/menu/menu_item.dart';

class MenuList extends StatelessWidget {
  final List<MenuItemModel> menuItems;

  const MenuList({
    super.key,
    required this.menuItems,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        return MenuItem(item: menuItems[index]);
      },
    );
  }
}
