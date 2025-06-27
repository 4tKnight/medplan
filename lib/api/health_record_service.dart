import '../utils/global.dart';
import 'api_client.dart';
import 'endpoints.dart';

class HealthRecordServices {
  final ApiClient _apiClient = ApiClient();

  Future<dynamic> setPersonalHealthInfo({
    required var healthInfo,
    required String dependentId,
  }) async {
    Map<String, dynamic> recordData = {
      'token': getX.read(v.TOKEN),
      'dependent_id': dependentId,
      'health_info': healthInfo,
    };
    final endpoint = dependentId.isEmpty
        ? Endpoints.setPersonalHealthInfo
        : Endpoints.setDependentPersonalHealthInfo;
    final response = await _apiClient.httpPost(endpoint, recordData);
    return response;
  }

  Future<dynamic> updateAllergies({
    required List<dynamic> allergies,
    required String dependentId,
  }) async {
    Map<String, dynamic> recordData = {
      'token': getX.read(v.TOKEN),
      'dependent_id': dependentId,
      'allergies': allergies,
    };
    final endpoint = dependentId.isEmpty
        ? Endpoints.updateAllergies
        : Endpoints.updateDependentAllergies;
    final response = await _apiClient.httpPost(endpoint, recordData);
    return response;
  }

  Future<dynamic> updateSurgeries({
    required List<dynamic> surgeries,
    required String dependentId,
  }) async {
    Map<String, dynamic> recordData = {
      'token': getX.read(v.TOKEN),
      'dependent_id': dependentId,
      'surgeries': surgeries,
    };
    final endpoint = dependentId.isEmpty
        ? Endpoints.updateSurgeries
        : Endpoints.updateDependentSurgeries;
    final response = await _apiClient.httpPost(endpoint, recordData);
    return response;
  }

  Future<dynamic> updateFamilyConditions({
    required List<dynamic> familyConditions,
    required String dependentId,
  }) async {
    Map<String, dynamic> recordData = {
      'token': getX.read(v.TOKEN),
      'dependent_id': dependentId,
      'family_conditions': familyConditions,
    };
    final endpoint = dependentId.isEmpty
        ? Endpoints.updateFamilyConditions
        : Endpoints.updateDependentFamilyConditions;
    final response = await _apiClient.httpPost(endpoint, recordData);
    return response;
  }

  Future<dynamic> viewPulseRate({
    required int month,
    required int year,
    required String dependentId,
  }) async {
    Map<String, dynamic> recordData = {
      'token': getX.read(v.TOKEN),
      'dependent_id': dependentId,
      'month': month,
      'year': year,
    };
    final endpoint = dependentId.isEmpty
        ? Endpoints.viewPulseRate
        : Endpoints.viewDependentPulseRate;
    final response = await _apiClient.httpPost(endpoint, recordData);
    return response;
  }

  Future<dynamic> addPulseRate({
    required var reading,
    required int month,
    required int year,
    required String dependentId,
  }) async {
    Map<String, dynamic> recordData = {
      'token': getX.read(v.TOKEN),
      'dependent_id': dependentId,
      'reading': reading,
      'month': month,
      'year': year,
    };
    final endpoint = dependentId.isEmpty
        ? Endpoints.addPulseRate
        : Endpoints.addDependentPulseRate;
    final response = await _apiClient.httpPost(endpoint, recordData);
    return response;
  }

  Future<dynamic> viewBloodPressure({
    required int month,
    required int year,
    required String dependentId,
  }) async {
    Map<String, dynamic> recordData = {
      'token': getX.read(v.TOKEN),
      'dependent_id': dependentId,
      'month': month,
      'year': year,
    };
    final endpoint = dependentId.isEmpty
        ? Endpoints.viewBloodPressure
        : Endpoints.viewDependentBloodPressure;
    final response = await _apiClient.httpPost(endpoint, recordData);
    return response;
  }

  Future<dynamic> addBloodPressure({
    required var reading,
    required int month,
    required int year,
    required String dependentId,
  }) async {
    Map<String, dynamic> recordData = {
      'token': getX.read(v.TOKEN),
      'dependent_id': dependentId,
      'reading': reading,
      'month': month,
      'year': year,
    };
    final endpoint = dependentId.isEmpty
        ? Endpoints.addBloodPressure
        : Endpoints.addDependentBloodPressure;
    final response = await _apiClient.httpPost(endpoint, recordData);
    return response;
  }

