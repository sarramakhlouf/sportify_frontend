import 'package:sportify_frontend/domain/entities/invitationNotif.dart';
import 'package:sportify_frontend/domain/repositories/notification_repository.dart';

class GetInvitationNotificationsUseCase {
  final NotificationRepository repository;

  GetInvitationNotificationsUseCase(this.repository);

  Future<List<InvitationNotif>> call() {
    return repository.getInvitationNotifications();
  }
}
