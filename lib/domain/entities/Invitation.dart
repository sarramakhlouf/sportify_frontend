class Invitation {
  final String id;
  final String teamId;
  final String senderId;
  final String receiverId;
  final String status;

  Invitation({
    required this.id,
    required this.teamId,
    required this.senderId,
    required this.receiverId,
    required this.status,
  });
}
