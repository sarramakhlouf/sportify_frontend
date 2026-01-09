import 'package:sportify_frontend/core/network/api_client.dart';
import 'package:sportify_frontend/data/models/notification_model.dart';

class NotificationRemoteDataSource{
  final ApiClient apiClient;

  NotificationRemoteDataSource(this.apiClient);

  Future<List<NotificationModel>> getNotifications(String userId) async {
    final response =
        await apiClient.get('/api/notifications/$userId');

    return (response as List)
        .map((e) => NotificationModel.fromJson(e))
        .toList();
  }
}
