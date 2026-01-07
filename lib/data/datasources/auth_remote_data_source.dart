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

    // Sauvegarde des tokens si fournis
    if (res.containsKey('accessToken') && res.containsKey('refreshToken')) {
      await TokenStorage.saveTokens(res['accessToken'], res['refreshToken']);
    }

    return User.fromJson(res['user']);
  }

  // ---------------- Login ----------------
  Future<User> login(String email, String password) async {
    print('➡️ Login request: $email');

    final res = await client.post(
      '/auth/login',
      {'email': email, 'password': password},
    );

    print('⬅️ Réponse backend: $res');

    // Sauvegarder les tokens (access + refresh)
    final accessToken = res['accessToken'] ?? res['token'];
    final refreshToken = res['refreshToken'];
    if (accessToken != null && refreshToken != null) {
      await TokenStorage.saveTokens(accessToken, refreshToken);
    }

    // Récupérer les infos utilisateur via auto-login
    return autoLogin(accessToken!);
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
    final token = await TokenStorage.getAccessToken();
    if (token == null) return null;

    try {
      return await autoLogin(token);
    } catch (e) {
      // Si token expiré, essayer refresh automatique
      final refreshed = await _refreshToken();
      if (refreshed) {
        final newToken = await TokenStorage.getAccessToken();
        if (newToken != null) return await autoLogin(newToken);
      }

      // Si tout échoue, clear
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

  // ---------------- PRIVATE ----------------
  // Refresh token automatique
  Future<bool> _refreshToken() async {
    final refreshToken = await TokenStorage.getRefreshToken();
    if (refreshToken == null) return false;

    try {
      final res = await client.post(
        '/auth/refresh-token',
        {'refreshToken': refreshToken},
      );

      if (res.containsKey('accessToken') && res.containsKey('refreshToken')) {
        await TokenStorage.saveTokens(res['accessToken'], res['refreshToken']);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
