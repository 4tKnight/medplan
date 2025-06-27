import 'package:medplan/utils/functions.dart';

import '../utils/global.dart';
import 'api_client.dart';
import 'endpoints.dart';

class ChatService {
  final ApiClient _apiClient = ApiClient();

  Future<dynamic> sendFile(dynamic formData) async {
    final response = await _apiClient.dioPost(Endpoints.sendFile, formData);
    return response;
  }

  Future<dynamic> checkConvers() async {
    Map<String, dynamic> chatData = {
      'token': getX.read(v.TOKEN),
      // "receiver_id": getX.read(v.GETX_USER_ID),
      "user_type": "user",
      "sender_name": getX.read(v.GETX_USERNAME),
    };
    final response = await _apiClient.httpPost(
      Endpoints.checkConvers,
      chatData,
    );
    return response;
  }

  Future<dynamic> getConversations() async {
    Map<String, dynamic> chatData = {
      'token': getX.read(v.TOKEN),
      // "user_type": "user",
    };
    final response = await _apiClient.httpPost(
      Endpoints.getConversations,
      chatData,
    );
    return response;
  }

  Future<dynamic> getMessages({
    required String convoID,
    required int pagec,
  }) async {
    Map<String, dynamic> chatData = {
      'token': getX.read(v.TOKEN),
      "conv_id": convoID,
      // "pagec": pagec,
      // "resultsPerPage": 30,
    };
    final response = await _apiClient.httpPost(Endpoints.getMessages, chatData);
    return response;
  }
}