  Future<dynamic> viewTemperature({
    required int month,
    required int year,
    required String dependentId,
  }) async {
    Map<String, dynamic> recordData = {
      'token': getX.read(v.TOKEN),
      'dependent_id': dependentId,
      'month': month,
      'year': year,
    };
    final endpoint = dependentId.isEmpty
        ? Endpoints.viewTemperature
        : Endpoints.viewDependentTemperature;
    final response = await _apiClient.httpPost(endpoint, recordData);
    return response;
  }

  Future<dynamic> addTemperature({
    required var reading,
    required int month,
    required int year,
    required String dependentId,
  }) async {
    Map<String, dynamic> recordData = {
      'token': getX.read(v.TOKEN),
      'dependent_id': dependentId,
      'reading': reading,
      'month': month,
      'year': year,
    };
    final endpoint = dependentId.isEmpty
        ? Endpoints.addTemperature
        : Endpoints.addDependentTemperature;
    final response = await _apiClient.httpPost(endpoint, recordData);
    return response;
  }

  Future<dynamic> viewRespiratoryRate({
    required int month,
    required int year,
    required String dependentId,
  }) async {
    Map<String, dynamic> recordData = {
      'token': getX.read(v.TOKEN),
      'dependent_id': dependentId,
      'month': month,
      'year': year,
    };
    final endpoint = dependentId.isEmpty
        ? Endpoints.viewRespiratoryRate
        : Endpoints.viewDependentRespiratoryRate;
    final response = await _apiClient.httpPost(endpoint, recordData);
    return response;
  }

  Future<dynamic> addRespiratoryRate({
    required var reading,
    required int month,
    required int year,
    required String dependentId,
  }) async {
    Map<String, dynamic> recordData = {
      'token': getX.read(v.TOKEN),
      'dependent_id': dependentId,
      'reading': reading,
      'month': month,
      'year': year,
    };
    final endpoint = dependentId.isEmpty
        ? Endpoints.addRespiratoryRate
        : Endpoints.addDependentRespiratoryRate;
    final response = await _apiClient.httpPost(endpoint, recordData);
    return response;
  }

  Future<dynamic> viewA1cTest({
    required int month,
    required int year,
    required String dependentId,
  }) async {
    Map<String, dynamic> recordData = {
      'token': getX.read(v.TOKEN),
      'dependent_id': dependentId,
      'month': month,
      'year': year,
    };
    final endpoint = dependentId.isEmpty
        ? Endpoints.viewA1cTest
        : Endpoints.viewDependentA1cTest;
    final response = await _apiClient.httpPost(endpoint, recordData);
    return response;
  }

  Future<dynamic> addA1cTest({
    required var reading,
    required int month,
    required int year,
    required String dependentId,
  }) async {
    Map<String, dynamic> recordData = {
      'token': getX.read(v.TOKEN),
      'dependent_id': dependentId,
      'reading': reading,
      'month': month,
      'year': year,
    };
    final endpoint = dependentId.isEmpty
        ? Endpoints.addA1cTest
        : Endpoints.addDependentA1cTest;
    final response = await _apiClient.httpPost(endpoint, recordData);
    return response;
  }

  Future<dynamic> viewFastingBloodGlucose({
    required int month,
    required int year,
    required String dependentId,
  }) async {
    Map<String, dynamic> recordData = {
      'token': getX.read(v.TOKEN),
      'dependent_id': dependentId,
      'month': month,
      'year': year,
    };
    final endpoint = dependentId.isEmpty
        ? Endpoints.viewFastingBloodGlucose
        : Endpoints.viewDependentFastingBloodGlucose;
    final response = await _apiClient.httpPost(endpoint, recordData);
    return response;
  }

  Future<dynamic> addFastingBloodGlucose({
    required var reading,
    required int month,
    required int year,
    required String dependentId,
  }) async {
    Map<String, dynamic> recordData = {
      'token': getX.read(v.TOKEN),
      'dependent_id': dependentId,
      'reading': reading,
      'month': month,
      'year': year,
    };
    final endpoint = dependentId.isEmpty
        ? Endpoints.addFastingBloodGlucose
        : Endpoints.addDependentFastingBloodGlucose;
    final response = await _apiClient.httpPost(endpoint, recordData);
    return response;
  }

