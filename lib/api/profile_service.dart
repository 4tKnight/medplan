import '../utils/global.dart';
import 'api_client.dart';
import 'endpoints.dart';

class ProfileService {
  final ApiClient _apiClient = ApiClient();

  Future<dynamic> editProfile(dynamic formData) async {
    final response = await _apiClient.dioPost(Endpoints.editProfile, formData);
    return response;
  }

  Future<dynamic> viewProfile() async {
    Map<String, dynamic> data = {
      'token': getX.read(v.TOKEN),
    };
    final response = await _apiClient.httpPost(Endpoints.viewProfile, data);
    return response;
  }

  Future<dynamic> editAccountPreferences(var prefs) async {
    Map<String, dynamic> data = {
      'token': getX.read(v.TOKEN),
      'prefs': prefs,
    };
    final response =
        await _apiClient.httpPost(Endpoints.editAccountPreferences, data);
    return response;
  }

   Future<dynamic> setDeviceToken({required String token,required String deviceToken}) async {
    Map<String, dynamic> data = {
      'token':token,
      'device_token':deviceToken
    };
    final response = await _apiClient.httpPost(Endpoints.setDeviceToken, data);
    return response;
  }

   Future<dynamic> increaseMedplanCoins(double coinAmount) async {
    Map<String, dynamic> data = {
      'token': getX.read(v.TOKEN),
      'coin_amount':coinAmount
    };
    final response = await _apiClient.httpPost(Endpoints.increaseMedplanCoins, data);
    return response;
  }
}
