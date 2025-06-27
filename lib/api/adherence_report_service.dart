import 'package:medplan/utils/functions.dart';

import '../utils/global.dart';
import 'api_client.dart';
import 'endpoints.dart';

class AdherenceReportService {
  final ApiClient _apiClient = ApiClient();

  Future<dynamic> viewAdherenceReports({
    required int month,
    required int year,
  }) async {
    Map<String, dynamic> adherenceReportData = {
      'token': getX.read(v.TOKEN),
      'month': month,
      'year': year,
    };
    final response = await _apiClient.httpPost(
      Endpoints.viewAdherenceReports,
      adherenceReportData,
    );
    return response;
  }
}
