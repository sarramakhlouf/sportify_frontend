import 'package:sportify_frontend/domain/entities/notificationEntity.dart';
import 'package:sportify_frontend/domain/repositories/notification_repository.dart';

class GetNotificationsUsecase {
  final NotificationRepository repository;
  GetNotificationsUsecase(this.repository);

  Future<List<NotificationEntity>> call(String userId) {
    return repository.getNotifications(userId);
  }
}
