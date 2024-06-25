import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:mentalhealthh/authentication/auth.dart';

class AppointmentSlotsPage extends StatelessWidget {
  final String day;
  final String startTime;
  final String endTime;
  final Duration sessionDuration;
  final String doctorId; // Include doctorId as a parameter
  final String authToken; // Add auth token parameter

  AppointmentSlotsPage({
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.sessionDuration,
    required this.doctorId,
    required this.authToken,
  });

  List<String> generateTimeSlots(
      BuildContext context, String start, String end, Duration duration) {
    List<String> slots = [];
    TimeOfDay startTime = TimeOfDay(
      hour: int.parse(start.split(":")[0]),
      minute: int.parse(start.split(":")[1]),
    );
    TimeOfDay endTime = TimeOfDay(
      hour: int.parse(end.split(":")[0]),
      minute: int.parse(end.split(":")[1]),
    );

    while (startTime.hour < endTime.hour ||
        (startTime.hour == endTime.hour && startTime.minute < endTime.minute)) {
      String slot = startTime.format(context); // Use the provided context
      slots.add(slot);

      int totalMinutes =
          startTime.hour * 60 + startTime.minute + duration.inMinutes;
      int newHour = totalMinutes ~/ 60;
      int newMinute = totalMinutes % 60;

      startTime = TimeOfDay(hour: newHour, minute: newMinute);
    }
    return slots;
  }

  Future<void> bookAppointment(String slot) async {
    String? token = await Auth.getToken();

    final DateTime now = DateTime.now();
    final DateFormat timeFormat = DateFormat.jm();

    DateTime parsedTime;

    try {
      // parsedTime = timeFormat.parse(slot);
    } catch (e) {
      final List<String> parts = slot.split(":");
      // int hour = int.parse(parts[0]);
      // int minute = int.parse(parts[1]);
      // parsedTime = DateTime(now.year, now.month, now.day, hour, minute);
    }

    // Format the slot time in ISO 8601 format
    final DateTime slotTime =
        DateTime(now.year, now.month, now.day, now.hour, now.minute);
    final String startTimeISO =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(slotTime.toUtc());

    // Format the session duration
    String formattedDuration =
        '${sessionDuration.inHours.toString().padLeft(2, '0')}:${sessionDuration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${sessionDuration.inSeconds.remainder(60).toString().padLeft(2, '0')}';

    // API endpoint and query parameter
    final String apiUrl =
        'https://nexus-api-h3ik.onrender.com/api/appointments';
    final Uri uri = Uri.parse(
        '$apiUrl?doctorId=$doctorId'); // Include doctorId as a query parameter

    // Request body
    final Map<String, dynamic> requestBody = {
      'startTime': startTimeISO,
      'duration': formattedDuration,
      'location': '',
      'reason': '',
      'fees': 0,
    };

    try {
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${token} ',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        print('Appointment booked successfully');
        //Navigator.pushNamed(context, '/appointment_confirmation');
      } else if (response.statusCode == 201) {
        print('Appointment booked successfully');
        print('Response body: ${response.body}');
        //Navigator.pushNamed(context, '/appointment_confirmation');
      } else {
        print(
            'Failed to book appointment. Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        // Handle other status codes or errors as needed
      }
    } catch (e) {
      print('Error booking appointment: $e');
      // Handle network or other errors
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> slots =
        generateTimeSlots(context, startTime, endTime, sessionDuration);

    return Scaffold(
      appBar: AppBar(
        title: Text('$day'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Wrap(
          spacing: 10.0,
          runSpacing: 10.0,
          children: slots.map((slot) {
            return SizedBox(
              width: MediaQuery.of(context).size.width / 3 - 20,
              child: GestureDetector(
                onTap: () {
                  bookAppointment(
                      slot); // Call bookAppointment when slot is tapped
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    slot,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
