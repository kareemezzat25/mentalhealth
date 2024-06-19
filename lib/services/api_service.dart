import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mentalhealthh/authentication/auth.dart';
import 'package:mentalhealthh/models/schedule_model.dart';

class ApiService {
  final String baseUrl = 'https://nexus-api-h3ik.onrender.com/api';

  Future<ScheduleModel> fetchDoctorSchedule(String doctorId) async {
    final response = await http.get(Uri.parse('$baseUrl/doctors/$doctorId/schedule'));

    if (response.statusCode == 200) {
      return ScheduleModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load schedule');
    }
  }

  Future<bool> createDoctorSchedule(String doctorId, List<DaySchedule> schedules) async {
    final url = Uri.parse('$baseUrl/doctors/$doctorId/schedule');
    String? token = await Auth.getToken();

    if (token == null) {
      throw Exception('Authentication token is missing.');
    }

    List<Map<String, dynamic>> scheduleList = schedules.map((schedule) => {
      'dayOfWeek': schedule.dayOfWeek,
      'startTime': schedule.startTime,
      'endTime': schedule.endTime,
      'sessionDuration': schedule.sessionDuration,
    }).toList();

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
        var errorMessage = jsonDecode(response.body)['message'] ?? 'Unknown error';
        print('Error response body: ${response.body}');
        throw Exception('Failed to create schedule: $errorMessage');
      }
    } catch (e) {
      print('Exception occurred: $e');
      throw Exception('Failed to create schedule: ${e.toString()}');
    }
  }
}
