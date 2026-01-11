import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.firstname,
    required super.lastname,
    required super.email,
    required super.phone,
    required super.password,
    required super.role,
    required super.isEnabled,
    required super.profileImageUrl,
    super.playerCode,
    super.registrationDate,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    Role parsedRole;
    final roleStr = (json['role'] ?? '').toString().toUpperCase();
    if (roleStr == 'PLAYER') {
      parsedRole = Role.PLAYER;
    } else {
      parsedRole = Role.MANAGER;
    }

    return UserModel(
      id: json['id'] ?? '',
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      password: json['password'] ?? '',
      role: parsedRole,
      isEnabled: json['isEnabled'] ?? false,
      playerCode: json['playerCode'],
      profileImageUrl: json['profileImageUrl'], 
      registrationDate: json['registrationDate'] != null
        ? DateTime.parse(json['registrationDate'])
        : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'phone': phone,
      'password': password,
      'role': role.name,
      'isEnabled': isEnabled,
      'playerCode': playerCode,
      'profileImageUrl': profileImageUrl,
      'registrationDate': registrationDate?.toIso8601String(),
    };
  }
}
