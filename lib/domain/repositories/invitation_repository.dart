import 'package:sportify_frontend/domain/entities/invitation.dart';

abstract class InvitationRepository {
  Future<void> invitePlayer({ required String teamId, required String senderId, required String playerCode,});
  Future<List<Invitation>> getPendingInvitations(String userId, {String? token});
  Future<void> acceptInvitation(String invitationId, String userId);
  Future<void> refuseInvitation(String invitationId, String userId);
}
