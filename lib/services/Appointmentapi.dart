import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mentalhealthh/authentication/auth.dart';
import 'package:mentalhealthh/models/appointment.dart';

class BookingApi {
  final String baseUrl = 'https://nexus-api-h3ik.onrender.com';

  Future<List<Appointment>> getAppointments({
    required int pageNumber,
    required int pageSize,
  }) async {
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
          print('Response data: $responseData');

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
      print('Error during getAppointments: $error');
      throw error;
    }
  }

  Future<List<Appointment>> searchAppointments({
    String? status,
    String? doctorName,
  }) async {
    try {
      final String? token = await Auth.getToken();

      if (token != null) {
        final Map<String, String> headers = {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        };

        String url = '$baseUrl/api/appointments/clients/me?';

        if (status != null && status.isNotEmpty) {
          url += 'status=$status&';
        }

        if (doctorName != null && doctorName.isNotEmpty) {
          url += 'doctorName=$doctorName';
        }

        final response = await http.get(Uri.parse(url), headers: headers);

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          print('Response data: $responseData');

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
      print('Error during searchAppointments: $error');
      throw error;
    }
  }


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
