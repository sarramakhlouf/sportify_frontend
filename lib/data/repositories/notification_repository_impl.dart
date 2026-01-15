import 'dart:async';

import 'package:sportify_frontend/data/datasources/notification_remote_data_source.dart';
import 'package:sportify_frontend/data/models/notification_model.dart';
import 'package:sportify_frontend/domain/entities/invitationNotif.dart';
import 'package:sportify_frontend/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remote;
  final _controller = StreamController<NotificationModel>.broadcast();

  NotificationRepositoryImpl(this.remote);

  @override
  Future<List<NotificationModel>> getNotifications(String userId) {
    return remote.getNotifications(userId);
  }

  @override
  Stream<NotificationModel> listenNotifications() {
    return _controller.stream;
  }

  void push(NotificationModel notification) {
    _controller.add(notification);
  }

  @override
  Future<int> getUnreadCount(String userId) async {
    final notifications = await getNotifications(userId);
    return notifications.where((n) => !n.isRead).length;
  }

  @override
  Future<List<InvitationNotif>> getInvitationNotifications() async {
    final data = await remote.getInvitationNotifications();

    return data.map((e) {
      return InvitationNotif(
        notificationId: e.notificationId,
        invitationId: e.invitationId,
        teamId: e.teamId,
        teamName: e.teamName,
        teamCity: e.teamCity,
        teamLogo: e.teamLogo,
        title: e.title,
        message: e.message,
        isRead: e.isRead,
        createdAt: e.createdAt,
      );
    }).toList();
  }
}
