import 'package:sportify_frontend/data/datasources/invitation_remote_data_source.dart';
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
}
