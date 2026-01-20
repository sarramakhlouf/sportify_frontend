import 'package:sportify_frontend/domain/repositories/team_repository.dart';

class DeleteTeamUseCase {
  final TeamRepository repository;

  DeleteTeamUseCase(this.repository);

  Future<void> call({
    required String teamId,
    required String token,
  }) {
    return repository.deleteTeam(
      teamId: teamId,
      token: token,
    );
  }
}