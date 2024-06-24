import 'package:flutter/material.dart';

class AppointmentSlotsPage extends StatelessWidget {
  final String day;
  final String startTime;
  final String endTime;
  final Duration sessionDuration;

  AppointmentSlotsPage({
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.sessionDuration,
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

  @override
  Widget build(BuildContext context) {
    List<String> slots =
        generateTimeSlots(context, startTime, endTime, sessionDuration);

    return Scaffold(
      appBar: AppBar(
        title: Text('Available Slots for $day'),
      ),
      body: ListView.builder(
        itemCount: slots.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(slots[index]),
            onTap: () {
              // Handle slot selection
            },
          );
        },
      ),
    );
  }
}
