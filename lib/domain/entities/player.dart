class Player {
  final String id;
  final String name;
  final String? avatarUrl;
  final String? role;
  
  Player({
    required this.id, 
    required this.name, 
    this.avatarUrl,
    this.role,
  });
}
