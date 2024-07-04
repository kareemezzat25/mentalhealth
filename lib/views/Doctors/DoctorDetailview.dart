import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mentalhealthh/models/Doctor.dart';
import 'package:mentalhealthh/services/doctorapi.dart';
import 'package:mentalhealthh/views/appointments/AppointmentSlotsview.dart';

class DoctorDetailview extends StatefulWidget {
  final Doctor doctor;

  DoctorDetailview({required this.doctor});

  @override
  _DoctorDetailPageState createState() => _DoctorDetailPageState();
}

class _DoctorDetailPageState extends State<DoctorDetailview> {
  List<Map<String, String>> schedule = [];
  bool isLoading = false;
  PageController _pageController = PageController();

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
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Function to format time from HH:mm to h:mm a
  String _formatTime(String timeString) {
    final time = TimeOfDay(
      hour: int.parse(timeString.split(':')[0]),
      minute: int.parse(timeString.split(':')[1]),
    );

    final formattedTime =
        DateFormat.jm().format(DateTime(1, 1, 1, time.hour, time.minute));

    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    String imageUrl = (widget.doctor.photoUrl != null &&
            widget.doctor.photoUrl.isNotEmpty)
        ? widget.doctor.photoUrl
        : 'https://www.shutterstock.com/image-vector/default-avatar-profile-icon-social-600nw-1677509740.jpg';
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
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
                                  backgroundImage: NetworkImage(imageUrl),
                                  radius: 60,
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : Expanded(
                    child: schedule.isEmpty
                        ? Center(
                            child: Text("No days available for appointments"))
                        : Row(
                            children: [
                              Visibility(
                                visible: schedule.length > 1,
                                child: IconButton(
                                  icon: Icon(Icons.arrow_back_ios),
                                  onPressed: () {
                                    _pageController.previousPage(
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                ),
                              ),
                              Expanded(
                                child: PageView.builder(
                                  controller: _pageController,
                                  itemCount: schedule.length,
                                  itemBuilder: (context, index) {
                                    final day = schedule[index];
                                    return Card(
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(2.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              day['dayOfWeek']!,
                                              style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              'from ${_formatTime(day['startTime']!)}',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            Text(
                                              'to ${_formatTime(day['endTime']!)}',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            SizedBox(height: 15),
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        AppointmentSlotsPage(
                                                      day: day['dayOfWeek']!,
                                                      startTime:
                                                          day['startTime']!,
                                                      endTime: day['endTime']!,
                                                      sessionDuration: Duration(
                                                        minutes: int.parse(
                                                            day['sessionDuration']!
                                                                .split(':')[1]),
                                                      ),
                                                      doctorId:
                                                          widget.doctor.id,
                                                      location: widget.doctor
                                                          .city, // Pass the location
                                                      doctorFees: widget.doctor
                                                          .sessionFees, // Pass doctor fees
                                                    ),
                                                  ),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  primary: Colors.red,
                                                  onPrimary: Colors
                                                      .white // Background color
                                                  ),
                                              child: Text('Book'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Visibility(
                                visible: schedule.length > 1,
                                child: IconButton(
                                  icon: Icon(Icons.arrow_forward_ios),
                                  onPressed: () {
                                    _pageController.nextPage(
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                  ),
          ],
        ),
      ),
    );
  }
}
