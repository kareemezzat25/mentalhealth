import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mentalhealthh/models/Dayschedule.dart';
import 'package:mentalhealthh/services/ScheduleApi.dart';

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

  final ScheduleApi _apiService = ScheduleApi();

  @override
  void initState() {
    super.initState();
    _startTimeController = TextEditingController(text: widget.day.startTime);
    _endTimeController = TextEditingController(text: widget.day.endTime);
    _sessionDurationController =
        TextEditingController(text: widget.day.sessionDuration.split(':')[1]);
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
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
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

  void _updateSchedule(BuildContext context) async {
    String startTime = _startTimeController.text;
    String endTime = _endTimeController.text;
    int sessionDuration = int.tryParse(_sessionDurationController.text) ?? 0;

    if (sessionDuration <= 0 || sessionDuration > 60) {
      _showErrorDialog(context,
          'Session Duration must be greater than 0 and less than or equal to 60 minutes.');
      return;
    }

    if (isEndTimeBeforeStartTime(startTime, endTime)) {
      _showErrorDialog(context, 'End Time must be greater than Start Time.');
      return;
    }

    String formattedSessionDuration =
        '00:${sessionDuration.toString().padLeft(2, '0')}:00';

    try {
      await _apiService.updateDoctorScheduleDay(
        widget.doctorId,
        widget.day.dayOfWeek,
        startTime,
        endTime,
        formattedSessionDuration,
      );

      widget.day.startTime = startTime;
      widget.day.endTime = endTime;
      widget.day.sessionDuration = formattedSessionDuration;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Schedule updated"),
        ),
      );

      Navigator.of(context).pop(widget.day);
    } catch (e) {
      _showErrorDialog(context, 'Failed to update schedule: ${e.toString()}');
    }
  }

  bool isEndTimeBeforeStartTime(String startTime, String endTime) {
    DateTime start = DateFormat('HH:mm:ss').parse(startTime);
    DateTime end = DateFormat('HH:mm:ss').parse(endTime);
    return end.isBefore(start);
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          title: Text(
            'Error',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: Text(
            message,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'OK',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
