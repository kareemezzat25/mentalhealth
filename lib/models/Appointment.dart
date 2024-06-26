class Appointment {
  final int id;
  final String userId;
  final String doctorId;
  final String startTime;
  final String duration;
  final double fees;
  final String clientName;
  final String clientEmail;
  final String clientPhotoUrl;
  final String doctorName;
  final String doctorEmail;
  final String doctorPhotoUrl;
  final String endTime;
  final String status;
  final String location;
  final String? cancellationReason;
  final String? rejectionReason;

  Appointment({
    required this.id,
    required this.userId,
    required this.doctorId,
    required this.startTime,
    required this.duration,
    required this.fees,
    required this.clientName,
    required this.clientEmail,
    required this.clientPhotoUrl,
    required this.doctorName,
    required this.doctorEmail,
    required this.doctorPhotoUrl,
    required this.endTime,
    required this.status,
    required this.location,
    this.cancellationReason,
    this.rejectionReason,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? '',
      doctorId: json['doctorId'] ?? '',
      startTime: json['startTime'] ?? '',
      duration: json['duration'] ?? '',
      fees: json['fees'] != null ? json['fees'].toDouble() : 0.0,
      clientName: json['clientName'] ?? '',
      clientEmail: json['clientEmail'] ?? '',
      clientPhotoUrl: json['clientPhotoUrl'] ?? '',
      doctorName: json['doctorName'] ?? '',
      doctorEmail: json['doctorEmail'] ?? '',
      doctorPhotoUrl: json['doctorPhotoUrl'] ?? '',
      endTime: json['endTime'] ?? '',
      status: json['status'] ?? '',
      location: json['location'] ?? '',
      cancellationReason: json['cancellationReason'],
      rejectionReason: json['rejectionReason'],
    );
  }
}
