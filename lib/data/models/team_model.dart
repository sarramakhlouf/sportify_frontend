import 'package:sportify_frontend/domain/entities/team.dart';

class TeamModel extends Team {
  TeamModel({
    super.id,
    required super.name,
    super.city,
    required super.color,
    super.logoUrl,
    required super.ownerId,
  });

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    return TeamModel(
      id: json['id'],
      name: json['name'],
      city: json['city'],
      color: json['color'],
      logoUrl: json['logoUrl'],
      ownerId: json['ownerId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "city": city,
      "color": color,
      "logoUrl": logoUrl,
      "ownerId": ownerId,
    };
  }
}
