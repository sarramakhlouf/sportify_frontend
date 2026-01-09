class InvitationModel {
  final String id;
  final String teamId;
  final String senderId;
  final String receiverId;
  final String status;
  final DateTime createdAt;

  InvitationModel({
    required this.id,
    required this.teamId,
    required this.senderId,
    required this.receiverId,
    required this.status,
    required this.createdAt,
  });

  factory InvitationModel.fromJson(Map<String, dynamic> json) {
    return InvitationModel(
      id: json['id'] ?? json['_id'], 
      teamId: json['teamId'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
