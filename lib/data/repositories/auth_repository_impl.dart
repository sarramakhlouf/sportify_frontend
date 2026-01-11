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
    return ds.login(email, password);
  }

  @override
  Future<User?> autoLogin() async {
    return ds.tryAutoLogin();
  }

  @override
  Future<void> logout() async {
    await ds.logout();
  }

  @override
  Future<void> requestOtp(String email) {
    return ds.requestOtp(email);
  }

  @override
  Future<void> verifyOtp(String email, String otp) {
    return ds.verifyOtp(email, otp);
  }

  @override
  Future<void> resetPassword(String email, String password) {
    return ds.resetPassword(email, password);
  }

  @override
  Future<User> updateProfile( String userId, Map<String, dynamic> data, File? image) {
    return ds.updateProfile(userId, data, image);
  }
}
