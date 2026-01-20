import 'dart:io';
import 'package:sportify_frontend/core/network/api_client.dart';
import 'package:sportify_frontend/data/models/player_model.dart';
import 'package:sportify_frontend/data/models/team_model.dart';
import 'package:sportify_frontend/data/models/user_model.dart';

class TeamRemoteDataSource {
  final ApiClient apiClient;

  TeamRemoteDataSource(this.apiClient);

//--------------------------------------CREATE TEAM-------------------------------------------
  Future<TeamModel> createTeam({required TeamModel team, File? image, required String token,}) async {
    final response = await apiClient.postMultipart(
      '/teams',
      team.toJson(),
      file: image,
      fileKey: 'image',
      jsonKey: 'data',
      token: token,
    );

    return TeamModel.fromJson(response);
  }

//--------------------------------------GET TEAMS BY OWNER-------------------------------------------
  Future<List<TeamModel>> getTeamsByOwner({
    required String ownerId,
  }) async {
    final response = await apiClient.getList(
      '/teams/owner/$ownerId',
    );

    return response.map((e) => TeamModel.fromJson(e)).toList();
  }

//--------------------------------------GET MEMBER TEAMS-------------------------------------------
  Future<List<TeamModel>> getMemberTeams({
    required String userId,
  }) async {
    final response = await apiClient.getList(
      '/teams/member/$userId',
    );

    return response.map((e) => TeamModel.fromJson(e)).toList();
  }

//--------------------------------------GET USER TEAMS-------------------------------------------
  Future<List<TeamModel>> getUserTeams({
    required String userId,
    required String token,
  }) async {
    final response = await apiClient.get(
      '/teams/user/$userId',
      token: token,
    );

    final ownedTeams = (response['ownedTeams'] as List)
        .map((e) => TeamModel.fromJson(e))
        .toList();

    final memberTeams = (response['memberTeams'] as List)
        .map((e) => TeamModel.fromJson(e))
        .toList();

    return [...ownedTeams, ...memberTeams];
  }

//--------------------------------------GET TEAM BY ID-------------------------------------------
  Future<TeamModel> getTeamById({
    required String teamId,
    required String token,
  }) async {
    final response = await apiClient.get(
      '/teams/$teamId',
      token: token,
    );

    return TeamModel.fromJson(response);
  }

//--------------------------------------UPDATE TEAM-------------------------------------------
  Future<TeamModel> updateTeam({
    required String teamId,
    required TeamModel team,
    File? image,
    required String token,
  }) async {
    final response = await apiClient.postMultipart(
      '/teams/$teamId/update',
      team.toJson(),
      file: image,
      fileKey: 'image',
      jsonKey: 'data',
      token: token,
    );

    return TeamModel.fromJson(response);
  }

//--------------------------------------ACTIVATE TEAM-------------------------------------------
  Future<TeamModel> activateTeam({required String teamId, required String ownerId, required String token}) async {
    final response = await apiClient.put(
      '/teams/activate/$teamId/owner/$ownerId', 
      {},
      token: token,
    );
    return TeamModel.fromJson(response);
  }

//-------------------------------------DEACTIVATE TEAM-------------------------------------------
  Future<TeamModel> deactivateTeam({
    required String teamId,
    required String token,
  }) async {
    final response = await apiClient.put(
      '/teams/deactivate/$teamId',
      {},
      token: token,
    );

    return TeamModel.fromJson(response);
  }

//--------------------------------------GET TEAM PLAYERS-------------------------------------------
  Future<List<PlayerModel>> getTeamPlayers({
    required String teamId,
  }) async {
    final response = await apiClient.getList('/teams/$teamId/players');
    return response.map((e) => PlayerModel.fromJson(e)).toList();
  }

  Future<UserModel> getUserById({
    required String userId,
    required String token,
  }) async {
    final response = await apiClient.get(
      '/auth/users/$userId',
      token: token,
    );

    return UserModel.fromJson(response);
  }

//--------------------------------------DELETE TEAM-------------------------------------------
  Future<void> deleteTeam({
    required String teamId,
    required String token,
  }) async {
    await apiClient.delete(
      '/teams/$teamId',
      token: token,
    );
  }

}
