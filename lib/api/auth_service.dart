import '../utils/global.dart';
import 'api_client.dart';
import 'endpoints.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();


  Future<dynamic> login(String email, String password) async {
    Map<String, dynamic> userData = {
      'email': email,
      'password': password,
    };
    final response = await _apiClient.httpPost(Endpoints.login, userData);
    return response; 
  }
  
  Future<dynamic> signup({
    required String phoneNo,
    required String email,
    required String password,
    required String username,
  }) async {
    Map<String, dynamic> userData = {
      'phone_no':phoneNo,
      'email':email,
      'password':password,
      'username':username, 
    };
    final response = await _apiClient.httpPost(Endpoints.signup, userData);
    return response; 
  }

  Future<dynamic> forgotPassword({
    required String email,
  }) async {
    Map<String, dynamic> userData = {
      'email':email,
    };
    final response = await _apiClient.httpPost(Endpoints.forgotPassword, userData);
    return response; 
  }

  Future<dynamic> logout() async {
    Map<String, dynamic> userData = {
      'token':getX.read(v.TOKEN),
    };
    final response = await _apiClient.httpPost(Endpoints.logout, userData);
    return response; 
  }

   Future<dynamic> deleteAccount({
    required String password,
  }) async {
    Map<String, dynamic> userData = {
      'token':getX.read(v.TOKEN),
      'password':password,
    };
    final response = await _apiClient.httpPost(Endpoints.deleteAccount, userData);
    return response; 
  }
}