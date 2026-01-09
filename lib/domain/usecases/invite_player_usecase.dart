import 'package:sportify_frontend/domain/repositories/invitation_repository.dart';

class InvitePlayerUsecase {
  final InvitationRepository repository;

  InvitePlayerUsecase(this.repository);

  Future<void> call({
    required String teamId,
    required String senderId,
    required String playerCode,
  }) {
    return repository.invitePlayer(
      teamId: teamId,
      senderId: senderId,
      playerCode: playerCode,
    );
  }
}
