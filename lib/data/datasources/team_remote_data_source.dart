import 'dart:io';
import 'package:sportify_frontend/core/network/api_client.dart';
import 'package:sportify_frontend/data/models/player_model.dart';
import 'package:sportify_frontend/data/models/team_model.dart';
import 'package:sportify_frontend/data/models/user_model.dart';

class TeamRemoteDataSource {
  final ApiClient apiClient;

  TeamRemoteDataSource(this.apiClient);

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

  Future<List<TeamModel>> getTeamsByOwner({
    required String ownerId,
  }) async {
    final response = await apiClient.getList(
      '/teams/owner/$ownerId',
    );

    return response.map((e) => TeamModel.fromJson(e)).toList();
  }

  // Récupérer une équipe par ID
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

  Future<TeamModel> updateTeam(String teamId, TeamModel team, String token) async {
    final response = await apiClient.put(
      '/teams/$teamId',
      team.toJson(),
      token: token,
    );
    return TeamModel.fromJson(response);
  }

  Future<TeamModel> activateTeam({required String teamId, required String ownerId, required String token}) async {
    final response = await apiClient.put(
      '/teams/activate/$teamId/owner/$ownerId', 
      {},
      token: token,
    );
    return TeamModel.fromJson(response);
  }

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


}
