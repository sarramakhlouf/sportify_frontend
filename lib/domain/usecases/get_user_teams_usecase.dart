import 'package:sportify_frontend/data/models/team_model.dart';
import 'package:sportify_frontend/domain/repositories/team_repository.dart';

class GetUserTeamsUseCase {
  final TeamRepository repository;

  GetUserTeamsUseCase(this.repository);

  Future<List<TeamModel>> call({
    required String userId,
    required String token,
  }) {
    return repository.getUserTeams(
      userId: userId,
      token: token,
    );
  }
}
