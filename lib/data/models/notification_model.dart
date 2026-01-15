class NotificationModel {
  final String id;
  final String? teamName;
  final String title;
  final String message;
  bool isRead;
  final String type;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    this.teamName,
    required this.title,
    required this.message,
    this.isRead = false,
    required this.type,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? '',
      teamName: json['teamName'] ?? '', // <-- fallback vide si null
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      isRead: json['isRead'] ?? false,
      type: json['type'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(), // fallback au cas où
    );
  }
}
