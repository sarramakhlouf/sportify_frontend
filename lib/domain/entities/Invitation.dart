class Invitation {
  final String id;
  final String teamId;
  final String senderId;
  final String receiverId;
  final String teamName;
  final String status;
  final DateTime createdAt;


  Invitation({
    required this.id,
    required this.teamId,
    required this.senderId,
    required this.receiverId,
    required this.teamName,
    required this.status,
    required this.createdAt,
  });
}
