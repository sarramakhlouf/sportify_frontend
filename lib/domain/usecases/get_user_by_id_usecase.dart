import 'package:sportify_frontend/domain/repositories/team_repository.dart';
import 'package:sportify_frontend/data/models/user_model.dart';

class GetUserByIdUseCase {
  final TeamRepository repository;

  GetUserByIdUseCase(this.repository);

  Future<UserModel> call(String userId, String token) {
    return repository.getUserById(userId, token);
  }
}
