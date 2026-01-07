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
        team: Team(name: name, city: city, color: color, ownerId: ownerId, isActivated: false),
        image: image,
        token: token,
      );

      teams.add(createdTeam);
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
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      teams = await teamUseCase.getTeamsByOwner(ownerId);

      final TeamModel? active = teams.firstWhereOrNull((t) => t.isActivated);
      selectedTeamId = active?.id;

      if (active != null && active.id != null) {
        await fetchTeamPlayers(active.id!);
      }
    } catch (e) {
      error = e.toString();
      teams = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Sélectionne une équipe et met à jour `isActivated` côté frontend et backend
  Future<void> selectTeam({
    required String teamId,
    required String ownerId,
    required String token,
  }) async {
    print("ACTIVATING TEAM $teamId");

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      // Appel API pour activer l'équipe côté backend
      final updatedTeam = await teamUseCase.activateTeam(
        teamId: teamId,
        ownerId: ownerId,
        token: token,
      );

      print("UPDATED TEAM FROM API: ${updatedTeam.toJson()}");

      // Mise à jour locale : toutes désactivées sauf celle activée
      teams = teams.map((t) {
        if (t.id == teamId) return updatedTeam;
        return t.copyWith(isActivated: false);
      }).toList();

      selectedTeamId = teamId;

      await fetchTeamPlayers(teamId);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Récupère une équipe par son ID
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

  /// Désactive une équipe
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
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchTeamPlayers(String teamId) async {
    isLoading = true;
    notifyListeners();

    try {
      final players = await teamUseCase.getTeamPlayers(teamId);
      
      final team = teams.firstWhereOrNull((t) => t.id == teamId);

      if (team != null) {
        selectedTeam = team.copyWith(players: players);
        print("Joueurs chargés pour l'équipe ${team.name}: ${players.map((p) => p.name).toList()}");
      } else {
        print("⚠️ Aucune équipe trouvée avec l'id $teamId");
        selectedTeam = null;
      }
    } catch (e, stackTrace) {
      error = "Erreur lors du chargement des joueurs: $e";
      print(error);
      print(stackTrace);
      selectedTeam = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

}
