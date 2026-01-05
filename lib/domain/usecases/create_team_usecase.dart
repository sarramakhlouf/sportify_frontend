import 'dart:io';
import 'package:sportify_frontend/domain/entities/team.dart';
import 'package:sportify_frontend/domain/repositories/team_repository.dart';

class CreateTeamUseCase {
  final TeamRepository repository;

  CreateTeamUseCase(this.repository);

  Future<Team> call(Team team, {File? image, required String token,}) {
    return repository.createTeam(team, image: image, token: token);
  }
}
