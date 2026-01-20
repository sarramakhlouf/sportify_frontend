import 'dart:io';
import 'package:sportify_frontend/data/models/player_model.dart';
import 'package:sportify_frontend/data/models/team_model.dart';
import 'package:sportify_frontend/data/models/user_model.dart';
import 'package:sportify_frontend/domain/entities/team.dart';

abstract class TeamRepository {
  Future<TeamModel> createTeam(Team team, {File? image, required String token,});
  Future<List<TeamModel>> getTeamsByOwner(String ownerId);
  Future<List<TeamModel>> getMemberTeams({required String userId});
  Future<List<TeamModel>> getUserTeams({ required String userId, required String token,});
  Future<TeamModel> getTeamById(String teamId, String token);
  Future<TeamModel> updateTeam({required String teamId, required TeamModel team, File? image, required String token,});
  Future<TeamModel> activateTeam(String teamId, String ownerId, String token);
  Future<TeamModel> deactivateTeam(String teamId, String token);
  Future<List<PlayerModel>> getTeamPlayers(String teamId);
  Future<UserModel> getUserById(String userId, String token);
  Future<void> deleteTeam({required String teamId,required String token,});
}
