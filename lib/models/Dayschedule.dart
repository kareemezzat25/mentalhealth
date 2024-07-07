
class DaySchedule {
  String dayOfWeek;
  String startTime;
  String endTime;
  String sessionDuration;

  DaySchedule({
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.sessionDuration,
  });

  Map<String, dynamic> toJson() => {
        'dayOfWeek': dayOfWeek,
        'startTime': startTime,
        'endTime': endTime,
        'sessionDuration': sessionDuration,
      };

  factory DaySchedule.fromJson(Map<String, dynamic> json) {
    return DaySchedule(
      dayOfWeek: json['dayOfWeek'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      sessionDuration: json['sessionDuration'],
    );
  }
}