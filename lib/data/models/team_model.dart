import 'package:sportify_frontend/data/models/player_model.dart';
import 'package:sportify_frontend/domain/entities/team.dart';

class TeamModel extends Team {
  TeamModel({
    super.id,
    required super.name,
    super.city,
    required super.color,
    super.logoUrl,
    required super.ownerId,
    super.teamCode,
    super.isActivated = false,
    super.players,
    super.createdAt,
  });

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    return TeamModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      name: json['name'] ?? '',
      city: json['city'],
      color: json['color'] ?? '#FFFFFF',
      logoUrl: json['logoUrl'],
      ownerId: (json['ownerId'] ?? '').toString(),
      teamCode: json['teamCode'],
      isActivated: json['isActivated'] ?? false, 
      players: json['players'] != null
          ? (json['players'] as List)
              .map((p) => PlayerModel.fromJson(p))
              .toList()
          : [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null, 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'city': city,
      'color': color,
      'logoUrl': logoUrl,
      'ownerId': ownerId,
      'isActivated': isActivated,
      'players': players?.map((p) => p.toJson()).toList(),
    };
  }

  TeamModel copyWith({
    String? id,
    String? name,
    String? city,
    String? color,
    String? logoUrl,
    bool? isActivated,
    String? ownerId,
    String? teamCode,
    List<PlayerModel>? players,
    DateTime? createdAt,

  }) {
    return TeamModel(
      id: id ?? this.id,
      name: name ?? this.name,
      city: city ?? this.city,
      color: color ?? this.color,
      logoUrl: logoUrl ?? this.logoUrl,
      isActivated: isActivated ?? this.isActivated,
      ownerId: ownerId ?? this.ownerId,
      teamCode: teamCode ?? this.teamCode,
      players: players ?? this.players,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

