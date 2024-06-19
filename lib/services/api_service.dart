import 'dart:convert';
import 'package:http/http.dart' as http;
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
}
