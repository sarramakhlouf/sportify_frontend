import 'package:sportify_frontend/domain/repositories/invitation_repository.dart';

class AcceptInvitationUseCase {
  final InvitationRepository repository;

  AcceptInvitationUseCase(this.repository);

  Future<void> execute(String invitationId, String userId) async {
    await repository.acceptInvitation(invitationId, userId);
  }
}
