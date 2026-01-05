import 'dart:io';

import 'package:sportify_frontend/data/datasources/team_remote_data_source.dart';
import 'package:sportify_frontend/data/models/team_model.dart';
import 'package:sportify_frontend/domain/entities/team.dart';
import 'package:sportify_frontend/domain/repositories/team_repository.dart';

class TeamRepositoryImpl implements TeamRepository {
  final TeamRemoteDataSource remoteDataSource;

  TeamRepositoryImpl(this.remoteDataSource);

  @override
  Future<Team> createTeam(Team team, {File? image, required String token}) {
    return remoteDataSource.createTeam(
      team: TeamModel(
        name: team.name,
        city: team.city,
        color: team.color,
        logoUrl: team.logoUrl,
        ownerId: team.ownerId,
      ),
      image: image,
      token: token,
    );
  }

  @override
  Future<List<Team>> getMyTeams(String ownerId) {
    return remoteDataSource.getTeamsByOwner(ownerId);
  }
}
