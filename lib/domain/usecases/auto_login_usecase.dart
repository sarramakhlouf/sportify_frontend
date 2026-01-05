import 'package:sportify_frontend/domain/entities/user.dart';
import 'package:sportify_frontend/domain/repositories/auth_repository.dart';

class AutoLoginUseCase {
  final AuthRepository repo;
  AutoLoginUseCase(this.repo);

  Future<User?> call() {
    return repo.autoLogin();
  }
}
