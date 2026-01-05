import 'dart:io';
import 'package:sportify_frontend/core/network/api_client.dart';
import 'package:sportify_frontend/data/models/team_model.dart';

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

  Future<List<TeamModel>> getTeamsByOwner(String ownerId) async {
    final response = await apiClient.post('/teams/owner/$ownerId', {});

    return (response as List).map((e) => TeamModel.fromJson(e)).toList();
  }
}
