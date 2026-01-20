import 'package:sportify_frontend/data/models/player_model.dart';

class Team {
  final String? id;
  final String name;
  final String? city;
  final String? logoUrl;
  final String ownerId;
  final String? teamCode;
  bool isActivated;
  final List<PlayerModel>? players;
  final DateTime? createdAt;

  Team({
    this.id,
    required this.name,
    this.city,
    this.logoUrl,
    required this.ownerId,
    this.teamCode,
    this.isActivated = false,
    this.players,
    this.createdAt,

  });
}
