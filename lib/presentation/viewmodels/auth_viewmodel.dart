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

  // ---------------- Register ----------------
  Future<void> register(
    String firstname,
    String lastname,
    String email,
    String password,
    Role role,
    File? profileImage,
  ) async {
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
      error = e.toString();
      currentUser = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ---------------- Login ----------------
  Future<void> login(String email, String password) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      // Maintenant login renvoie directement l'utilisateur
      currentUser = await loginUseCase.call(email, password);
    } catch (e) {
      error = e.toString();
      currentUser = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ---------------- Auto-login ----------------
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
    return await TokenStorage.getToken();
  }
  // ---------------- Request OTP ----------------
  Future<void> requestOtp(String email) async {
    try {
      isLoading = true;
      notifyListeners();
      await requestOtpUseCase.execute(email);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ---------------- Verify OTP ----------------
  Future<void> verifyOtp(String email, String otp) async {
    try {
      isLoading = true;
      notifyListeners();
      await verifyOtpUseCase.execute(email, otp);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ---------------- Reset Password ----------------
  Future<void> resetPassword(String email, String newPassword) async {
    try {
      isLoading = true;
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

  // ---------------- Logout ----------------
  Future<void> logout() async {
    currentUser = null;
    await logoutUseCase
    .call();
    notifyListeners();
  }

  bool get isPlayer => currentUser?.role == Role.PLAYER;
  bool get isManager => currentUser?.role == Role.MANAGER;
}
