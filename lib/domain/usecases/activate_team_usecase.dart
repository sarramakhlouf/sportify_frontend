import 'package:sportify_frontend/domain/repositories/team_repository.dart';
import 'package:sportify_frontend/data/models/team_model.dart';

class ActivateTeamUseCase {
  final TeamRepository repository;

  ActivateTeamUseCase(this.repository);

  Future<TeamModel> call({
    required String teamId,
    required String ownerId,
    required String token,
  }) {
    return repository.activateTeam(teamId, ownerId, token);
  }
}
