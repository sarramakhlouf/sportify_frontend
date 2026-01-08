import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportify_frontend/core/network/api_client.dart';
import 'package:sportify_frontend/data/datasources/auth_remote_data_source.dart';
import 'package:sportify_frontend/data/datasources/invitation_remote_data_source.dart';
import 'package:sportify_frontend/data/datasources/team_remote_data_source.dart';
import 'package:sportify_frontend/data/repositories/auth_repository_impl.dart';
import 'package:sportify_frontend/data/repositories/invitation_repository_impl.dart';
import 'package:sportify_frontend/data/repositories/team_repository_impl.dart';
import 'package:sportify_frontend/domain/usecases/auto_login_usecase.dart';
import 'package:sportify_frontend/domain/usecases/invite_player_usecase.dart';
import 'package:sportify_frontend/domain/usecases/team_usecase.dart';
import 'package:sportify_frontend/domain/usecases/login_usecase.dart';
import 'package:sportify_frontend/domain/usecases/logout_usecase.dart';
import 'package:sportify_frontend/domain/usecases/register_usecase.dart';
import 'package:sportify_frontend/domain/usecases/request_otp_usecase.dart';
import 'package:sportify_frontend/domain/usecases/reset_password_usecase.dart';
import 'package:sportify_frontend/domain/usecases/verify_otp_usecase.dart';
import 'package:sportify_frontend/presentation/pages/create_team_screen.dart';
import 'package:sportify_frontend/presentation/pages/forget_password_screen.dart';
import 'package:sportify_frontend/presentation/pages/login_screen.dart';
import 'package:sportify_frontend/presentation/pages/my_teams_screen.dart';
import 'package:sportify_frontend/presentation/pages/otp_screen.dart';
import 'package:sportify_frontend/presentation/pages/player_dashboard_screen.dart';
import 'package:sportify_frontend/presentation/pages/register_screen.dart';
import 'package:sportify_frontend/presentation/pages/reset_password_screen.dart';
import 'package:sportify_frontend/presentation/pages/role_screen.dart';
import 'package:sportify_frontend/presentation/pages/splash_screen.dart';
import 'package:sportify_frontend/presentation/viewmodels/auth_viewmodel.dart';
import 'package:sportify_frontend/presentation/viewmodels/invitation_viewmodel.dart';
import 'package:sportify_frontend/presentation/viewmodels/team_viewmodel.dart';



class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
void main() {
  final apiClient = ApiClient();

  final authRemoteDS = AuthRemoteDataSource(apiClient);
  final authRepository = AuthRepositoryImpl(authRemoteDS);

  final teamRemoteDS = TeamRemoteDataSource(apiClient);
  final teamRepository = TeamRepositoryImpl(teamRemoteDS);

   final invitationRemoteDS = InvitationRemoteDataSource(apiClient);
  final invitationRepository = InvitationRepositoryImpl(invitationRemoteDS);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(
            registerUserUseCase: RegisterUseCase(authRepository),
            loginUseCase: LoginUseCase(authRepository),
            logoutUseCase: LogoutUseCase(authRepository),
            autoLoginUseCase: AutoLoginUseCase(authRepository),
            requestOtpUseCase: RequestOtpUseCase(authRepository),
            verifyOtpUseCase: VerifyOtpUseCase(authRepository),
            resetPasswordUseCase: ResetPasswordUseCase(authRepository),
          ),
        ),

        ChangeNotifierProvider(
          create: (_) => TeamViewModel(
            teamUseCase: TeamUseCase(teamRepository),
          ),
        ),
        
        ChangeNotifierProvider(
          create: (_) => InvitationViewModel(
            InvitePlayerUseCase(invitationRepository),
          ),
        ),

      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sportify',
      theme: ThemeData(primarySwatch: Colors.green, fontFamily: 'Roboto'),
      home: const SplashScreen(),
      routes: {
        '/role': (_) => const RoleScreen(),
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/forgot_password': (_) => const ForgotPasswordScreen(),
        '/otp': (_) => const OTPScreen(),
        '/reset_password': (_) => const ResetPasswordScreen(),
        '/create_team': (_) => const CreateTeamScreen(),
        '/my_teams': (_) => const MyTeamsScreen(),
        '/player_dashboard': (_) => const PlayerDashboardScreen(),
      },
    );
  }
}
