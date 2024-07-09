import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mentalhealthh/models/Dayschedule.dart';
import 'package:mentalhealthh/services/ScheduleApi.dart';

class CreateScheduleview extends StatefulWidget {
  final String doctorId;

  CreateScheduleview({required this.doctorId});

  @override
  _CreateSchedulePageState createState() => _CreateSchedulePageState();
}

class _CreateSchedulePageState extends State<CreateScheduleview> {
  final _formKey = GlobalKey<FormState>();
  final List<DaySchedule> _weekDays = [
    DaySchedule(dayOfWeek: '', startTime: '', endTime: '', sessionDuration: ''),
  ];
  final _dayOfWeekOptions = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];

  void _addDay() {
    setState(() {
      _weekDays.add(DaySchedule(
          dayOfWeek: '', startTime: '', endTime: '', sessionDuration: ''));
    });
  }

  void _removeDay(int index) {
    setState(() {
      _weekDays.removeAt(index);
    });
  }

  Future<void> _selectTime(
      BuildContext context, int index, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        final formattedTime = formatTimeOfDay(picked);
        if (isStartTime) {
          _weekDays[index].startTime = formattedTime;
        } else {
          _weekDays[index].endTime = formattedTime;
        }
      });
    }
  }

  String formatTimeOfDay(TimeOfDay time) {
    final dateTime = DateTime(2000, 1, 1, time.hour, time.minute, 0);
    return DateFormat('HH:mm:ss').format(dateTime);
  }

  String formatSessionDuration(int minutes) {
    Duration duration = Duration(minutes: minutes);
    String formattedDuration =
        duration.toString().split('.').first.padLeft(8, "0");
    return formattedDuration;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Convert session durations to the required format "HH:mm:ss"
      for (var day in _weekDays) {
        day.sessionDuration =
            formatSessionDuration(int.parse(day.sessionDuration));
      }

      // Check for valid time range
      for (var day in _weekDays) {
        if (day.startTime.isNotEmpty && day.endTime.isNotEmpty) {
          var startTime = DateFormat('HH:mm:ss').parse(day.startTime);
          var endTime = DateFormat('HH:mm:ss').parse(day.endTime);
          if (endTime.isBefore(startTime)) {
            _showErrorDialog('End time must be after start time');
            return;
          }
        }
      }

      // validation Check for maximum session duration
      for (var day in _weekDays) {
        if (sessionDurationToMinutes(day.sessionDuration) > 60) {
          _showErrorDialog('The maximum session duration is 60 minutes');
          return;
        }
      }

      // Check the number of days being submitted
      if (_weekDays.length == 1) {
        // Submit single day
        _submitSingleDay(widget.doctorId, _weekDays[0]);
      } else {
        // Submit multiple days
        ScheduleApi()
            .createDoctorSchedule(widget.doctorId, _weekDays)
            .then((response) {
          if (response) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Schedule created successfully')));
            Navigator.pop(context, _weekDays);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to create schedule')));
          }
        }).catchError((e) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
        });
      }
    }
  }

// Helper function to convert formatted session duration to minutes
  int sessionDurationToMinutes(String sessionDuration) {
    List<String> parts = sessionDuration.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    int seconds = int.parse(parts[2]);
    return hours * 60 + minutes + (seconds > 0 ? 1 : 0);
  }

  void _submitSingleDay(String doctorId, DaySchedule daySchedule) {
    ScheduleApi()
        .createDoctorScheduleForSingleDay(doctorId, daySchedule)
        .then((response) {
      if (response == 'Schedule created successfully') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response)));
        Navigator.pop(context, [daySchedule]);
      } else if (response == 'This day already exists.') {
        _showErrorDialog('This day already exists');
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response)));
      }
    }).catchError((e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    });
  }

  void _showErrorDialog(String message) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Schedule', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _weekDays.length,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButtonFormField<String>(
                          value: _weekDays[index].dayOfWeek.isEmpty
                              ? null
                              : _weekDays[index].dayOfWeek,
                          decoration: InputDecoration(labelText: 'Day of Week'),
                          items: _dayOfWeekOptions.map((String day) {
                            return DropdownMenuItem<String>(
                                value: day, child: Text(day));
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _weekDays[index].dayOfWeek = value!;
                            });
                          },
                          validator: (value) =>
                              value == null ? 'Please select a day' : null,
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          readOnly: true,
                          decoration: InputDecoration(
                              labelText: 'Start Time',
                              suffixIcon: Icon(Icons.access_time)),
                          onTap: () => _selectTime(context, index, true),
                          validator: (value) =>
                              _weekDays[index].startTime.isEmpty
                                  ? 'Please select start time'
                                  : null,
                          controller: TextEditingController(
                              text: _weekDays[index].startTime),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          readOnly: true,
                          decoration: InputDecoration(
                              labelText: 'End Time',
                              suffixIcon: Icon(Icons.access_time)),
                          onTap: () => _selectTime(context, index, false),
                          validator: (value) => _weekDays[index].endTime.isEmpty
                              ? 'Please select end time'
                              : null,
                          controller: TextEditingController(
                              text: _weekDays[index].endTime),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelText: 'Session Duration (minutes)'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter session duration';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _weekDays[index].sessionDuration = value!;
                          },
                        ),
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () => _removeDay(index),
                            child: Text('Remove'),
                            style:
                                ElevatedButton.styleFrom(primary: Colors.red),
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: _addDay,
                    child:
                        Text('Add Day', style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('Submit'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
