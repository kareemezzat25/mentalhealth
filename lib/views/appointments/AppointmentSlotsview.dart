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
  final String location; // New parameter for location
  final double doctorFees; // New parameter for doctor fees

  AppointmentSlotsPage({
    required this.day,
    required this.doctorId,
    required this.startTime,
    required this.endTime,
    required this.sessionDuration,
    required this.location, // Initialize new parameter
    required this.doctorFees, // Initialize new parameter
  });

  Future<List<String>> _fetchAvailableSlots(String date) async {
    String? authToken = await Auth.getToken();
    final String apiUrl =
        'https://nexus-api-h3ik.onrender.com/api/doctors/$doctorId/slots?dateTime=$date';

    try {
      final response = await http.get(Uri.parse(apiUrl), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      });

      if (response.statusCode == 200) {
        return List<String>.from(json.decode(response.body));
      } else {
        throw Exception('Failed to load slots');
      }
    } catch (error) {
      print('Error fetching slots: $error');
      return [];
    }
  }

  String _getNextDateForDay(String day) {
    DateTime now = DateTime.now();
    DateTime nextDate = now;
    while (DateFormat('EEEE').format(nextDate) != day) {
      nextDate = nextDate.add(Duration(days: 1));
    }
    return DateFormat('yyyy-MM-dd').format(nextDate);
  }

  Future<void> bookAppointment(
      BuildContext context, String slot, String day, String reason) async {
    String? token = await Auth.getToken();

    String formattedDuration =
        '${sessionDuration.inHours.toString().padLeft(2, '0')}:${sessionDuration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${sessionDuration.inSeconds.remainder(60).toString().padLeft(2, '0')}';

    String nextDate = _getNextDateForDay(day);

    List<String> parts = slot.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);
    int second = int.parse(parts[2]);
    DateTime parsedTime = DateTime.parse(
        '$nextDate ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:${second.toString().padLeft(2, '0')}');
    parsedTime = parsedTime.add(Duration(hours: 3));

    final String startTimeISO =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(parsedTime.toUtc());

    final String apiUrl =
        'https://nexus-api-h3ik.onrender.com/api/appointments';
    final Uri uri = Uri.parse('$apiUrl?doctorId=$doctorId');

    final Map<String, dynamic> requestBody = {
      'startTime': startTimeISO,
      'duration': formattedDuration,
      'location': location,
      'reason': reason,
      'fees': doctorFees,
    };

    try {
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Appointment booked successfully');
        print("Fees:{$doctorFees}");
        print('Response body: ${response.body}');
        _showConfirmationDialog(context);
      } else {
        print(
            'Failed to book appointment. Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error booking appointment: $e');
    }
  }

  void _showBookingDialog(BuildContext context, String slot) {
    String reason = '';
    String slotDate = _getNextDateForDay(day) + ' ' + slot;
    DateTime parsedSlotDate = DateTime.parse(slotDate);
    String formattedSlotDate =
        DateFormat('EEEE, MM/dd/yyyy \'at\' HH:mm:ss').format(parsedSlotDate);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Appointment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Reason (optional)',
                ),
                onChanged: (value) {
                  reason = value;
                },
              ),
              SizedBox(height: 20),
              Text(
                  'Are you sure you want to reserve an appointment with Doctor on $formattedSlotDate?'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                Navigator.of(context).pop();
                bookAppointment(context, slot, day, reason);
              },
            ),
          ],
        );
      },
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Appointment Booked'),
          content: const Text(
              'Appointment booked successfully. Check your appointments page.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String _formatSlot(String slot) {
    List<String> parts = slot.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);

    DateTime time = DateTime(0, 0, 0, hour, minute);
    return DateFormat('h:mm a').format(time);
  }

  @override
  Widget build(BuildContext context) {
    String targetDate = _getNextDateForDay(day);
    return Scaffold(
      appBar: AppBar(
        title: Text('$day'),
      ),
      body: FutureBuilder<List<String>>(
        future: _fetchAvailableSlots(targetDate),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching slots'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No slots available'));
          } else {
            List<String> slots = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Wrap(
                spacing: 10.0,
                runSpacing: 10.0,
                children: slots.map((slot) {
                  String formattedSlot = _formatSlot(slot);
                  return SizedBox(
                    width: MediaQuery.of(context).size.width / 3 - 20,
                    child: GestureDetector(
                      onTap: () {
                        _showBookingDialog(context, slot);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Text(
                          formattedSlot,
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
            );
          }
        },
      ),
    );
  }
}