  Future<dynamic> viewRandomBloodGlucose({
    required int month,
    required int year,
    required String dependentId,
  }) async {
    Map<String, dynamic> recordData = {
      'token': getX.read(v.TOKEN),
      'dependent_id': dependentId,
      'month': month,
      'year': year,
    };
    final endpoint = dependentId.isEmpty
        ? Endpoints.viewRandomBloodGlucose
        : Endpoints.viewDependentRandomBloodGlucose;
    final response = await _apiClient.httpPost(endpoint, recordData);
    return response;
  }

  Future<dynamic> addRandomBloodGlucose({
    required var reading,
    required int month,
    required int year,
    required String dependentId,
  }) async {
    Map<String, dynamic> recordData = {
      'token': getX.read(v.TOKEN),
      'dependent_id': dependentId,
      'reading': reading,
      'month': month,
      'year': year,
    };
    final endpoint = dependentId.isEmpty
        ? Endpoints.addRandomBloodGlucose
        : Endpoints.addDependentRandomBloodGlucose;
    final response = await _apiClient.httpPost(endpoint, recordData);
    return response;
  }

  Future<dynamic> viewHDL({
    required int month,
    required int year,
    required String dependentId,
  }) async {
    Map<String, dynamic> recordData = {
      'token': getX.read(v.TOKEN),
      'dependent_id': dependentId,
      'month': month,
      'year': year,
    };
    final endpoint = dependentId.isEmpty
        ? Endpoints.viewHDL
        : Endpoints.viewDependentHDL;
    final response = await _apiClient.httpPost(endpoint, recordData);
    return response;
  }

  Future<dynamic> addHDL({
    required var reading,
    required int month,
    required int year,
    required String dependentId,
  }) async {
    Map<String, dynamic> recordData = {
      'token': getX.read(v.TOKEN),
      'dependent_id': dependentId,
      'reading': reading,
      'month': month,
      'year': year,
    };
    final endpoint = dependentId.isEmpty
        ? Endpoints.addHDL
        : Endpoints.addDependentHDL;
    final response = await _apiClient.httpPost(endpoint, recordData);
    return response;
  }

  Future<dynamic> viewLDL({
    required int month,
    required int year,
    required String dependentId,
  }) async {
    Map<String, dynamic> recordData = {
      'token': getX.read(v.TOKEN),
      'dependent_id': dependentId,
      'month': month,
      'year': year,
    };
    final endpoint = dependentId.isEmpty
        ? Endpoints.viewLDL
        : Endpoints.viewDependentLDL;
    final response = await _apiClient.httpPost(endpoint, recordData);
    return response;
  }

  Future<dynamic> addLDL({
    required var reading,
    required int month,
    required int year,
    required String dependentId,
  }) async {
    Map<String, dynamic> recordData = {
      'token': getX.read(v.TOKEN),
      'dependent_id': dependentId,
      'reading': reading,
      'month': month,
      'year': year,
    };
    final endpoint = dependentId.isEmpty
        ? Endpoints.addLDL
        : Endpoints.addDependentLDL;
    final response = await _apiClient.httpPost(endpoint, recordData);
    return response;
  }

  Future<dynamic> viewTriglycerides({
    required int month,
    required int year,
    required String dependentId,
  }) async {
    Map<String, dynamic> recordData = {
      'token': getX.read(v.TOKEN),
      'dependent_id': dependentId,
      'month': month,
      'year': year,
    };
    final endpoint = dependentId.isEmpty
        ? Endpoints.viewTriglycerides
        : Endpoints.viewDependentTriglycerides;
    final response = await _apiClient.httpPost(endpoint, recordData);
    return response;
  }

  Future<dynamic> addTriglycerides({
    required var reading,
    required int month,
    required int year,
    required String dependentId,
  }) async {
    Map<String, dynamic> recordData = {
      'token': getX.read(v.TOKEN),
      'dependent_id': dependentId,
      'reading': reading,
      'month': month,
      'year': year,
    };
    final endpoint = dependentId.isEmpty
        ? Endpoints.addTriglycerides
        : Endpoints.addDependentTriglycerides;
    final response = await _apiClient.httpPost(endpoint, recordData);
    return response;
  }

