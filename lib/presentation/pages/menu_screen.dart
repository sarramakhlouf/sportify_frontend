import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportify_frontend/data/models/menuItem_model.dart';
import 'package:sportify_frontend/presentation/layouts/main_layout.dart';
import 'package:sportify_frontend/presentation/pages/player_dashboard_screen.dart';
import 'package:sportify_frontend/presentation/viewmodels/auth_viewmodel.dart';
import 'package:sportify_frontend/presentation/viewmodels/invitation_viewmodel.dart';
import 'package:sportify_frontend/presentation/viewmodels/notification_viewmodel.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifVM = context.watch<NotificationViewModel>();
    final inviteVM = context.watch<InvitationViewModel>();

    final menuItems = <MenuItemModel>[
      MenuItemModel(
        title: "Notification",
        icon: Icons.notifications,
        badge: notifVM.unreadCount.toString(),
        iconBg: const Color(0xFFE8F7EF),
        iconColor: Colors.green,
        screen: const PlayerDashboardScreen(),
      ),
      MenuItemModel(
        title: "Invitations de Match",
        icon: Icons.mail,
        badge: "0",
        iconBg: const Color(0xFFEFF6FF),
        iconColor: Colors.green,
        screen: const PlayerDashboardScreen(),
      ),
      MenuItemModel(
        title: "Invitations d'Équipe",
        icon: Icons.group_add,
        badge: inviteVM.pendingCount.toString(),
        iconBg: const Color(0xFFEFF6FF),
        iconColor: Colors.green,
        screen: const PlayerDashboardScreen(),
      ),
      MenuItemModel(
        title: "Équipes",
        icon: Icons.groups,
        iconBg: const Color(0xFFEFF6FF),
        iconColor: Colors.blue,
        screen: const PlayerDashboardScreen(),
      ),
      MenuItemModel(
        title: "Résultats",
        icon: Icons.trending_up,
        iconBg: const Color(0xFFFFF4E5),
        iconColor: Colors.orange,
        screen: const PlayerDashboardScreen(),
      ),
      MenuItemModel(
        title: "Calendrier de match",
        icon: Icons.calendar_month,
        iconBg: const Color(0xFFF1EDFF),
        iconColor: Colors.deepPurple,
        screen: const PlayerDashboardScreen(),
      ),
      MenuItemModel(
        title: "Mes performances",
        icon: Icons.emoji_events,
        iconBg: const Color(0xFFFFEBEE),
        iconColor: Colors.red,
        screen: const PlayerDashboardScreen(),
      ),
      MenuItemModel(
        title: "Paramètres de compte",
        icon: Icons.settings,
        iconBg: const Color(0xFFF3F4F6),
        iconColor: Colors.grey,
        screen: const PlayerDashboardScreen(),
      ),
      MenuItemModel(
        title: "Debug Info",
        icon: Icons.bug_report,
        iconBg: const Color(0xFFFFEBEE),
        iconColor: Colors.pink,
        screen: const PlayerDashboardScreen(),
      ),
      MenuItemModel(
        title: "Déconnexion",
        icon: Icons.logout,
        iconBg: const Color(0xFFFFEBEE),
        iconColor: Colors.red,
        screen: const PlayerDashboardScreen(),
      ),
    ];

    return MainLayout(
      currentIndex: 3,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          final item = menuItems[index];
          return _menuItem(context, item);
        },
      ),
    );
  }

  Widget _menuItem(BuildContext context, MenuItemModel item) {
    return InkWell(
      onTap: () async {
        if (item.title == "Déconnexion") {
          await context.read<AuthViewModel>().logout();
          Navigator.pushNamedAndRemoveUntil(context, '/role', (_) => false);
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
