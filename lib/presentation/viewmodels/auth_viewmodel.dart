import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sportify_frontend/core/storage/token_storage.dart';
import 'package:sportify_frontend/domain/entities/user.dart';
import 'package:sportify_frontend/domain/usecases/auto_login_usecase.dart';
import 'package:sportify_frontend/domain/usecases/login_usecase.dart';
import 'package:sportify_frontend/domain/usecases/logout_usecase.dart';
import 'package:sportify_frontend/domain/usecases/register_usecase.dart';
import 'package:sportify_frontend/domain/usecases/request_otp_usecase.dart';
import 'package:sportify_frontend/domain/usecases/reset_password_usecase.dart';
import 'package:sportify_frontend/domain/usecases/verify_otp_usecase.dart';

class AuthViewModel extends ChangeNotifier {
  final RegisterUseCase registerUserUseCase;
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final AutoLoginUseCase autoLoginUseCase;
  final RequestOtpUseCase requestOtpUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;

  AuthViewModel({
    required this.registerUserUseCase,
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.autoLoginUseCase,
    required this.requestOtpUseCase,
    required this.verifyOtpUseCase,
    required this.resetPasswordUseCase,
  });

  bool isLoading = false;
  User? currentUser;
  String? error;
  Role? selectedRole;

  void setSelectedRole(Role role) {
    selectedRole = role;
    notifyListeners();
  }

  void clearSelectedRole() {
    selectedRole = null;
  }

  Future<void> register({
    required String firstname,
    required String lastname,
    required String email,
    required String password,
    File? profileImage,
  }) async {
    final role = selectedRole;

    if (role == null) {
      error = "Rôle non sélectionné";
      notifyListeners();
      return;
    }

    try {
      isLoading = true;
      error = null;
      notifyListeners();

      currentUser = await registerUserUseCase.execute(
        firstname: firstname,
        lastname: lastname,
        email: email,
        password: password,
        role: role,
        profileImage: profileImage,
      );
    } catch (e) {
      final message = e.toString();

      if (message.contains('409') || message.contains('EMAIL_ALREADY_EXISTS')) {
        error = "Cet email est déjà utilisé";
      } else if (message.contains('400')) {
        error = "Données invalides";
      } else {
        error = "Erreur lors de l'inscription";
      }

      currentUser = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      currentUser = await loginUseCase.call(email, password);
    } catch (e) {
      error = e.toString();
      currentUser = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> tryAutoLogin() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      currentUser = await autoLoginUseCase.call();
    } catch (e) {
      error = e.toString();
      currentUser = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> getToken() async {
    return TokenStorage.getAccessToken();
  }

  Future<void> requestOtp(String email) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();
      await requestOtpUseCase.execute(email);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> verifyOtp(String email, String otp) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();
      await verifyOtpUseCase.execute(email, otp);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> resetPassword(String email, String newPassword) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();
      await resetPasswordUseCase.execute(email, newPassword);
      currentUser = null;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    currentUser = null;
    clearSelectedRole();
    await logoutUseCase.call();
    notifyListeners();
  }
  
  bool get isPlayer => currentUser?.role == Role.PLAYER;
  bool get isManager => currentUser?.role == Role.MANAGER;
}
