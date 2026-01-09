import 'dart:io';
import 'package:sportify_frontend/data/models/player_model.dart';
import 'package:sportify_frontend/data/models/team_model.dart';
import 'package:sportify_frontend/data/models/user_model.dart';
import 'package:sportify_frontend/domain/entities/team.dart';
import 'package:sportify_frontend/domain/repositories/team_repository.dart';

class TeamUseCase {
  final TeamRepository repository;

  TeamUseCase(this.repository);

  Future<TeamModel> createTeam({
    required Team team,
    File? image,
    required String token,
  }) async {
    return repository.createTeam(team, image: image, token: token);
  }

  Future<List<TeamModel>> getTeamsByOwner(String ownerId) {
    return repository.getTeamsByOwner(ownerId);
  }

  Future<TeamModel> getTeamById(String teamId, String token) {
    return repository.getTeamById(teamId, token);
  }

  Future<TeamModel> updateTeam({required String teamId, required TeamModel team, required String token}) async {
    return repository.updateTeam(teamId, team, token);
  }

  Future<TeamModel> activateTeam({required String teamId, required String ownerId, required String token}) {
    return repository.activateTeam(teamId, ownerId, token);
  }

  Future<TeamModel> deactivateTeam({required String teamId, required String token}) {
    return repository.deactivateTeam(teamId, token);
  }

  Future<List<PlayerModel>> getTeamPlayers(String teamId) {
    return repository.getTeamPlayers(teamId);
  }

  Future<UserModel> getUserById(String userId, String token) {
    return repository.getUserById(userId, token);
  }

}
