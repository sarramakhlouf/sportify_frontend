import 'package:flutter/material.dart';
import 'package:sportify_frontend/core/network/stomp_websocket_service.dart';
import 'package:sportify_frontend/core/storage/token_storage.dart';
import 'package:sportify_frontend/data/models/notification_model.dart';
import 'package:sportify_frontend/domain/usecases/get_notifications_usecase.dart';
import 'package:sportify_frontend/domain/usecases/get_unread_notif_count_usecase.dart';

class NotificationViewModel extends ChangeNotifier {
  final GetNotificationsUsecase getNotifications;
  final GetUnreadNotifCountUsecase getUnreadCount;
  final StompWebSocketService _stompService = StompWebSocketService();

  NotificationViewModel(this.getNotifications, this.getUnreadCount);

  List<NotificationModel> notifications = [];
  int unreadCount = 0;

  Future<void> initWebSocket(String userId) async {
    final token = await TokenStorage.getAccessToken();
    if (token == null) {
      print("❌ Aucun token trouvé pour WebSocket");
      return;
    }

    _stompService.connect(
      userId: userId,
      token: token,
      onNotification: (data) {
        try {
          final notif = NotificationModel.fromJson(data);

          // ⚡ Post-frame pour éviter crash setState pendant build
          WidgetsBinding.instance.addPostFrameCallback((_) {
            notifications.insert(0, notif);
            unreadCount++;
            notifyListeners();
            print("🔔 Notification ajoutée: ${notif.title}");
          });
        } catch (e) {
          print("❌ Erreur parsing notification STOMP: $e");
        }
      },
    );
  }

  void load(String userId) async {
    notifications = await getNotifications(userId);
    unreadCount = notifications.where((n) => !n.isRead).length;
    notifyListeners();
  }

  void addNotification(NotificationModel notif) {
    notifications.insert(0, notif);
    unreadCount++;
    notifyListeners();
  }

  void markAsRead(NotificationModel notif) async {
    notif.isRead = true;
    notifyListeners();
  }

  @override
  void dispose() {
    _stompService.disconnect(); 
    super.dispose();
  }

}
