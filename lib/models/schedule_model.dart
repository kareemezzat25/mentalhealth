// models/schedule_model.dart
import 'package:mentalhealthh/models/Dayschedule.dart';

class ScheduleModel {
  final String doctorId;
  final List<DaySchedule> weekDays;

  ScheduleModel({required this.doctorId, required this.weekDays});

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    var list = json['weekDays'] as List;
    List<DaySchedule> weekDaysList =
        list.map((i) => DaySchedule.fromJson(i)).toList();

    return ScheduleModel(
      doctorId: json['doctorId'],
      weekDays: weekDaysList,
    );
  }
}



class TimeSlot {
  final String startTime;
  final String endTime;

  TimeSlot({required this.startTime, required this.endTime});

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      startTime: json['start_time'],
      endTime: json['end_time'],
    );
  }
}
