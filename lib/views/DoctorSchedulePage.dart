import 'package:flutter/material.dart';
import 'package:mentalhealthh/models/Doctor.dart';
import 'package:mentalhealthh/views/AppointmentSlotsPage.dart';
import 'AppointmentSlotsPage.dart';

class DoctorSchedulePage extends StatelessWidget {
  final Doctor doctor;

  DoctorSchedulePage({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Schedule'),
      ),
      body: ListView(
        children: doctor.schedule.keys.map((day) {
          return ListTile(
            title: Text(day),
            subtitle: Text(
              '${doctor.schedule[day]!['startTime']} to ${doctor.schedule[day]!['endTime']}',
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AppointmentSlotsPage(
                    day: day,
                    startTime: doctor.schedule[day]!['startTime']!,
                    endTime: doctor.schedule[day]!['endTime']!,
                    sessionDuration: doctor.sessionDuration,
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
