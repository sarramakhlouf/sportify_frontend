import 'package:sportify_frontend/data/models/team_model.dart';
import 'package:sportify_frontend/domain/repositories/team_repository.dart';

class GetMemberTeamsUseCase {
  final TeamRepository repository;

  GetMemberTeamsUseCase(this.repository);

  Future<List<TeamModel>> call({required String userId}) async {
    return repository.getMemberTeams(userId: userId);
  }
}
