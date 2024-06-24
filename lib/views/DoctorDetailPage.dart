import 'package:flutter/material.dart';
import 'package:mentalhealthh/models/Doctor.dart'; // Replace with actual path to Doctor.dart
import 'package:mentalhealthh/services/doctorapi.dart';
import 'package:mentalhealthh/views/AppointmentSlotsPage.dart';

class DoctorDetailPage extends StatefulWidget {
  final Doctor doctor;

  DoctorDetailPage({required this.doctor});

  @override
  _DoctorDetailPageState createState() => _DoctorDetailPageState();
}

class _DoctorDetailPageState extends State<DoctorDetailPage> {
  List<Map<String, String>> schedule = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchDoctorSchedule();
  }

  Future<void> fetchDoctorSchedule() async {
    setState(() {
      isLoading = true;
    });

    try {
      Map<String, dynamic> fetchedSchedule =
          await DoctorsApi().fetchDoctorSchedule(widget.doctor.id);
      List<dynamic> weekDays = fetchedSchedule['weekDays'];

      List<Map<String, String>> parsedSchedule = weekDays.map((day) {
        return {
          'dayOfWeek': day['dayOfWeek'] as String,
          'startTime': day['startTime'] as String,
          'endTime': day['endTime'] as String,
          'sessionDuration': day['sessionDuration'] as String,
        };
      }).toList();

      setState(() {
        schedule = parsedSchedule;
        isLoading = false;
      });
    } catch (error) {
      print('Error fetching schedule: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                NetworkImage(widget.doctor.photoUrl),
                            radius: 60,
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.doctor.fullName,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Gender: ${widget.doctor.gender}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Email: ${widget.doctor.email}',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Specialization: ${widget.doctor.specialization}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Session Fees: ${widget.doctor.sessionFees} hrs',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Biography: ${widget.doctor.bio}',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      isLoading
                          ? Center(child: CircularProgressIndicator())
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Schedule:',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10),
                                ...schedule.map((day) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AppointmentSlotsPage(
                                            day: day['dayOfWeek']!,
                                            startTime: day['startTime']!,
                                            endTime: day['endTime']!,
                                            sessionDuration: Duration(
                                              minutes: int.parse(
                                                  day['sessionDuration']!
                                                      .split(':')[1]),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Card(
                                      child: ListTile(
                                        title: Text(
                                            '${day['dayOfWeek']}: ${day['startTime']} - ${day['endTime']}'),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20), // Spacer for future use
            ],
          ),
        ),
      ),
    );
  }
}
