import 'package:sportify_frontend/domain/repositories/team_repository.dart';
import 'package:sportify_frontend/data/models/player_model.dart';

class GetTeamPlayersUseCase {
  final TeamRepository repository;

  GetTeamPlayersUseCase(this.repository);

  Future<List<PlayerModel>> call(String teamId) {
    return repository.getTeamPlayers(teamId);
  }
}
