import 'dart:io';
import 'package:sportify_frontend/data/models/player_model.dart';
import 'package:sportify_frontend/data/models/team_model.dart';
import 'package:sportify_frontend/domain/entities/team.dart';

abstract class TeamRepository {
  Future<TeamModel> createTeam(Team team, {File? image, required String token,});
  Future<List<TeamModel>> getTeamsByOwner(String ownerId);
  Future<TeamModel> getTeamById(String teamId, String token);
  Future<TeamModel> updateTeam(String teamId, TeamModel team, String token);
  Future<TeamModel> activateTeam(String teamId, String ownerId, String token);
  Future<TeamModel> deactivateTeam(String teamId, String token);
  Future<List<PlayerModel>> getTeamPlayers(String teamId);
}
