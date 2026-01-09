import 'package:sportify_frontend/domain/entities/Invitation.dart';

abstract class InvitationRepository {
  Future<void> invitePlayer({
    required String teamId,
    required String senderId,
    required String playerCode,
  });

  Future<List<Invitation>> getPendingInvitations(String userId);
}
