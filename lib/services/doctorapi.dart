import 'package:mentalhealthh/models/Doctor.dart'; // Replace with actual path to Doctor.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mentalhealthh/authentication/auth.dart'; // Import your authentication module

class DoctorsApi {
  static const String apiUrl = 'https://nexus-api-h3ik.onrender.com/api/doctors';

  Future<List<Doctor>> fetchDoctors({
    String? name,
    String? specialization,
    String? gender,
    String? city,
    double? minFees,
    double? maxFees,
  }) async {
    try {
      String? token = await Auth.getToken();

      if (token == null) {
        print('Authentication token is missing.');
        throw Exception('Authentication token is missing.');
      }

      Map<String, String> queryParams = {};
      if (name != null) queryParams['name'] = name;
      if (specialization != null) queryParams['specialization'] = specialization;
      if (gender != null) queryParams['gender'] = gender;
      if (city != null) queryParams['city'] = city;
      if (minFees != null) queryParams['minFees'] = minFees.toString();
      if (maxFees != null) queryParams['maxFees'] = maxFees.toString();

      Uri uri = Uri.parse(apiUrl).replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Doctor> doctors = data.map((json) {
          return Doctor(
            id: json['id'] ?? '',
            firstName: json['firstName'] ?? '',
            lastName: json['lastName'] ?? '',
            specialization: json['specialization'] ?? '',
            gender: json['gender'] ?? '',
            city: json['city'] ?? '',
            sessionFees: json['sessionFees'] != null
                ? json['sessionFees'].toDouble()
                : 0.0,
            photoUrl: json['photoUrl'] ?? '',
            bio: json['biography'] ?? '',
            email: json['email'] ?? '',
            schedule: {},
            sessionDuration: Duration(),
          );
        }).toList();
        return doctors;
      } else {
        throw Exception('Failed to load doctors');
      }
    } catch (error) {
      print('Error fetching doctors: $error');
      throw error; // Re-throw the error for the caller to handle
    }
  }

  Future<Map<String, dynamic>> fetchDoctorSchedule(String doctorId) async {
    try {
      String? token = await Auth.getToken();

      if (token == null) {
        print('Authentication token is missing.');
        throw Exception('Authentication token is missing.');
      }

      final response = await http.get(
        Uri.parse('$apiUrl/$doctorId/schedule'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Failed to load doctor schedule');
      }
    } catch (error) {
      print('Error fetching doctor schedule: $error');
      throw error;
    }
  }
}
