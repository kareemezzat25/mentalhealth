import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mentalhealthh/DoctorViews/CreateSchedulePage.dart';
import 'package:mentalhealthh/DoctorViews/ScheduleDetailsPage.dart';
import 'package:mentalhealthh/models/schedule_model.dart';
import 'package:mentalhealthh/services/api_service.dart';
import 'package:auto_size_text/auto_size_text.dart';

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
    futureSchedule = ApiService().fetchDoctorSchedule(widget.doctorId);
  }

  void deleteSchedule(DaySchedule day) async {
    try {
      await ApiService().deleteDoctorSchedule(widget.doctorId, day.dayOfWeek);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Schedule deleted"),
        ),
      );

      setState(() {
        futureSchedule = ApiService().fetchDoctorSchedule(widget.doctorId);
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
      await ApiService().deleteEntireDoctorSchedule(widget.doctorId);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Entire schedule deleted"),
        ),
      );

      setState(() {
        futureSchedule = ApiService().fetchDoctorSchedule(widget.doctorId);
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
        builder: (context) => CreateSchedulePage(doctorId: widget.doctorId),
      ),
    );

    if (result != null && result is List<DaySchedule>) {
      setState(() {
        futureSchedule = ApiService().fetchDoctorSchedule(widget.doctorId);
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
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                  } else if (!snapshot.hasData || snapshot.data!.weekDays.isEmpty) {
                    return Center(child: Text('No Schedule Available'));
                  } else {
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
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

class ScheduleCard extends StatefulWidget {
  DaySchedule day;
  final String doctorId;
  final Function() onDelete;

  ScheduleCard({
    required this.doctorId,
    required this.day,
    required this.onDelete,
  });

  @override
  State<ScheduleCard> createState() => _ScheduleCardState();
}

class _ScheduleCardState extends State<ScheduleCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScheduleDetailsPage(
              doctorId: widget.doctorId,
              day: widget.day,
            ),
          ),
        ).then((updatedDay) {
          if (updatedDay != null) {
            setState(() {
              widget.day = updatedDay;
            });
          }
        });
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: AutoSizeText(
                      widget.day.dayOfWeek,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                      maxLines: 1,
                      minFontSize: 18,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (String result) {
                      if (result == 'Delete') {
                        _showDeleteConfirmationDialog(context);
                      } else if (result == 'Update') {
                        _navigateToUpdateSchedule(context);
                      }
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'Update',
                        child: Row(
                          children: [
                            Icon(Icons.edit),
                            SizedBox(width: 8),
                            Text('Update'),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'Delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete),
                            SizedBox(width: 8),
                            Text('Delete'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              AutoSizeText(
                "Start Time: ${widget.day.startTime}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                minFontSize: 14,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 5),
              AutoSizeText(
                "End Time: ${widget.day.endTime}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                minFontSize: 14,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 5),
              AutoSizeText(
                "Session Duration: ${widget.day.sessionDuration}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                minFontSize: 14,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this schedule?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                widget.onDelete();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToUpdateSchedule(BuildContext context) async {
    final updatedDay = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScheduleDetailsPage(
          doctorId: widget.doctorId,
          day: widget.day,
        ),
      ),
    );

    if (updatedDay != null) {
      setState(() {
        widget.day = updatedDay;
      });
    }
  }
}