  Future<dynamic> viewCreatine({
    required int month,
    required int year,
    required String dependentId,
  }) async {
    Map<String, dynamic> recordData = {
      'token': getX.read(v.TOKEN),
      'dependent_id': dependentId,
      'month': month,
      'year': year,
    };
    final endpoint = dependentId.isEmpty
        ? Endpoints.viewCreatine
        : Endpoints.viewDependentCreatine;
    final response = await _apiClient.httpPost(endpoint, recordData);
    return response;
  }

  Future<dynamic> addCreatine({
    required var reading,
    required int month,
    required int year,
    required String dependentId,
  }) async {
    Map<String, dynamic> recordData = {
      'token': getX.read(v.TOKEN),
      'dependent_id': dependentId,
      'reading': reading,
      'month': month,
      'year': year,
    };
    final endpoint = dependentId.isEmpty
        ? Endpoints.addCreatine
        : Endpoints.addDependentCreatine;
    final response = await _apiClient.httpPost(endpoint, recordData);
    return response;
  }

  Future<dynamic> viewEGFR({
    required int month,
    required int year,
    required String dependentId,
  }) async {
    Map<String, dynamic> recordData = {
      'token': getX.read(v.TOKEN),
      'dependent_id': dependentId,
      'month': month,
      'year': year,
    };
    final endpoint = dependentId.isEmpty
        ? Endpoints.viewEGFR
        : Endpoints.viewDependentEGFR;
    final response = await _apiClient.httpPost(endpoint, recordData);
    return response;
  }

  Future<dynamic> addEGFR({
    required var reading,
    required int month,
    required int year,
    required String dependentId,
  }) async {
    Map<String, dynamic> recordData = {
      'token': getX.read(v.TOKEN),
      'dependent_id': dependentId,
      'reading': reading,
      'month': month,
      'year': year,
    };
    final endpoint = dependentId.isEmpty
        ? Endpoints.addEGFR
        : Endpoints.addDependentEGFR;
    final response = await _apiClient.httpPost(endpoint, recordData);
    return response;
  }

  Future<dynamic> viewCD4({
    required int month,
    required int year,
    required String dependentId,
  }) async {
    Map<String, dynamic> recordData = {
      'token': getX.read(v.TOKEN),
      'dependent_id': dependentId,
      'month': month,
      'year': year,
    };
    final endpoint = dependentId.isEmpty
        ? Endpoints.viewCD4
        : Endpoints.viewDependentCD4;
    final response = await _apiClient.httpPost(endpoint, recordData);
    return response;
  }

  Future<dynamic> addCD4({
    required var reading,
    required int month,
    required int year,
    required String dependentId,
  }) async {
    Map<String, dynamic> recordData = {
      'token': getX.read(v.TOKEN),
      'dependent_id': dependentId,
      'reading': reading,
      'month': month,
      'year': year,
    };
    final endpoint = dependentId.isEmpty
        ? Endpoints.addCD4
        : Endpoints.addDependentCD4;
    final response = await _apiClient.httpPost(endpoint, recordData);
    return response;
  }

  Future<dynamic> viewHIV({
    required int month,
    required int year,
    required String dependentId,
  }) async {
    Map<String, dynamic> recordData = {
      'token': getX.read(v.TOKEN),
      'dependent_id': dependentId,
      'month': month,
      'year': year,
    };
    final endpoint = dependentId.isEmpty
        ? Endpoints.viewHIV
        : Endpoints.viewDependentHIV;
    final response = await _apiClient.httpPost(endpoint, recordData);
    return response;
  }

  Future<dynamic> addHIV({
    required var reading,
    required int month,
    required int year,
    required String dependentId,
  }) async {
    Map<String, dynamic> recordData = {
      'token': getX.read(v.TOKEN),
      'dependent_id': dependentId,
      'reading': reading,
      'month': month,
      'year': year,
    };
    final endpoint = dependentId.isEmpty
        ? Endpoints.addHIV
        : Endpoints.addDependentHIV;
    final response = await _apiClient.httpPost(endpoint, recordData);
    return response;
  }

