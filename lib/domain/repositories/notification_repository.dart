import 'package:sportify_frontend/domain/entities/notificationEntity.dart';

abstract class NotificationRepository {
  Future<List<NotificationEntity>> getNotifications(String userId);
  Future<int> getUnreadCount(String userId);
}
