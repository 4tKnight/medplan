import 'package:medplan/utils/functions.dart';

import '../utils/global.dart';
import 'api_client.dart';
import 'endpoints.dart';

class CompanionService {
  final ApiClient _apiClient = ApiClient();

  Future<dynamic> addCompanion(dynamic companionData) async {
    final response = await _apiClient.httpPost(
      Endpoints.addCompanion,
      companionData,
    );

    return response;
  }

  Future<dynamic> editCompanion(dynamic companionData) async {
    final response = await _apiClient.httpPost(
      Endpoints.editCompanion,
      companionData,
    );

    return response;
  }

  Future<dynamic> viewUserTrackees() async {
    Map<String, dynamic> companionData = {
      'token': getX.read(v.TOKEN),
    };

    my_log(companionData);
    final response = await _apiClient.httpPost(
      Endpoints.viewUserTrackees,
      companionData,
    );
    return response;
  }
  
  Future<dynamic> viewUsersCompanions() async {
    Map<String, dynamic> companionData = {
      'token': getX.read(v.TOKEN),
    };

    my_log(companionData);
    final response = await _apiClient.httpPost(
      Endpoints.viewUserCompanions,
      companionData,
    );
    return response;
  }


  Future<dynamic> companionRequest(bool isAccepted) async {
    Map<String, dynamic> companionData = {
      'token': getX.read(v.TOKEN),
      'is_accepted': isAccepted,
    };

    my_log(companionData);
    final response = await _apiClient.httpPost(
      Endpoints.companionRequest,
      companionData,
    );
    return response;
  }

  Future<dynamic> deleteCompanion({
    required String companionID,
    required String companionDocID,
    }) async {
    Map<String, dynamic> companionData = {
      'token': getX.read(v.TOKEN),
      'companion_doc_id':companionDocID,
      'companion_id': companionID,
    };
    final response = await _apiClient.httpPost(
      Endpoints.deleteCompanion,
      companionData,
    );
    return response;
  }

  Future<dynamic> viewAllUsers() async {
    Map<String, dynamic> companionData = {'token': getX.read(v.TOKEN)};
    final response = await _apiClient.httpPost(
      Endpoints.viewAllUsers,
      companionData,
    );
    return response;
  }
}
