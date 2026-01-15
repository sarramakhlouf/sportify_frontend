import 'package:sportify_frontend/core/storage/token_storage.dart';
import 'package:sportify_frontend/domain/entities/invitation.dart';
import '../repositories/invitation_repository.dart';

class GetPendingInvitationsUseCase {
  final InvitationRepository repository;

  GetPendingInvitationsUseCase(this.repository);

  Future<List<Invitation>> call(String userId, {String? token}) async {
    final token = await TokenStorage.getAccessToken();
    return await repository.getPendingInvitations(userId, token: token);
  }
}
