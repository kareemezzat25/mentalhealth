import 'package:flutter/material.dart';
import 'package:mentalhealthh/DoctorViews/schedules/CreateScheduleview.dart';
import 'package:mentalhealthh/models/Dayschedule.dart';
import 'package:mentalhealthh/models/schedule_model.dart';
import 'package:mentalhealthh/services/ScheduleApi.dart';
import 'package:mentalhealthh/widgets/ScheduleCard.dart';

class SchedulePage extends StatefulWidget {
  final String doctorId;

  SchedulePage({required this.doctorId});

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  late Future<ScheduleModel> futureSchedule;
  DaySchedule? selectedDay;

  @override
  void initState() {
    super.initState();
    futureSchedule = ScheduleApi().fetchDoctorSchedule(widget.doctorId);
  }

  // delet day schedule
  void deleteSchedule(DaySchedule day) async {
    try {
      await ScheduleApi().deleteDoctorSchedule(widget.doctorId, day.dayOfWeek);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Schedule deleted"),
        ),
      );

      setState(() {
        futureSchedule = ScheduleApi().fetchDoctorSchedule(widget.doctorId);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to delete schedule: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void deleteEntireSchedule() async {
    try {
      await ScheduleApi().deleteEntireDoctorSchedule(widget.doctorId);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Entire schedule deleted"),
        ),
      );

      setState(() {
        futureSchedule = ScheduleApi().fetchDoctorSchedule(widget.doctorId);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to delete entire schedule: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void navigateToCreateSchedulePage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateScheduleview(doctorId: widget.doctorId),
      ),
    );

    if (result != null && result is List<DaySchedule>) {
      setState(() {
        futureSchedule = ScheduleApi().fetchDoctorSchedule(widget.doctorId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Schedule",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: navigateToCreateSchedulePage,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blueAccent,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      "Create Schedule",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    onPressed: deleteEntireSchedule,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      "Delete Schedule",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              "Weekly Schedule",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<ScheduleModel>(
                future: futureSchedule,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('No schedule available, try adding one'),
                    );
                  } else if (!snapshot.hasData ||
                      snapshot.data!.weekDays.isEmpty) {
                    return Center(child: Text('No Schedule Available'));
                  } else {
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            MediaQuery.of(context).size.width > 600 ? 3 : 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: snapshot.data!.weekDays.length,
                      itemBuilder: (context, index) {
                        return ScheduleCard(
                          doctorId: widget.doctorId,
                          day: snapshot.data!.weekDays[index],
                          onDelete: () {
                            deleteSchedule(snapshot.data!.weekDays[index]);
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
