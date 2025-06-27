import 'package:medplan/utils/functions.dart';

import '../utils/global.dart';
import 'api_client.dart';
import 'endpoints.dart';

class MedicationReminderService {
  final ApiClient _apiClient = ApiClient();

  Future<dynamic> addMedicationReminder({
    required String medicineName,
    required String reminderTime,
    required String dosageForm,
    required String dosageQuantity,
    required int dailyDosage,
    required int duration,
    required String mealTime,
    required String additionalInstructions,
    required bool isDependent,
    required String dependentId,
  }) async {
    Map<String, dynamic> reminderData = {
      'token': getX.read(v.TOKEN),
      'username': getX.read(v.GETX_USERNAME),
      'medicine_name': medicineName,
      'reminder_time': reminderTime,
      'dosage_form': dosageForm,
      'is_dependent': isDependent,
      'dependent_id': dependentId,
      'dosage_quantity': dosageQuantity,
      'daily_dosage': dailyDosage,
      'duration': duration,
      'meal_time': mealTime,
      'additional_instructions': additionalInstructions,
    };
    final response = await _apiClient.httpPost(
      Endpoints.addMedicationReminder,
      reminderData,
    );
    return response;
  }

  Future<dynamic> editMedicationReminder({
    required String medicationReminderID,
    required String medicineName,
    required String reminderTime,
    required String dosageForm,
    required String dosageQuantity,
    required int dailyDosage,
    required int duration,
    required String mealTime,
    required String additionalInstructions,
  }) async {
    Map<String, dynamic> reminderData = {
      'token': getX.read(v.TOKEN),
      'medication_reminder_id': medicationReminderID,
      'medicine_name': medicineName,
      'reminder_time': reminderTime,
      'dosage_form': dosageForm,
      'dosage_quantity': dosageQuantity,
      'daily_dosage': dailyDosage,
      'duration': duration,
      'meal_time': mealTime,
      'additional_instructions': additionalInstructions,
    };
    final response = await _apiClient.httpPost(
      Endpoints.editMedicationReminder,
      reminderData,
    );
    return response;
  }

  Future<dynamic> deleteMedicationReminder({
    required String medicationReminderID,
  }) async {
    Map<String, dynamic> reminderData = {
      'token': getX.read(v.TOKEN),
      'medication_reminder_id': medicationReminderID,
    };
    final response = await _apiClient.httpPost(
      Endpoints.deleteMedicationReminder,
      reminderData,
    );
    return response;
  }

  Future<dynamic> viewTodaysMedicationReminders({
    required String medFor,
    required String forId,
  }) async {
    Map<String, dynamic> reminderData = {
      'token': getX.read(v.TOKEN),
      'med_for': medFor,
      'for_id': forId,
    };
    final response = await _apiClient.httpPost(
      Endpoints.viewTodaysMedicationReminders,
      reminderData,
    );
    return response;
  }

  Future<dynamic> viewMedicationHistory({
    required int day,
    required int month,
    required int year,
    required String medFor,
    required String dependentId,
  }) async {
    Map<String, dynamic> reminderData = {
      'token': getX.read(v.TOKEN),
      'day': day,
      'month': month,
      'year': year,
      'med_for': medFor,
      'dependent_id': dependentId,
    };
    final response = await _apiClient.httpPost(
      Endpoints.viewMedicationHistory,
      reminderData,
    );
    return response;
  }

  Future<dynamic> searchMedicine({required String drugName}) async {
    Map<String, dynamic> reminderData = {
      'token': getX.read(v.TOKEN),
      'drug_name': drugName,
    };
    final response = await _apiClient.httpPost(
      Endpoints.searchMedicine,
      reminderData,
    );
    return response;
  }

  Future<dynamic> skipMedication({
    required String medicationReminderId,
    required String duration,
    required String skipReason,

    required int dose,
  }) async {
    Map<String, dynamic> reminderData = {
      'token': getX.read(v.TOKEN),
      'medication_reminder_id': medicationReminderId,
      'skip_reason': skipReason,
      'duration': duration,
      'dose': dose,
    };
    final response = await _apiClient.httpPost(
      Endpoints.skipMedication,
      reminderData,
    );
    return response;
  }

  Future<dynamic> takeMedication({
    required String medicationReminderId,
    required String duration,
    required int dose,
  }) async {
    Map<String, dynamic> reminderData = {
      'token': getX.read(v.TOKEN),
      'medication_reminder_id': medicationReminderId,
      'duration': duration,
      'dose': dose,
    };
    final response = await _apiClient.httpPost(
      Endpoints.takeMedication,
      reminderData,
    );
    return response;
  }
}
