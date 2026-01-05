import 'dart:io';
import 'package:sportify_frontend/core/network/api_client.dart';
import 'package:sportify_frontend/core/storage/token_storage.dart';
import 'package:sportify_frontend/domain/entities/user.dart';

class AuthRemoteDataSource {
  final ApiClient client;
  AuthRemoteDataSource(this.client);

  // ---------------- Register ----------------
  Future<User> register(Map<String, dynamic> body, File? profileImage) async {
    print('➡️ Envoi inscription: $body');

    final res = await client.postMultipart(
      '/auth/register',
      body,
      fileKey: 'image',
      file: profileImage,
      jsonKey: 'data',
    );

    print('⬅️ Réponse backend: $res');
    return User.fromJson(res['user']);
  }

  // ---------------- Login ----------------
  Future<User> login(String email, String password) async {
    print('➡️ Login request: $email');
    final res = await client.post(
      '/auth/login',
      {'email': email, 'password': password},
    );

    final token = res['token'];
    print('⬅️ Token reçu: $token');

    // Sauvegarder le token pour l'auto-login
    await TokenStorage.saveToken(token);

    // Récupérer les infos utilisateur
    return autoLogin(token);
  }

  // ---------------- Auto-login ----------------
  Future<User> autoLogin(String token) async {
    final res = await client.get(
      '/auth/auto-login',
      token: token,
    );
    return User.fromJson(res);
  }

  Future<User?> tryAutoLogin() async {
    final token = await TokenStorage.getToken();
    if (token == null) return null;

    try {
      return await autoLogin(token);
    } catch (e) {
      await TokenStorage.clear();
      return null;
    }
  }

  // ---------------- Logout ----------------
  Future<void> logout() async {
    await TokenStorage.clear();
  }

  // ---------------- OTP / Reset ----------------
  Future<void> requestOtp(String email) async {
    final uri = '/auth/forgot-password/request-otp?email=$email';
    await client.post(uri, {});
  }

  Future<void> verifyOtp(String email, String otp) async {
    final uri = '/auth/forgot-password/verify-otp?email=$email&otp=$otp';
    await client.post(uri, {});
  }

  Future<void> resetPassword(String email, String newPassword) async {
    final uri = '/auth/forgot-password/reset?email=$email&newPassword=$newPassword';
    await client.post(uri, {});
  }
}
