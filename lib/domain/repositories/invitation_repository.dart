abstract class InvitationRepository {
  Future<void> invitePlayer({
    required String teamId,
    required String senderId,
    required String playerCode,
  });
}
