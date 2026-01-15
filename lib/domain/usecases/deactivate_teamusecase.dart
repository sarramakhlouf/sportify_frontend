import 'package:sportify_frontend/domain/repositories/team_repository.dart';
import 'package:sportify_frontend/data/models/team_model.dart';

class DeactivateTeamUseCase {
  final TeamRepository repository;

  DeactivateTeamUseCase(this.repository);

  Future<TeamModel> call({
    required String teamId,
    required String token,
  }) {
    return repository.deactivateTeam(teamId, token);
  }
}
