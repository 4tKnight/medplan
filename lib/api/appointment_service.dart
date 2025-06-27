import 'package:medplan/utils/functions.dart';

import '../utils/global.dart';
import 'api_client.dart';
import 'endpoints.dart';

class AppointmentService {
  final ApiClient _apiClient = ApiClient();

  Future<dynamic> createAppointment({
    required int appointmentTimestamp,
    required String reminderTime,
    required String additionalInformation,
    required String appointmentTime,
    required String appointmentDate,
    required String appointmentName,
    required String hospitalName,
    required String doctorName,
  }) async {
    Map<String, dynamic> appointmentData = {
      'token': getX.read(v.TOKEN),
      'appointment_timestamp': appointmentTimestamp,
      'reminder_time': reminderTime,
      'additional_information': additionalInformation,
      'appointment_time': appointmentTime,
      'appointment_date': appointmentDate,
      'appointment_name': appointmentName,
      'hospital_name': hospitalName,
      'doctors_name': doctorName,
    };

    final response = await _apiClient.httpPost(
      Endpoints.createAppointment,
      appointmentData,
    );
    return response;
  }

  Future<dynamic> editAppointment({
    required String appointmentID,
    required int appointmentTimestamp,
    required String reminderTime,
    required String additionalInformation,
    required String appointmentTime,
    required String appointmentDate,
    required String appointmentName,
    required String hospitalName,
    required String doctorName,
  }) async {
    Map<String, dynamic> appointmentData = {
      'token': getX.read(v.TOKEN),
      'appointment_id': appointmentID,
      'appointment_timestamp': appointmentTimestamp,
      'reminder_time': reminderTime,
      'additional_information': additionalInformation,
      'appointment_time': appointmentTime,
      'appointment_date': appointmentDate,
      'appointment_name': appointmentName,
      'hospital_name': hospitalName,
      'doctors_name': doctorName,
    };
    final response = await _apiClient.httpPost(
      Endpoints.editAppointment,
      appointmentData,
    );
    return response;
  }

  Future<dynamic> deleteAppointment({required String appointmentID}) async {
    Map<String, dynamic> appointmentData = {
      'token': getX.read(v.TOKEN),
      'appointment_id': appointmentID,
    };
    final response = await _apiClient.httpPost(
      Endpoints.deleteAppointment,
      appointmentData,
    );
    return response;
  }

  Future<dynamic> viewUpcomingAppointment() async {
    Map<String, dynamic> appointmentData = {'token': getX.read(v.TOKEN)};
    final response = await _apiClient.httpPost(
      Endpoints.viewUpcomingAppointment,
      appointmentData,
    );
    return response;
  }
}
