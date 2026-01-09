import 'package:sportify_frontend/domain/entities/Invitation.dart';
import '../repositories/invitation_repository.dart';

class GetPendingInvitationsUseCase {
  final InvitationRepository repository;

  GetPendingInvitationsUseCase(this.repository);

  Future<List<Invitation>> call(String userId) async {
    return await repository.getPendingInvitations(userId);
  }
}
