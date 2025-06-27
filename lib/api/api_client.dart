import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../utils/global.dart';

class ApiClient {
  final String baseUrl = 'https://server-medplan.onrender.com';
  // final String dioBaseUrl = 'https://server-medplan.onrender.com';
  late final Dio _dio = Dio(BaseOptions(baseUrl: baseUrl));

  Future<dynamic> dioPost(String endpoint, dynamic data) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        options:
            Options(method: "POST", responseType: ResponseType.json,
            headers: {
          "Authorization": getX.read(v.TOKEN),
          "Content-Type": "multipart/form-data",
        }),
      );
      return response.data;
    } catch (e) {
      if (e is DioException) {
        throw Exception('Failed to post data with Dio: ${e.response}');
      } else {
        throw Exception('Failed to post data with Dio: $e');
      }
    }
  }

  Future<dynamic> httpPost(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl$endpoint');

    try {
      final response = await http.post(url,
          body: jsonEncode(data),
          headers: {'Content-Type': 'application/json'});
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Failed to post data with http: $e');
    }
  }
}
