class Team {
  final String? id;
  final String name;
  final String? city;
  final String color;
  final String? logoUrl;
  final String ownerId;

  Team({
    this.id,
    required this.name,
    this.city,
    required this.color,
    this.logoUrl,
    required this.ownerId,
  });
}
