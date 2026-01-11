import 'dart:io';
import 'package:sportify_frontend/domain/entities/user.dart';
import 'package:sportify_frontend/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<User> execute({
    required String firstname,
    required String lastname,
    required String email,
    required String password,
    required Role role,
    required String phone,
    File? profileImage,
  }) {
    final body = {
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'phone': phone,
      'password': password,
      'role': role.name,
    };
    return repository.register(body, profileImage);
  }
}
