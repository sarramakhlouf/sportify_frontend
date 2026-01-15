import 'package:sportify_frontend/domain/repositories/invitation_repository.dart';

class RefuseInvitationUseCase {
  final InvitationRepository repository;

  RefuseInvitationUseCase(this.repository);

  Future<void> execute(String invitationId, String userId) async {
    await repository.refuseInvitation(invitationId, userId);
  }
}
