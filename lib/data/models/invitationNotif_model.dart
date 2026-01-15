import 'package:sportify_frontend/domain/entities/invitationNotif.dart';

class InvitationNotifModel extends InvitationNotif {
  InvitationNotifModel({
    required super.notificationId,
    required super.invitationId,
    required super.teamId,
    required super.teamName,
    super.teamCity,
    super.teamLogo,
    required super.title,
    required super.message,
    required super.isRead,
    required super.createdAt,
  });

  factory InvitationNotifModel.fromJson(Map<String, dynamic> json) {
    return InvitationNotifModel(
      notificationId: json['notificationId'],
      invitationId: json['invitationId'],
      teamId: json['teamId'],
      teamName: json['teamName'],
      teamCity: json['teamCity'],
      teamLogo: json['teamLogo'],
      title: json['title'],
      message: json['message'],
      isRead: json['isRead'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notificationId': notificationId,
      'invitationId': invitationId,
      'teamId': teamId,
      'teamName': teamName,
      'teamCity': teamCity,
      'teamLogo': teamLogo,
      'title': title,
      'message': message,
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
