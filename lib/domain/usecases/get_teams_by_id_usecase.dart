import 'package:sportify_frontend/domain/repositories/team_repository.dart';
import 'package:sportify_frontend/data/models/team_model.dart';

class GetTeamByIdUseCase {
  final TeamRepository repository;

  GetTeamByIdUseCase(this.repository);

  Future<TeamModel> call(String teamId, String token) {
    return repository.getTeamById(teamId, token);
  }
}
