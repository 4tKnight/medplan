import '../utils/global.dart';
import 'api_client.dart';
import 'endpoints.dart';

class BugReportService {
  final ApiClient _apiClient = ApiClient();


  Future<dynamic> createBugReport(dynamic formData) async {
  
    final response = await _apiClient.dioPost(Endpoints.createBugReport, formData);
    return response; 
  }
  
 
}