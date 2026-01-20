import 'dart:io';

import 'package:sportify_frontend/data/datasources/team_remote_data_source.dart';
import 'package:sportify_frontend/data/models/player_model.dart';
import 'package:sportify_frontend/data/models/team_model.dart';
import 'package:sportify_frontend/data/models/user_model.dart';
import 'package:sportify_frontend/domain/entities/team.dart';
import 'package:sportify_frontend/domain/repositories/team_repository.dart';

class TeamRepositoryImpl implements TeamRepository {
  final TeamRemoteDataSource remoteDataSource;

  TeamRepositoryImpl(this.remoteDataSource);

  @override
  Future<TeamModel> createTeam(
    Team team, {
    File? image,
    required String token,
  }) {
    return remoteDataSource.createTeam(
      team: TeamModel(
        name: team.name,
        city: team.city,
        logoUrl: team.logoUrl,
        ownerId: team.ownerId,
      ),
      image: image,
      token: token,
    );
  }

  @override
  Future<List<TeamModel>> getTeamsByOwner(String ownerId) {
    return remoteDataSource.getTeamsByOwner(ownerId: ownerId);
  }

  @override
  Future<List<TeamModel>> getMemberTeams({required String userId}) async {
    return await remoteDataSource.getMemberTeams(userId: userId);
  }

  @override
  Future<List<TeamModel>> getUserTeams({
    required String userId, 
    required String token,
  }){
    return remoteDataSource.getUserTeams( userId: userId, token: token,);
  }

  @override
  Future<TeamModel> getTeamById(
    String teamId, 
    String token
  ) {
    return remoteDataSource.getTeamById(teamId: teamId, token: token);
  }

  @override
  Future<TeamModel> updateTeam({
    required String teamId,
    required TeamModel team,
    File? image,
    required String token,
  }) {
    return remoteDataSource.updateTeam(
      teamId: teamId,
      team: team,
      image: image,
      token: token,
    );
  }


  @override
  Future<TeamModel> activateTeam(
    String teamId, 
    String ownerId, 
    String token
  ) {
    return remoteDataSource.activateTeam(
      teamId: teamId,
      ownerId: ownerId,
      token: token,
    );
  }

  @override
  Future<TeamModel> deactivateTeam(
    String teamId, 
    String token
  ) {
    return remoteDataSource.deactivateTeam(teamId: teamId, token: token);
  }

  @override
  Future<List<PlayerModel>> getTeamPlayers(String teamId) {
    return remoteDataSource.getTeamPlayers(teamId: teamId);
  }

  @override
  Future<UserModel> getUserById(
    String userId, 
    String token
  ) {
    return remoteDataSource.getUserById(userId: userId, token: token);
  }

  @override
  Future<void> deleteTeam({
    required String teamId,
    required String token,
  }) {
    return remoteDataSource.deleteTeam(
      teamId: teamId,
      token: token,
    );
  }

}
