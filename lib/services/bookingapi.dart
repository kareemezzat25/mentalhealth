import 'package:http/http.dart' as http;
import 'dart:convert';

class BookingApi {
  Future<bool> bookAppointment({
    required String doctorId,
    required String startTime,
    required String duration,
    required String location,
    required String reason,
    required int fees,
  }) async {
    final response = await http.post(
      Uri.parse('/api/appointments'),
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
