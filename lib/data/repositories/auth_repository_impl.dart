import 'dart:io';

import 'package:sportify_frontend/data/datasources/auth_remote_data_source.dart';
import 'package:sportify_frontend/domain/entities/user.dart';
import 'package:sportify_frontend/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource ds;
  AuthRepositoryImpl(this.ds);

  @override
  Future<User> register(Map<String, dynamic> body, File? profileImage) {
    return ds.register(body, profileImage);
  }

  @override
  Future<User> login(String email, String password) {
    // Retourne directement l'utilisateur après login
    return ds.login(email, password);
  }

  @override
  Future<User?> autoLogin() async {
    // Essaie de récupérer l'utilisateur depuis le token sauvegardé
    return ds.tryAutoLogin();
  }

  @override
  Future<void> logout() async {
    await ds.logout();
  }

  @override
  Future<void> requestOtp(String email) => ds.requestOtp(email);

  @override
  Future<void> verifyOtp(String email, String otp) => ds.verifyOtp(email, otp);

  @override
  Future<void> resetPassword(String email, String password) =>
      ds.resetPassword(email, password);
}
