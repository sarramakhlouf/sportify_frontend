class InvitationNotif {
  final String notificationId;
  final String invitationId;

  final String teamId;
  final String teamName;
  final String? teamCity;
  final String? teamLogo;

  final String title;
  final String message;
  final bool isRead;
  final DateTime createdAt;

  InvitationNotif({
    required this.notificationId,
    required this.invitationId,
    required this.teamId,
    required this.teamName,
    this.teamCity,
    this.teamLogo,
    required this.title,
    required this.message,
    required this.isRead,
    required this.createdAt,
  });
}
