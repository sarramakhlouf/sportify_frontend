import 'package:sportify_frontend/core/network/api_client.dart';
import 'package:sportify_frontend/data/models/invitation_model.dart';

class InvitationRemoteDataSource {
  final ApiClient apiClient;

  InvitationRemoteDataSource(this.apiClient);

  Future<void> invitePlayer({
    required String teamId,
    required String senderId,
    required String playerCode,
  }) async {
    final endpoint = '/invitations/invite';

    await apiClient.post(endpoint, {
      'teamId': teamId,
      'senderId': senderId,
      'playerCode': playerCode,
    });
  }

  Future<List<InvitationModel>> getPendingInvitations(String userId, {String? token}) async {
    final response = await apiClient.getList('/invitations/pending/$userId', token: token);

    return response.map((e) => InvitationModel.fromJson(e)).toList();
  }

  Future<void> acceptInvitation({
    required String invitationId,
    required String userId,
  }) async {
    final endpoint = '/invitations/$invitationId/accept?userId=$userId';
    await apiClient.post(endpoint, {});
  }

  Future<void> refuseInvitation({
    required String invitationId,
    required String userId,
  }) async {
    final endpoint = '/invitations/$invitationId/reject?userId=$userId';
    await apiClient.post(endpoint, {});
  }
}
