import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting
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

  Future<void> _selectTime(
      BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final formattedTime = formatTimeOfDay(picked);
      setState(() {
        controller.text = formattedTime;
      });
    }
  }

  String formatTimeOfDay(TimeOfDay time) {
    final dateTime = DateTime(2000, 1, 1, time.hour, time.minute, 0);
    return DateFormat('HH:mm:ss').format(dateTime);
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
              _buildTimePickerRow("Start Time", _startTimeController),
              SizedBox(height: 10),
              _buildTimePickerRow("End Time", _endTimeController),
              SizedBox(height: 10),
              _buildEditableRow("Session Duration", _sessionDurationController),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => _updateSchedule(context),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue, // background color
                      onPrimary: Colors.white, // text color
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      textStyle: TextStyle(fontSize: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
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

  Widget _buildTimePickerRow(String label, TextEditingController controller) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(
            "$label:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            readOnly: true,
            controller: controller,
            decoration: InputDecoration(
              suffixIcon: Icon(Icons.access_time),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            ),
            onTap: () => _selectTime(context, controller),
          ),
        ),
      ],
    );
  }

  Widget _buildEditableRow(String label, TextEditingController controller) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(
            "$label:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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
    );
  }

  void _updateSchedule(BuildContext context) {
    String startTime = _startTimeController.text;
    String endTime = _endTimeController.text;
    String sessionDuration = _sessionDurationController.text;

    // Update the DaySchedule object
    widget.day.startTime = startTime;
    widget.day.endTime = endTime;
    widget.day.sessionDuration = sessionDuration;

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Schedule updated"),
      ),
    );

    // Return to previous screen and pass updated DaySchedule
    Navigator.of(context).pop(widget.day);
  }
}
