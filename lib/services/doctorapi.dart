import 'package:mentalhealthh/models/Doctor.dart'; // Replace with actual path to Doctor.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mentalhealthh/authentication/auth.dart'; // Import your authentication module

class DoctorsApi {
  static const String apiUrl =
      'https://nexus-api-h3ik.onrender.com/api/doctors';

  Future<List<Doctor>> fetchDoctors({
    String? name,
    String? specialization,
    String? gender,
    String? city,
    double? minFees,
    double? maxFees,
    int page = 1,
    int pageSize = 30,
  }) async {
    try {
      String? token = await Auth.getToken();

      if (token == null) {
        print('Authentication token is missing.');
        throw Exception('Authentication token is missing.');
      }

      // Prepare query parameters
      Map<String, dynamic> queryParams = {
        'page': page.toString(),
        'pageSize': pageSize.toString(),
      };
      if (name != null) queryParams['name'] = name;
      if (specialization != null)
        queryParams['specialization'] = specialization;
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
            schedule: {}, // You may need to parse the schedule data if available
            sessionDuration:
                Duration(), // Update this based on your actual data structure
          );
        }).toList();
        return doctors;
      } else {
        throw Exception('Failed to load doctors');
      }
    } catch (error) {
      print('Error fetching doctors: $error');
      throw error;
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

  Future<List<Map<String, dynamic>>> fetchDoctorAppointments({
    required int pageNumber,
    required int pageSize,
  }) async {
    String? token = await Auth.getToken();

    final response = await http.get(
      Uri.parse(
          'https://nexus-api-h3ik.onrender.com/api/appointments/doctors/me?pageNumber=$pageNumber&pageSize=$pageSize'),
      headers: {
        'Authorization': 'Bearer $token', // Add your authentication token here
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data
          .map((appointment) => appointment as Map<String, dynamic>)
          .toList();
    } else {
      throw Exception('Failed to load appointments');
    }
  }

  Future<List<Map<String, dynamic>>> fetchFilteredAppointments({
    String? clientName,
    String? startDate,
    String? endDate,
    String? status,
    int pageNumber = 1,
    int pageSize = 10,
  }) async {
    String? token = await Auth.getToken();

    Map<String, String> queryParams = {
      'pageNumber': pageNumber.toString(),
      'pageSize': pageSize.toString(),
    };
    if (clientName != null) queryParams['clientName'] = clientName;
    if (startDate != null) queryParams['startDate'] = startDate;
    if (endDate != null) queryParams['endDate'] = endDate;
    if (status != null) queryParams['status'] = status;

    Uri uri = Uri.parse(
            'https://nexus-api-h3ik.onrender.com/api/appointments/doctors/me')
        .replace(queryParameters: queryParams);

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    // Log the request URI and response for debugging
    print('Request URL: $uri');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data
          .map((appointment) => appointment as Map<String, dynamic>)
          .toList();
    } else {
      throw Exception('Failed to load appointments');
    }
  }

  Future<void> confirmAppointment(String appointmentId) async {
    String? token = await Auth.getToken();
    final response = await http.put(
      Uri.parse(
          'https://nexus-api-h3ik.onrender.com/api/appointments/$appointmentId/confirm'),
      headers: {
        'Authorization': 'Bearer $token', // Add your authentication token here
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to confirm appointment');
    }
  }

  Future<void> rejectAppointment(String appointmentId, String reason) async {
    try {
      String? token = await Auth.getToken();

      final response = await http.put(
        Uri.parse(
          'https://nexus-api-h3ik.onrender.com/api/appointments/$appointmentId/reject',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(
            {'reason': reason}), // Assuming reason needs to be sent as JSON
      );

      if (response.statusCode == 200) {
        // Appointment rejected successfully
        return;
      } else {
        throw Exception(
            'Failed to reject appointment. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to reject appointment: $error');
    }
  }
}
