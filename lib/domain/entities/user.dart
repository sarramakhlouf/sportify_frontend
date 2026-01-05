enum Role { PLAYER, MANAGER }

class User {
  final String id;
  final String firstname;
  final String lastname;
  final String email;
  final Role role;
  final bool isEnabled;
  final String? playerCode;
  final String? profileImageUrl;

  User({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.role,
    required this.isEnabled,
    this.playerCode,
    this.profileImageUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    // role peut être en minuscule ou majuscule selon le backend
    Role parsedRole;
    final roleStr = (json['role'] ?? '').toString().toUpperCase();
    if (roleStr == 'PLAYER') {
      parsedRole = Role.PLAYER;
    } else {
      parsedRole = Role.MANAGER;
    }

    return User(
      id: json['id'] ?? '',
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      email: json['email'] ?? '',
      role: parsedRole,
      isEnabled: json['isEnabled'] ?? false,
      playerCode: json['playerCode'],
      profileImageUrl: json['profileImageUrl'], // si backend renvoie
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'role': role.name,
      'isEnabled': isEnabled,
      'playerCode': playerCode,
      'profileImageUrl': profileImageUrl,
    };
  }
}