  Future<dynamic> viewBodyFatPercentage({
    required int month,
    required int year,
    required String dependentId,
  }) async {
    Map<String, dynamic> recordData = {
      'token': getX.read(v.TOKEN),
      'dependent_id': dependentId,
      'month': month,
      'year': year,
    };
    final endpoint = dependentId.isEmpty
        ? Endpoints.viewBodyFatPercentage
        : Endpoints.viewDependentBodyFatPercentage;
    final response = await _apiClient.httpPost(endpoint, recordData);
    return response;
  }

  Future<dynamic> addBodyFatPercentage({
    required var reading,
    required int month,
    required int year,
    required String dependentId,
  }) async {
    Map<String, dynamic> recordData = {
      'token': getX.read(v.TOKEN),
      'dependent_id': dependentId,
      'reading': reading,
      'month': month,
      'year': year,
    };
    final endpoint = dependentId.isEmpty
        ? Endpoints.addBodyFatPercentage
        : Endpoints.addDependentBodyFatPercentage;
    final response = await _apiClient.httpPost(endpoint, recordData);
    return response;
  }
  Future<dynamic> viewCaloryConsumption({
    required int month,
    required int year,
    required String dependentId,
  }) async {
    Map<String, dynamic> recordData = {
      'token': getX.read(v.TOKEN),
      'dependent_id': dependentId,
      'month': month,
      'year': year,
    };
    final endpoint = dependentId.isEmpty
        ? Endpoints.viewCaloryConsumption
        : Endpoints.viewDependentCaloryConsumption;
    final response = await _apiClient.httpPost(endpoint, recordData);
    return response;
  }

  Future<dynamic> addCaloryConsumption({
    required var reading,
    required int month,
    required int year,
    required String dependentId,
  }) async {
    Map<String, dynamic> recordData = {
      'token': getX.read(v.TOKEN),
      'dependent_id': dependentId,
      'reading': reading,
      'month': month,
      'year': year,
    };
    final endpoint = dependentId.isEmpty
        ? Endpoints.addCaloryConsumption
        : Endpoints.addDependentCaloryConsumption;
    final response = await _apiClient.httpPost(endpoint, recordData);
    return response;
  }
  Future<dynamic> viewDailySteps({
    required int month,
    required int year,
    required String dependentId,
  }) async {
    Map<String, dynamic> recordData = {
      'token': getX.read(v.TOKEN),
      'dependent_id': dependentId,
      'month': month,
      'year': year,
    };
    final endpoint = dependentId.isEmpty
        ? Endpoints.viewDailySteps
        : Endpoints.viewDependentDailySteps;
    final response = await _apiClient.httpPost(endpoint, recordData);
    return response;
  }

  Future<dynamic> addDailySteps({
    required var reading,
    required int month,
    required int year,
    required String dependentId,
  }) async {
    Map<String, dynamic> recordData = {
      'token': getX.read(v.TOKEN),
      'dependent_id': dependentId,
      'reading': reading,
      'month': month,
      'year': year,
    };
    final endpoint = dependentId.isEmpty
        ? Endpoints.addDailySteps
        : Endpoints.addDependentDailySteps;
    final response = await _apiClient.httpPost(endpoint, recordData);
    return response;
  }


  Future<dynamic> viewWeight({
    required int month,
    required int year,
    required String dependentId,
  }) async {
    Map<String, dynamic> recordData = {
      'token': getX.read(v.TOKEN),
      'dependent_id': dependentId,
      'month': month,
      'year': year,
    };
    final endpoint = dependentId.isEmpty
        ? Endpoints.viewWeight
        : Endpoints.viewDependentWeight;
    final response = await _apiClient.httpPost(endpoint, recordData);
    return response;
  }

  Future<dynamic> addWeight({
    required var reading,
    required int month,
    required int year,
    required String dependentId,
  }) async {
    Map<String, dynamic> recordData = {
      'token': getX.read(v.TOKEN),
      'dependent_id': dependentId,
      'reading': reading,
      'month': month,
      'year': year,
    };
    final endpoint = dependentId.isEmpty
        ? Endpoints.addWeight
        : Endpoints.addDependentWeight;
    final response = await _apiClient.httpPost(endpoint, recordData);
    return response;
  }

