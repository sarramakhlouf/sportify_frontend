import 'package:sportify_frontend/domain/entities/invitation.dart';

class InvitationModel extends Invitation {
  InvitationModel({
    required String id,
    required String teamId,
    required String senderId,
    required String receiverId,
    required String teamName,
    required String status,
    required DateTime createdAt,
  }) : super(
          id: id,
          teamId: teamId,
          senderId: senderId,
          receiverId: receiverId,
          teamName: teamName,
          status: status,
          createdAt: createdAt,
        );

  factory InvitationModel.fromJson(Map<String, dynamic> json) {
    return InvitationModel(
      id: json['id'] as String,
      teamId: json['teamId'] as String,
      senderId: json['senderId'] as String,
      receiverId: json['receiverId'] as String,
      teamName: json['teamName'] ?? '', 
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
