import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sportify_frontend/data/models/player_model.dart';
import 'package:sportify_frontend/data/models/team_model.dart';
import 'package:sportify_frontend/domain/entities/team.dart';
import 'package:sportify_frontend/domain/usecases/team_usecase.dart';
import 'package:collection/collection.dart';

class TeamViewModel extends ChangeNotifier {
  final TeamUseCase teamUseCase;

  TeamViewModel({required this.teamUseCase});

  bool isLoading = false;
  String? error;

  List<TeamModel> teams = [];
  List<PlayerModel> players = [];

  String? selectedTeamId;
  TeamModel? selectedTeam;

  /// Crée une équipe et l'ajoute à la liste
  Future<void> createTeam({
    required String name,
    String? city,
    required String color,
    required String ownerId,
    required String token,
    File? image,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final TeamModel createdTeam = await teamUseCase.createTeam(
        team: Team(
          name: name,
          city: city,
          color: color,
          ownerId: ownerId,
          isActivated: false,
        ),
        image: image,
        token: token,
      );

      teams.add(createdTeam);
      print("TEAM CREATED: ${createdTeam.name} (ID: ${createdTeam.id})");
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Récupère toutes les équipes d'un propriétaire
  Future<void> fetchTeams({
    required String ownerId,
    required String token,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      teams = await teamUseCase.getTeamsByOwner(ownerId);

      final TeamModel? active = teams.firstWhereOrNull((t) => t.isActivated);

      selectedTeam = active;
      selectedTeamId = active?.id;

      if (active != null && active.id != null) {
        print("ACTIVE TEAM FOUND: ${active.name} (ID: ${active.id})");
        await fetchTeamPlayers(active.id!, token);
      } else {
        print("NO ACTIVE TEAM FOUND for owner $ownerId");
        players = [];
      }
    } catch (e) {
      error = e.toString();
      teams = [];
      players = [];
      print("ERROR FETCH TEAMS: $error");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> activateTeam({
    required String teamId,
    required String ownerId,
    required String token,
  }) async {
    print("ACTIVATING TEAM $teamId");

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final updatedTeam = await teamUseCase.activateTeam(
        teamId: teamId,
        ownerId: ownerId,
        token: token,
      );

      print("TEAM ACTIVATED: ${updatedTeam.name} (ID: ${updatedTeam.id})");

      teams = teams.map((t) {
        if (t.id == teamId) return updatedTeam;
        return t.copyWith(isActivated: false);
      }).toList();

      selectedTeamId = teamId;
      selectedTeam = updatedTeam;

      await fetchTeamPlayers(teamId, token);
    } catch (e) {
      error = e.toString();
      print("ERROR ACTIVATE TEAM: $error");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<TeamModel?> fetchTeamById({
    required String teamId,
    required String token,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final team = await teamUseCase.getTeamById(teamId, token);
      return team;
    } catch (e) {
      error = e.toString();
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deactivateTeam({
    required String teamId,
    required String token,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final updatedTeam = await teamUseCase.deactivateTeam(
        teamId: teamId,
        token: token,
      );

      teams = teams.map((t) {
        if (t.id == teamId) return updatedTeam;
        return t;
      }).toList();

      selectedTeamId = null;
      selectedTeam = null;
      players = [];
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchTeamPlayers(String teamId, String token) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final team = teams.firstWhere((t) => t.id == teamId);
      print("FETCHING PLAYERS FOR TEAM: ${team.name} (ID: ${team.id})");

      final ownerUser = await teamUseCase.getUserById(team.ownerId, token);
      print("OWNER: ${ownerUser.firstname} ${ownerUser.lastname}");

      final ownerPlayer = PlayerModel(
        id: ownerUser.id,
        name: '${ownerUser.firstname} ${ownerUser.lastname}',
        avatarUrl: ownerUser.profileImageUrl,
      );

      final members = await teamUseCase.getTeamPlayers(teamId);
      print("MEMBERS COUNT: ${members.length}");

      players = [ownerPlayer, ...members.where((m) => m.id != ownerUser.id)];
    } catch (e) {
      error = e.toString();
      players = [];
      print("ERROR FETCH PLAYERS: $error");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
