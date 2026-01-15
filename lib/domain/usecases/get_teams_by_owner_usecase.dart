import 'package:sportify_frontend/domain/repositories/team_repository.dart';
import 'package:sportify_frontend/data/models/team_model.dart';

class GetTeamsByOwnerUseCase {
  final TeamRepository repository;

  GetTeamsByOwnerUseCase(this.repository);

  Future<List<TeamModel>> call(String ownerId) {
    return repository.getTeamsByOwner(ownerId);
  }
}
