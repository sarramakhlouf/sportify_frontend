import 'package:sportify_frontend/core/network/api_client.dart';

class InvitationRemoteDataSource {
  final ApiClient apiClient;

  InvitationRemoteDataSource(this.apiClient);

  Future<void> invitePlayer({
    required String teamId,
    required String senderId,
    required String playerCode,
  }) async {
    final endpoint =
        '/invitations/invite'
        '?teamId=$teamId'
        '&senderId=$senderId'
        '&playerCode=$playerCode';

    // Backend retourne Invitation mais on n’en a pas besoin ici
    await apiClient.post(endpoint, {});
  }
}
