import 'package:sportify_frontend/data/models/notification_model.dart';
import 'package:sportify_frontend/domain/entities/invitationNotif.dart';

abstract class NotificationRepository {
  Future<List<NotificationModel>> getNotifications(String userId);
  Future<int> getUnreadCount(String userId);
  Stream<NotificationModel> listenNotifications();
  Future<List<InvitationNotif>> getInvitationNotifications();
}
