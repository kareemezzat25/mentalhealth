import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mentalhealthh/authentication/auth.dart';
import 'package:mentalhealthh/models/appointment.dart';

class BookingApi {
  final String baseUrl = 'https://nexus-api-h3ik.onrender.com';

  Future<List<Appointment>> getAppointments({
    required int pageNumber,
    required int pageSize,
    String? doctorName,
    String? status,
  }) async {
    try {
      final String? token = await Auth.getToken();

      if (token != null) {
        final Map<String, String> headers = {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        };

        String queryParams = '?pageNumber=$pageNumber&pageSize=$pageSize';
        if (doctorName != null && doctorName.isNotEmpty) {
          queryParams += '&DoctorName=$doctorName';
        }
        if (status != null && status.isNotEmpty) {
          queryParams += '&Status=$status';
        }

        final response = await http.get(
          Uri.parse('$baseUrl/api/appointments/clients/me$queryParams'),
          headers: headers,
        );

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          print('Response data: $responseData');

          if (responseData is List) {
            return responseData
                .map((json) => Appointment.fromJson(json))
                .toList();
          } else {
            throw Exception('Unexpected response structure: $responseData');
          }
        } else {
          throw Exception(
              'Failed to load appointments. Status code: ${response.statusCode}, Body: ${response.body}');
        }
      } else {
        throw Exception('Token not available');
      }
    } catch (error) {
      print('Error during getAppointments: $error');
      throw error;
    }
  }

  Future<void> cancelAppointment(
      int appointmentId, String cancellationReason) async {
    try {
      final String? token = await Auth.getToken();

      if (token != null) {
        final Map<String, String> headers = {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        };

        final response = await http.put(
          Uri.parse('$baseUrl/api/appointments/$appointmentId/cancel'),
          headers: headers,
          body: jsonEncode(cancellationReason),
        );

        if (response.statusCode == 200) {
          print('Appointment $appointmentId cancelled successfully');
        } else {
          throw Exception(
              'Failed to cancel appointment. Status code: ${response.statusCode}, Body: ${response.body}');
        }
      } else {
        throw Exception('Token not available');
      }
    } catch (error) {
      print('Error during cancelAppointment: $error');
      throw error;
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
    print("Feess:{$fees}");
    return response.statusCode == 200;
  }
}
