import 'package:sportify_frontend/domain/repositories/notification_repository.dart';

class GetUnreadNotifCountUsecase {
  final NotificationRepository repository;
  GetUnreadNotifCountUsecase(this.repository);

  Future<int> call(String userId) {
    return repository.getUnreadCount(userId);
  }
}
