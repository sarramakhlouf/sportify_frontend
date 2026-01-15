class NotificationEntity {
  final String id;
  final String teamName;
  final String title;
  final String message;
  final bool isRead;
  final String type;
  final DateTime createdAt;

  NotificationEntity({
    required this.id,
    required this.teamName,
    required this.title,
    required this.message,
    required this.isRead,
    required this.type,
    required this.createdAt,
  });
}
