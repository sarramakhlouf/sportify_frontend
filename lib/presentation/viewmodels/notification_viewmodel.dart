import 'package:flutter/material.dart';
import 'package:sportify_frontend/domain/usecases/get_unread_notif_count_usecase.dart';

class NotificationViewModel extends ChangeNotifier {
  final GetUnreadNotifCountUsecase getUnreadNotifCountUsecase;

  int unreadCount = 0;

  NotificationViewModel(this.getUnreadNotifCountUsecase);

  Future<void> load(String userId) async {
    unreadCount = await getUnreadNotifCountUsecase(userId);
    notifyListeners();
  }
}
