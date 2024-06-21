import 'package:flutter/material.dart';
import 'package:mentalhealthh/models/schedule_model.dart';
import 'package:mentalhealthh/services/api_service.dart';

class ScheduleDetailsPage extends StatefulWidget {
  final DaySchedule day;
  final String doctorId;

  ScheduleDetailsPage({required this.doctorId, required this.day});

  @override
  _ScheduleDetailsPageState createState() => _ScheduleDetailsPageState();
}

class _ScheduleDetailsPageState extends State<ScheduleDetailsPage> {
  late TextEditingController _startTimeController;
  late TextEditingController _endTimeController;
  late TextEditingController _sessionDurationController;

  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _startTimeController = TextEditingController(text: widget.day.startTime);
    _endTimeController = TextEditingController(text: widget.day.endTime);
    _sessionDurationController =
        TextEditingController(text: widget.day.sessionDuration);
  }

  @override
  void dispose() {
    _startTimeController.dispose();
    _endTimeController.dispose();
    _sessionDurationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Schedule Details"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              ListTile(
                title: Text(
                  widget.day.dayOfWeek,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),
              _buildEditableRow("Start Time", _startTimeController),
              _buildEditableRow("End Time", _endTimeController),
              _buildEditableRow(
                  "Session Duration", _sessionDurationController),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => _showDeleteConfirmationDialog(context),
                    child: Text('Remove'),
                  ),
                  ElevatedButton(
                    onPressed: () => _updateSchedule(context),
                    child: Text('Update'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditableRow(
      String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label + ":",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              ),
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Deletion"),
          content: Text("Are you sure you want to delete this schedule?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteSchedule(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteSchedule(BuildContext context) async {
    try {
      await _apiService.deleteDoctorSchedule(
          widget.doctorId, widget.day.dayOfWeek);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Schedule deleted"),
        ),
      );
      // Navigate back to SchedulePage and pass the deleted day for removal
      Navigator.of(context).pop(widget.day);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to delete schedule: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _updateSchedule(BuildContext context) {
    // Implement logic to update schedule
    String startTime = _startTimeController.text;
    String endTime = _endTimeController.text;
    String sessionDuration = _sessionDurationController.text;

    // Example validation (you should implement your own validation logic)
    if (startTime.isNotEmpty &&
        endTime.isNotEmpty &&
        sessionDuration.isNotEmpty) {
      // Call API to update schedule with new values
      // Example:
      // ApiService().updateDoctorSchedule(widget.day.doctorId, widget.day.dayOfWeek, startTime, endTime, sessionDuration);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Schedule updated"),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill in all fields"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
