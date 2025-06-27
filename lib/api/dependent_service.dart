import 'package:medplan/utils/functions.dart';

import '../utils/global.dart';
import 'api_client.dart';
import 'endpoints.dart';

class DependentService {
  final ApiClient _apiClient = ApiClient();

  Future<dynamic> addDependent(dynamic formData) async {
    final response = await _apiClient.dioPost(Endpoints.addDependent, formData);
    return response;
  }

  Future<dynamic> editDependent(dynamic formData) async {
    final response =
        await _apiClient.dioPost(Endpoints.editDependent, formData);
    return response;
  }

  Future<dynamic> viewUsersDependents() async {
    Map<String, dynamic> dependentData = {
      'token': getX.read(v.TOKEN),
      // 'dependent_ids': getX.read(v.GETX_DEPENDENTS),
    };
    final response =
        await _apiClient.httpPost(Endpoints.viewUsersDependents, dependentData);
    return response;
  }

  Future<dynamic> deleteDependent({required String dependentID}) async {
    Map<String, dynamic> dependentData = {
      'token': getX.read(v.TOKEN),
      'dependent_id': dependentID
    };
    final response =
        await _apiClient.httpPost(Endpoints.deleteDependent, dependentData);
    return response;
  }
}
