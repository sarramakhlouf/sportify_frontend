import 'package:sportify_frontend/data/models/player_model.dart';

class Team {
  final String? id;
  final String name;
  final String? city;
  final String color;
  final String? logoUrl;
  final String ownerId;
  final String? teamCode;
  bool isActivated;
  final List<PlayerModel>? players;

  Team({
    this.id,
    required this.name,
    this.city,
    required this.color,
    this.logoUrl,
    required this.ownerId,
    this.teamCode,
    this.isActivated = false,
    this.players,
  });
}
