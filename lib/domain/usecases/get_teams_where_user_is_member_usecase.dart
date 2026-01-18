import 'package:sportify_frontend/data/models/team_model.dart';
import 'package:sportify_frontend/domain/repositories/team_repository.dart';

class GetTeamsWhereUserIsMemberUseCase {
  final TeamRepository repository;

  GetTeamsWhereUserIsMemberUseCase(this.repository);

  Future<List<TeamModel>> call({required String userId}) async {
    return repository.getTeamsWhereUserIsMember(userId: userId);
  }
}
