import 'dart:io';
import '../entities/team.dart';

abstract class TeamRepository {
  Future<Team> createTeam(Team team, {File? image, required String token,});

  Future<List<Team>> getMyTeams(String ownerId);
}
