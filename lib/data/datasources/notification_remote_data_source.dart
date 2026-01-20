import 'package:sportify_frontend/core/network/api_client.dart';
import 'package:sportify_frontend/data/models/invitationNotif_model.dart';
import 'package:sportify_frontend/data/models/notification_model.dart';

class NotificationRemoteDataSource{
  final ApiClient apiClient;

  NotificationRemoteDataSource(this.apiClient);

//--------------------------------------GET NOTIFICATIONS-------------------------------------------
  Future<List<NotificationModel>> getNotifications(String userId) async {
    final response =
        await apiClient.getList('/notifications/$userId');

    return response
        .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

//--------------------------------------GET INVITATION NOTIFICATIONS-------------------------------------------
   Future<List<InvitationNotifModel>> getInvitationNotifications() async {
    final response =
        await apiClient.getList('/notifications/invitations');

    return response
        .map((e) => InvitationNotifModel.fromJson(e))
        .toList();
  }
}
