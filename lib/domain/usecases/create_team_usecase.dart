import 'dart:io';
import 'package:sportify_frontend/domain/entities/team.dart';
import 'package:sportify_frontend/domain/repositories/team_repository.dart';
import 'package:sportify_frontend/data/models/team_model.dart';

class CreateTeamUseCase {
  final TeamRepository repository;

  CreateTeamUseCase(this.repository);

  Future<TeamModel> call({
    required Team team,
    File? image,
    required String token,
  }) {
    return repository.createTeam(team, image: image, token: token);
  }
}
