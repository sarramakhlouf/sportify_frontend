import 'dart:io';
import 'package:flutter/material.dart';
import '../../domain/entities/team.dart';
import '../../domain/usecases/create_team_usecase.dart';

class TeamViewModel extends ChangeNotifier {
  final CreateTeamUseCase createTeamUseCase;

  bool isLoading = false;
  String? error;

  TeamViewModel({required this.createTeamUseCase});

  Future<void> createTeam({
    required String name,
    String? city,
    required String color,
    required String ownerId,
    required String token,
    File? image,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      await createTeamUseCase(
        Team(name: name, city: city, color: color, ownerId: ownerId),
        image: image,
        token: token,
      );
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
