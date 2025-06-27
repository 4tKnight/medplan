
import 'api_client.dart';
import 'endpoints.dart';

class MedplanStoryService {
  final ApiClient _apiClient = ApiClient();

 

   Future<dynamic> createMedplanStory(dynamic formData) async {
  
    final response = await _apiClient.dioPost(Endpoints.createMedplanStory, formData);
    return response; 
  }
}
