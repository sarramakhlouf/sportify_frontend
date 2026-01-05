import '../repositories/auth_repository.dart';
import '../entities/user.dart';

class LoginUseCase {
  final AuthRepository repo;
  LoginUseCase(this.repo);

  // Retourne directement l'utilisateur connecté
  Future<User> call(String email, String password) {
    return repo.login(email, password);
  }
}
