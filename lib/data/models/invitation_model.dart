class InvitationModel {
  final String id;
  final String status;

  InvitationModel({
    required this.id,
    required this.status,
  });

  factory InvitationModel.fromJson(Map<String, dynamic> json) {
    return InvitationModel(
      id: json['id'],
      status: json['status'],
    );
  }
}
