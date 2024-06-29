import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mentalhealthh/authentication/auth.dart'; // Ensure this path is correct
import 'package:mentalhealthh/models/appointment.dart'; // Ensure this path is correct

class BookingApi {
  final String baseUrl = 'https://nexus-api-h3ik.onrender.com'; // Base URL for the API

  Future<List<Appointment>> getAppointments({required int pageNumber, required int pageSize}) async {
    try {
      final String? token = await Auth.getToken();

      if (token != null) {
        final Map<String, String> headers = {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        };

        final response = await http.get(
          Uri.parse('$baseUrl/api/appointments/clients/me?pageNumber=$pageNumber&pageSize=$pageSize'),
          headers: headers,
        );

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          print('Response data: $responseData'); // Log the entire response to inspect its structure

          if (responseData is List) {
            return responseData.map((json) => Appointment.fromJson(json)).toList();
          } else {
            throw Exception('Unexpected response structure: $responseData');
          }
        } else {
          throw Exception('Failed to load appointments. Status code: ${response.statusCode}, Body: ${response.body}');
        }
      } else {
        throw Exception('Token not available');
      }
    } catch (error) {
      // Handle any network or other errors
      print('Error during getAppointments: $error');
      throw error;
    }
  }
  Future<List<Appointment>> searchAppointmentsByStatus({required String status}) async {
  try {
    final String? token = await Auth.getToken();

    if (token != null) {
      final Map<String, String> headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final response = await http.get(
        Uri.parse('$baseUrl/api/appointments/clients/me?status=$status'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('Response data: $responseData'); // Log the entire response to inspect its structure

        if (responseData is List) {
          return responseData.map((json) => Appointment.fromJson(json)).toList();
        } else {
          throw Exception('Unexpected response structure: $responseData');
        }
      } else {
        throw Exception('Failed to load appointments. Status code: ${response.statusCode}, Body: ${response.body}');
      }
    } else {
      throw Exception('Token not available');
    }
  } catch (error) {
    // Handle any network or other errors
    print('Error during searchAppointmentsByStatus: $error');
    throw error;
  }
}

  // Existing method for booking appointment
  Future<bool> bookAppointment({
    required String doctorId,
    required String startTime,
    required String duration,
    required String location,
    required String reason,
    required double fees,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/appointments'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "doctorId": doctorId,
        "startTime": startTime,
        "duration": duration,
        "location": location,
        "reason": reason,
        "fees": fees,
      }),
    );

    return response.statusCode == 200;
  }
}
