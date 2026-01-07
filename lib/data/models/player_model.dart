import 'package:sportify_frontend/domain/entities/player.dart';

class PlayerModel extends Player {
  PlayerModel({
    required super.id,
    required super.name,
    super.avatarUrl,
  });

  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    final id = json['userId']; 
    final firstname = json['firstname'] ?? '';
    final lastname = json['lastname'] ?? '';
    final avatarUrl = json['profileImage'];

    if (id == null || id.isEmpty) {
      throw Exception("Player JSON invalide : userId manquant");
    }

    return PlayerModel(
      id: id,
      name: '$firstname $lastname'.trim(),
      avatarUrl: avatarUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'avatarUrl': avatarUrl,
    };
  }

  PlayerModel copyWith({
    String? id,
    String? name,
    String? avatarUrl,
  }) {
    return PlayerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
