import 'dart:io';
import 'package:sportify_frontend/core/network/api_client.dart';
import 'package:sportify_frontend/core/storage/token_storage.dart';
import 'package:sportify_frontend/data/models/user_model.dart';
import 'package:sportify_frontend/domain/entities/user.dart';

class AuthRemoteDataSource {
  final ApiClient client;
  AuthRemoteDataSource(this.client);

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

    if (res.containsKey('accessToken') && res.containsKey('refreshToken')) {
      await TokenStorage.saveTokens(res['accessToken'], res['refreshToken']);
    }

    return UserModel.fromJson(res['user']);
  }

  Future<User> login(String email, String password) async {
    print('➡️ Login request: $email');

    final res = await client.post('/auth/login', {
      'email': email,
      'password': password,
    });

    print('⬅️ Réponse backend: $res');

    final accessToken = res['accessToken'] ?? res['token'];
    final refreshToken = res['refreshToken'];
    if (accessToken != null && refreshToken != null) {
      await TokenStorage.saveTokens(accessToken, refreshToken);
    }

    // Récupérer les infos utilisateur via auto-login
    return autoLogin(accessToken!);
  }

  Future<User> autoLogin(String token) async {
    final res = await client.get('/auth/auto-login', token: token);
    return UserModel.fromJson(res);
  }

  Future<User?> tryAutoLogin() async {
    final token = await TokenStorage.getAccessToken();
    if (token == null) return null;

    try {
      return await autoLogin(token);
    } catch (e) {
      final refreshed = await _refreshToken();
      if (refreshed) {
        final newToken = await TokenStorage.getAccessToken();
        if (newToken != null) return await autoLogin(newToken);
      }
      await TokenStorage.clear();
      return null;
    }
  }

  Future<void> logout() async {
    final accessToken = await TokenStorage.getAccessToken();

    try {
      if (accessToken != null) {
        await client.post('/auth/logout', {}, token: accessToken);
      }
    } catch (e) {
      print('⚠️ Erreur logout backend: $e');
    } finally {
      await TokenStorage.clear();
    }
  }

  Future<void> requestOtp(String email) async {
    final uri = '/auth/forgot-password/request-otp?email=$email';
    await client.post(uri, {});
  }

  Future<void> verifyOtp(String email, String otp) async {
    final uri = '/auth/forgot-password/verify-otp?email=$email&otp=$otp';
    await client.post(uri, {});
  }

  Future<void> resetPassword(String email, String newPassword) async {
    final uri =
        '/auth/forgot-password/reset?email=$email&newPassword=$newPassword';
    await client.post(uri, {});
  }

  Future<bool> _refreshToken() async {
    final refreshToken = await TokenStorage.getRefreshToken();
    if (refreshToken == null) return false;

    try {
      final res = await client.post('/auth/refresh-token', {
        'refreshToken': refreshToken,
      });

      if (res.containsKey('accessToken') && res.containsKey('refreshToken')) {
        await TokenStorage.saveTokens(res['accessToken'], res['refreshToken']);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<User> updateProfile(
    String userId,
    Map<String, dynamic> data,
    File? image,
  ) async {
    final Map<String, dynamic> body = {
      "firstname": data['firstname'],
      "lastname": data['lastname'],
      "email": data['email'],
      "phone": data['phone'],
    };

    // Ajouter le mot de passe uniquement si l'utilisateur veut le changer
    if (data.containsKey('password') &&
        data['password'] != null &&
        data['password'] != '') {
      if (data['currentPassword'] == null || data['currentPassword'].isEmpty) {
        throw Exception("Le mot de passe actuel est requis pour changer le mot de passe");
      }
      body['password'] = data['password'];          // nouveau mot de passe
      body['currentPassword'] = data['currentPassword']; // mot de passe actuel
    }

    print("updateProfile body envoyé: $body");

    final res = await client.postMultipart(
      '/auth/users/$userId/update-profile',
      body,
      file: image,
      jsonKey: 'data',
    );

    print("Réponse backend updateProfile: $res");

    return UserModel.fromJson(res);
  }

}
