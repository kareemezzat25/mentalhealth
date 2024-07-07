import 'package:mentalhealthh/DoctorViews/schedules/ScheduleDetailsview.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:mentalhealthh/models/Dayschedule.dart';


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
  String formatDuration(String durationString) {
    if (durationString.isNotEmpty) {
      // Assuming durationString is in format "HH:mm:ss"
      List<String> parts = durationString.split(':');
      // Calculate total minutes
      int hours = int.parse(parts[0]);
      int minutes = int.parse(parts[1]);
      int totalMinutes = (hours * 60) + minutes;
      return 'Duration $totalMinutes mins';
    } else {
      return '';
    }
  }

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
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'Update',
                        child: Row(
                          children: [
                            Icon(Icons.edit),
                            SizedBox(width: 2),
                            Text('Update'),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'Delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete),
                            SizedBox(width: 2),
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
                "${formatDuration(widget.day.sessionDuration)}",
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
        // Update the day in the list
        widget.day = updatedDay;
      });
    }
  }
}
