import 'dart:io';

import 'package:sportify_frontend/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> register(Map<String, dynamic> body, File? profileImage);
  Future<User> login(String email, String password);
  Future<User?> autoLogin();
  Future<void> logout();
  Future<void> requestOtp(String email);
  Future<void> verifyOtp(String email, String otp);
  Future<void> resetPassword(String email, String password);
}
