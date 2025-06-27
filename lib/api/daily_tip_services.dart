import '../utils/global.dart';
import 'api_client.dart';
import 'endpoints.dart';

class DailyTipService {
  final ApiClient _apiClient = ApiClient();

  

  Future<dynamic> incDailyTipShareCount(String dailyTipId) async {
    Map<String, dynamic> data = {
      'daily_tip_id': dailyTipId,
    };
    final response = await _apiClient.httpPost(Endpoints.incDailyTipShareCount, data);
    return response;
  }

  Future<dynamic> likeDailyTip(String dailyTipId ) async {
    Map<String, dynamic> data = {
      'token': getX.read(v.TOKEN),
      'daily_tip_id': dailyTipId,

    };
    final response = await _apiClient.httpPost(Endpoints.likeDailyTip, data);
    return response;
  }

  Future<dynamic> viewDailyTips() async {
    Map<String, dynamic> data = {
      'token': getX.read(v.TOKEN),

    };
    final response = await _apiClient.httpPost(Endpoints.viewDailyTips, data);
    return response;
  }

 
}
