import '../utils/global.dart';
import 'api_client.dart';
import 'endpoints.dart';

class NotificationService {
  final ApiClient _apiClient = ApiClient();

  Future<dynamic> viewNotifications() async {
    Map<String, dynamic> diaryData = {
      'token': getX.read(v.TOKEN),
  
    };
    final response =
        await _apiClient.httpPost(Endpoints.viewNotifications, diaryData);
    return response;
  }
  Future<dynamic> deleteNotification({
    required String notificationId,
  }) async {
    Map<String, dynamic> diaryData = {
      'token': getX.read(v.TOKEN),
      'notification_id': notificationId,
    };
    final response =
        await _apiClient.httpPost(Endpoints.deleteNotification, diaryData);
    return response;
  }
}