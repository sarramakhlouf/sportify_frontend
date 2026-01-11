import 'dart:io';

import 'package:sportify_frontend/domain/entities/user.dart';
import 'package:sportify_frontend/domain/repositories/auth_repository.dart';

class UpdateProfileUseCase {
  final AuthRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<User> execute(
      String userId, Map<String, dynamic> data, File? image) {
    return repository.updateProfile(userId, data, image);
  }
}
