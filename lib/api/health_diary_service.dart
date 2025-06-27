import '../utils/global.dart';
import 'api_client.dart';
import 'endpoints.dart';

class HealthDiaryService {
  final ApiClient _apiClient = ApiClient();

  Future<dynamic> addHealthDiary({
    required String note,
    required String mood,
    required List<String> symptom,
  }) async {
    Map<String, dynamic> diaryData = {
      'token': getX.read(v.TOKEN),
      'username': getX.read(v.GETX_USERNAME),
      'note': note,
      'mood': mood,
      'symptom': symptom,
    };
    final response =
        await _apiClient.httpPost(Endpoints.addHealthDiary, diaryData);
    return response;
  }

  Future<dynamic> editHealthDiary({
    required String note,
    required String mood,
    required List symptom,
    required String healthDiaryId,
  }) async {
    Map<String, dynamic> diaryData = {
      'token': getX.read(v.TOKEN),
      'health_diary_id': healthDiaryId,
      'note': note,
      'mood': mood,
      'symptoms': symptom,
    };
    final response =
        await _apiClient.httpPost(Endpoints.editHealthDiary, diaryData);
    return response;
  }

  Future<dynamic> deleteHealthDiary({
    required String healthDiaryId,
  }) async {
    Map<String, dynamic> diaryData = {
      'token': getX.read(v.TOKEN),
      'health_diary_id': healthDiaryId,
    };
    final response =
        await _apiClient.httpPost(Endpoints.deleteHealthDiary, diaryData);
    return response;
  }

  Future<dynamic> viewHealthDiaries(int year) async {
    Map<String, dynamic> diaryData = {
      'token': getX.read(v.TOKEN),
      'year': year,
    };
    final response =
        await _apiClient.httpPost(Endpoints.viewHealthDiaries, diaryData);
    return response;
  }
}
