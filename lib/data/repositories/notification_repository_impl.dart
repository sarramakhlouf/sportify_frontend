import 'package:sportify_frontend/data/datasources/notification_remote_data_source.dart';
import 'package:sportify_frontend/domain/entities/notificationEntity.dart';
import 'package:sportify_frontend/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remote;

  NotificationRepositoryImpl(this.remote);

  @override
  Future<List<NotificationEntity>> getNotifications(String userId) async {
    final data = await remote.getNotifications(userId);
    return data
      .map((e) => NotificationEntity(
              id: e.id,
              title: e.title,
              message: e.message,
              isRead: e.isRead,
            ))
        .toList();
  }

  @override
  Future<int> getUnreadCount(String userId) async {
    final notifications = await remote.getNotifications(userId);
    return notifications.where((n) => !n.isRead).length;
  }
}