  Future<dynamic> viewWaistCircumference({
    required int month,
    required int year,
    required String dependentId,
  }) async {
    Map<String, dynamic> recordData = {
      'token': getX.read(v.TOKEN),
      'dependent_id': dependentId,
      'month': month,
      'year': year,
    };
    final endpoint = dependentId.isEmpty
        ? Endpoints.viewWaistCircumference
        : Endpoints.viewDependentWaistCircumference;
    final response = await _apiClient.httpPost(endpoint, recordData);
    return response;
  }

  Future<dynamic> addWaistCircumference({
    required var reading,
    required int month,
    required int year,
    required String dependentId,
  }) async {
    Map<String, dynamic> recordData = {
      'token': getX.read(v.TOKEN),
      'dependent_id': dependentId,
      'reading': reading,
      'month': month,
      'year': year,
    };
    final endpoint = dependentId.isEmpty
        ? Endpoints.addWaistCircumference
        : Endpoints.addDependentWaistCircumference;
    final response = await _apiClient.httpPost(endpoint, recordData);
    return response;
  }

  Future<dynamic> viewGlassOfWater({
    required int month,
    required int year,
    required String dependentId,
  }) async {
    Map<String, dynamic> recordData = {
      'token': getX.read(v.TOKEN),
      'dependent_id': dependentId,
      'month': month,
      'year': year,
    };
    final endpoint = dependentId.isEmpty
        ? Endpoints.viewGlassOfWater
        : Endpoints.viewDependentGlassOfWater;
    final response = await _apiClient.httpPost(endpoint, recordData);
    return response;
  }

  Future<dynamic> addGlassOfWater({
    required var reading,
    required int month,
    required int year,
    required String dependentId,
  }) async {
    Map<String, dynamic> recordData = {
      'token': getX.read(v.TOKEN),
      'dependent_id': dependentId,
      'reading': reading,
      'month': month,
      'year': year,
    };
    final endpoint = dependentId.isEmpty
        ? Endpoints.addGlassOfWater
        : Endpoints.addDependentGlassOfWater;
    final response = await _apiClient.httpPost(endpoint, recordData);
    return response;
  }

  Future<dynamic> viewAlcoholConsumption({
    required int month,
    required int year,
    required String dependentId,
  }) async {
    Map<String, dynamic> recordData = {
      'token': getX.read(v.TOKEN),
      'dependent_id': dependentId,
      'month': month,
      'year': year,
    };
    final endpoint = dependentId.isEmpty
        ? Endpoints.viewAlcoholConsumption
        : Endpoints.viewDependentAlcoholConsumption;
    final response = await _apiClient.httpPost(endpoint, recordData);
    return response;
  }

  Future<dynamic> addAlcoholConsumption({
    required var reading,
    required int month,
    required int year,
    required String dependentId,
  }) async {
    Map<String, dynamic> recordData = {
      'token': getX.read(v.TOKEN),
      'dependent_id': dependentId,
      'reading': reading,
      'month': month,
      'year': year,
    };
    final endpoint = dependentId.isEmpty
        ? Endpoints.addAlcoholConsumption
        : Endpoints.addDependentAlcoholConsumption;
    final response = await _apiClient.httpPost(endpoint, recordData);
    return response;
  }

  Future<dynamic> viewSleepHours({
    required int month,
    required int year,
    required String dependentId,
  }) async {
    Map<String, dynamic> recordData = {
      'token': getX.read(v.TOKEN),
      'dependent_id': dependentId,
      'month': month,
      'year': year,
    };
    final endpoint = dependentId.isEmpty
        ? Endpoints.viewSleepHours
        : Endpoints.viewDependentSleepHours;
    final response = await _apiClient.httpPost(endpoint, recordData);
    return response;
  }

  Future<dynamic> addSleepHours({
    required var reading,
    required int month,
    required int year,
    required String dependentId,
  }) async {
    Map<String, dynamic> recordData = {
      'token': getX.read(v.TOKEN),
      'dependent_id': dependentId,
      'reading': reading,
      'month': month,
      'year': year,
    };
    final endpoint = dependentId.isEmpty
        ? Endpoints.addSleepHours
        : Endpoints.addDependentSleepHours;
    final response = await _apiClient.httpPost(endpoint, recordData);
    return response;
  }
}