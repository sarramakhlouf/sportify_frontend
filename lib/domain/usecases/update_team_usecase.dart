import 'package:sportify_frontend/domain/repositories/team_repository.dart';
import 'package:sportify_frontend/data/models/team_model.dart';

class UpdateTeamUseCase {
  final TeamRepository repository;

  UpdateTeamUseCase(this.repository);

  Future<TeamModel> call({
    required String teamId,
    required TeamModel team,
    required String token,
  }) {
    return repository.updateTeam(teamId, team, token);
  }
}
