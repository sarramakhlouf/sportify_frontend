enum Role { PLAYER, MANAGER }

class User {
  final String id;
  final String firstname;
  final String lastname;
  final String email;
  final Role role;
  final bool isEnabled;
  final String phone;
  final String password;
  final String? playerCode;
  final String? profileImageUrl;
  final DateTime? registrationDate;

  User({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.role,
    required this.isEnabled,
    required this.phone,
    required this.password,
    this.playerCode,
    this.profileImageUrl,
    this.registrationDate,
  });
}
