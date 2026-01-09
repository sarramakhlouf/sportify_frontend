class NotificationModel {
  final String id;
  final String title;
  final String message;
  final bool isRead;
  final String type;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.isRead,
    required this.type,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      isRead: json['isRead'],
      type: json['type'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
