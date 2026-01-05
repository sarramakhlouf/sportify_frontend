import 'package:sportify_frontend/domain/repositories/auth_repository.dart';

class RequestOtpUseCase {
  final AuthRepository repository;

  RequestOtpUseCase(this.repository);

  Future<void> execute(String email) {
    return repository.requestOtp(email);
  }
}
