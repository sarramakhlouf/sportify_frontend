import 'package:sportify_frontend/domain/repositories/auth_repository.dart';

class VerifyOtpUseCase {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  Future<void> execute(String email, String otp) {
    return repository.verifyOtp(email, otp);
  }
}
