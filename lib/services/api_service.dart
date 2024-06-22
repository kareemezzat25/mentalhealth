import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mentalhealthh/authentication/auth.dart';
import 'package:mentalhealthh/models/schedule_model.dart';

class ApiService {
  final String baseUrl = 'https://nexus-api-h3ik.onrender.com/api';

  Future<ScheduleModel> fetchDoctorSchedule(String doctorId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/doctors/$doctorId/schedule'));

    if (response.statusCode == 200) {
      return ScheduleModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load schedule');
    }
  }

  Future<bool> createDoctorSchedule(
      String doctorId, List<DaySchedule> schedules) async {
    final url = Uri.parse('$baseUrl/doctors/$doctorId/schedule');
    String? token = await Auth.getToken();

    if (token == null) {
      throw Exception('Authentication token is missing.');
    }

    List<Map<String, dynamic>> scheduleList = schedules
        .map((schedule) => {
              'dayOfWeek': schedule.dayOfWeek,
              'startTime': schedule.startTime,
              'endTime': schedule.endTime,
              'sessionDuration': schedule.sessionDuration,
            })
        .toList();

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'weekDays': scheduleList}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        var errorMessage =
            jsonDecode(response.body)['message'] ?? 'Unknown error';
        print('Error response body: ${response.body}');
        throw Exception('Failed to create schedule: $errorMessage');
      }
    } catch (e) {
      print('Exception occurred: $e');
      throw Exception('Failed to create schedule: ${e.toString()}');
    }
  }

  Future<String> createDoctorScheduleForSingleDay(
      String doctorId, DaySchedule schedule) async {
    final url = Uri.parse('$baseUrl/doctors/$doctorId/schedule/days');
    String? token = await Auth.getToken();

    if (token == null) {
      return 'Authentication token is missing.';
    }

    Map<String, dynamic> scheduleData = {
      'dayOfWeek': schedule.dayOfWeek,
      'startTime': schedule.startTime,
      'endTime': schedule.endTime,
      'sessionDuration': schedule.sessionDuration,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(scheduleData),
      );

      if (response.statusCode == 200) {
        return 'Schedule created successfully';
      } else if (response.statusCode == 409) {
        var errorMessage =
            jsonDecode(response.body)['message'] ?? 'This day already exists.';
        print('Error response body: ${response.body}');
        return errorMessage;
      } else {
        var errorMessage =
            jsonDecode(response.body)['message'] ?? 'Unknown error';
        print('Error response body: ${response.body}');
        return 'Failed to create schedule: $errorMessage';
      }
    } catch (e) {
      print('Exception occurred: $e');
      return 'Failed to create schedule: ${e.toString()}';
    }
  }

  Future<void> deleteDoctorSchedule(String doctorId, String dayOfWeek) async {
    final url =
        Uri.parse('$baseUrl/doctors/$doctorId/schedule/days/$dayOfWeek');
    String? token = await Auth.getToken();

    if (token == null) {
      throw Exception('Authentication token is missing.');
    }

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return;
      } else {
        var errorMessage =
            jsonDecode(response.body)['message'] ?? 'Unknown error';
        print('Error response body: ${response.body}');
        throw Exception('Failed to delete schedule: $errorMessage');
      }
    } catch (e) {
      print('Exception occurred: $e');
      throw Exception('Failed to delete schedule: ${e.toString()}');
    }
  }

  Future<void> deleteEntireDoctorSchedule(String doctorId) async {
    final url = Uri.parse('$baseUrl/doctors/$doctorId/schedule');
    String? token = await Auth.getToken();

    if (token == null) {
      throw Exception('Authentication token is missing.');
    }

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return;
      } else {
        var errorMessage =
            jsonDecode(response.body)['message'] ?? 'Unknown error';
        print('Error response body: ${response.body}');
        throw Exception('Failed to delete entire schedule: $errorMessage');
      }
    } catch (e) {
      print('Exception occurred: $e');
      throw Exception('Failed to delete entire schedule: ${e.toString()}');
    }
  }

  Future<void> updateDoctorScheduleDay(
    String doctorId,
    String dayOfWeek,
    String startTime,
    String endTime,
    String sessionDuration,
  ) async {
    final url =
        Uri.parse('$baseUrl/doctors/$doctorId/schedule/days/$dayOfWeek');
    String? token = await Auth.getToken();

    if (token == null) {
      throw Exception('Authentication token is missing.');
    }

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'startTime': startTime,
          'endTime': endTime,
          'sessionDuration': sessionDuration,
        }),
      );

      if (response.statusCode == 200) {
        return;
      } else {
        var errorMessage =
            jsonDecode(response.body)['message'] ?? 'Unknown error';
        print('Error response body: ${response.body}');
        throw Exception('Failed to update schedule: $errorMessage');
      }
    } catch (e) {
      print('Exception occurred: $e');
      throw Exception('Failed to update schedule: ${e.toString()}');
    }
  }
}
