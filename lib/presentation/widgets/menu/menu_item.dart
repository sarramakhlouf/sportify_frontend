import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportify_frontend/data/models/menuItem_model.dart';
import 'package:sportify_frontend/presentation/viewmodels/auth_viewmodel.dart';

class MenuItem extends StatelessWidget {
  final MenuItemModel item;

  const MenuItem({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (item.title == "Déconnexion") {
          await context.read<AuthViewModel>().logout();
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/role',
            (_) => false,
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => item.screen),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: item.iconBg,
              child: Icon(item.icon, color: item.iconColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                item.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (item.badge != null)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  item.badge!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
