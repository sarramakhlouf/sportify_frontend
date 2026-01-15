import 'package:sportify_frontend/data/models/notification_model.dart';
import 'package:sportify_frontend/domain/repositories/notification_repository.dart';

class GetNotificationsUsecase {
  final NotificationRepository repository;
  GetNotificationsUsecase(this.repository);

  Future<List<NotificationModel>> call(String userId) {
    return repository.getNotifications(userId);
  }
}
