import 'package:sportify_frontend/domain/repositories/auth_repository.dart';

class ResetPasswordUseCase {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  Future<void> execute(String email, String newPassword) {
    return repository.resetPassword(email, newPassword);
  }
}
