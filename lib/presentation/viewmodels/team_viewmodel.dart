import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sportify_frontend/data/models/player_model.dart';
import 'package:sportify_frontend/data/models/team_model.dart';
import 'package:sportify_frontend/domain/entities/team.dart';
import 'package:collection/collection.dart';
import 'package:sportify_frontend/domain/usecases/activate_team_usecase.dart';
import 'package:sportify_frontend/domain/usecases/create_team_usecase.dart';
import 'package:sportify_frontend/domain/usecases/deactivate_teamusecase.dart';
import 'package:sportify_frontend/domain/usecases/get_team_players_usecase.dart';
import 'package:sportify_frontend/domain/usecases/get_teams_by_id_usecase.dart';
import 'package:sportify_frontend/domain/usecases/get_teams_by_owner_usecase.dart';
import 'package:sportify_frontend/domain/usecases/get_user_by_id_usecase.dart';
import 'package:sportify_frontend/domain/usecases/update_team_usecase.dart';

class TeamViewModel extends ChangeNotifier {
  final CreateTeamUseCase createTeamUseCase;
  final GetTeamPlayersUseCase getTeamPlayersUseCase;
  final GetTeamsByOwnerUseCase getTeamsByOwnerUseCase;
  final GetTeamByIdUseCase getTeamByIdUseCase;
  final UpdateTeamUseCase updateTeamUseCase;
  final ActivateTeamUseCase activateTeamUseCase;
  final DeactivateTeamUseCase deactivateTeamUseCase;
  final GetUserByIdUseCase getUserByIdUseCase;

  TeamViewModel({
    required this.createTeamUseCase,
    required this.getTeamPlayersUseCase,
    required this.getTeamsByOwnerUseCase,
    required this.getTeamByIdUseCase,
    required this.updateTeamUseCase,
    required this.activateTeamUseCase,
    required this.deactivateTeamUseCase,
    required this.getUserByIdUseCase, 
  });

  bool isLoading = false;
  String? error;

  List<TeamModel> teams = [];
  List<PlayerModel> players = [];
  Map<String, int> teamPlayersCount = {};

  String? selectedTeamId;
  TeamModel? selectedTeam;

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
      final TeamModel createdTeam = await createTeamUseCase(
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

  Future<void> fetchTeams({
    required String ownerId,
    required String token,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      teams = await getTeamsByOwnerUseCase(ownerId);

      final TeamModel? active = teams.firstWhereOrNull((t) => t.isActivated);

      selectedTeam = active;
      selectedTeamId = active?.id;

      teamPlayersCount = {};
      for (var team in teams) {
        if (team.id != null) {
          try {
            final ownerUser = await getUserByIdUseCase(
              team.ownerId,
              token,
            );
            /*final ownerPlayer = PlayerModel(
              id: ownerUser.id,
              name: '${ownerUser.firstname} ${ownerUser.lastname}',
              avatarUrl: ownerUser.profileImageUrl,
            );*/

            final members = await getTeamPlayersUseCase(team.id!);
            teamPlayersCount[team.id!] =
                1 + members.where((m) => m.id != ownerUser.id).length;
          } catch (e) {
            teamPlayersCount[team.id!] = 0;
          }
        }
      }

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
      final updatedTeam = await activateTeamUseCase(
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
      final team = await getTeamByIdUseCase(teamId, token);
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
      final updatedTeam = await deactivateTeamUseCase(
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

      final ownerUser = await getUserByIdUseCase(team.ownerId, token);
      print("OWNER: ${ownerUser.firstname} ${ownerUser.lastname}");

      final ownerPlayer = PlayerModel(
        id: ownerUser.id,
        name: '${ownerUser.firstname} ${ownerUser.lastname}',
        avatarUrl: ownerUser.profileImageUrl,
      );

      final members = await getTeamPlayersUseCase(teamId);
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

  Future<void> fetchPlayersCountForTeam(String teamId) async {
    try {
      final members = await getTeamPlayersUseCase(teamId);

      teamPlayersCount[teamId] = members.length + 1;
      print("NOMBRE DES JOUEURS: ${members.length + 1}");

      notifyListeners();
    } catch (e) {
      teamPlayersCount[teamId] = 0;
    }
  }
}
