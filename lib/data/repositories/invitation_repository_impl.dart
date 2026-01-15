import 'package:sportify_frontend/data/datasources/invitation_remote_data_source.dart';
import 'package:sportify_frontend/domain/entities/invitation.dart';
import 'package:sportify_frontend/domain/repositories/invitation_repository.dart';

class InvitationRepositoryImpl implements InvitationRepository {
  final InvitationRemoteDataSource remote;

  InvitationRepositoryImpl(this.remote);

  @override
  Future<void> invitePlayer({
    required String teamId,
    required String senderId,
    required String playerCode,
  }) {
    return remote.invitePlayer(
      teamId: teamId,
      senderId: senderId,
      playerCode: playerCode,
    );
  }

  @override
  Future<List<Invitation>> getPendingInvitations(String userId, {String? token}) async {
    final data = await remote.getPendingInvitations(userId,  token: token);

    return data
    .map(
      (e) => Invitation(
        id: e.id,
        teamId: e.teamId,
        senderId: e.senderId,
        receiverId: e.receiverId,
        teamName: e.teamName,
        status: e.status,
        createdAt: e.createdAt,
      ),
    )
    .toList();
  }

  @override
  Future<void> acceptInvitation(String invitationId, String userId) {
    return remote.acceptInvitation(
      invitationId: invitationId, 
      userId: userId, 
    );
  }

  @override
  Future<void> refuseInvitation(String invitationId, String userId) {
    return remote.refuseInvitation(
      invitationId: invitationId, 
      userId: userId,
    );
  }   
}
