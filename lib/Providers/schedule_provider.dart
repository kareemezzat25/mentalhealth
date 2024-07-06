import 'package:flutter/material.dart';
import 'package:mentalhealthh/models/schedule_model.dart';
import 'package:mentalhealthh/services/ScheduleApi.dart';

class ScheduleProvider extends ChangeNotifier {
  final ScheduleApi _apiService = ScheduleApi();
  ScheduleModel? _schedule;

  ScheduleModel? get schedule => _schedule;

  Future<void> fetchDoctorSchedule(String doctorId) async {
    try {
      _schedule = await _apiService.fetchDoctorSchedule(doctorId);
      notifyListeners();
    } catch (e) {}
  }

  // // Method to update schedule details for a specific day of the week
  // Future<void> updateScheduleDetails(
  //   String doctorId,
  //   String dayOfWeek,
  //   String startTime,
  //   String endTime,
  //   String sessionDuration,
  // ) async {
  //   try {
  //     await _apiService.updateDoctorScheduleDay(
  //       doctorId,
  //       dayOfWeek,
  //       startTime,
  //       endTime,
  //       sessionDuration,
  //     );
  //     // Notify listeners that the schedule has been updated
  //     notifyListeners();
  //   } catch (e) {
  //     throw e; // Propagate the error back to the caller
  //   }
  // }

  Future<void> deleteDoctorSchedule(String doctorId, String dayOfWeek) async {
    try {
      await _apiService.deleteDoctorSchedule(doctorId, dayOfWeek);
      _schedule?.weekDays.removeWhere((day) => day.dayOfWeek == dayOfWeek);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to delete schedule: $e');
    }
  }

  // Method to delete a schedule for a specific day of the week
  Future<void> deleteSchedule(String doctorId, String dayOfWeek) async {
    try {
      await _apiService.deleteDoctorSchedule(doctorId, dayOfWeek);
      // Notify listeners that the schedule has been deleted
      notifyListeners();
    } catch (e) {
      throw e; // Propagate the error back to the caller
    }
  }
}
