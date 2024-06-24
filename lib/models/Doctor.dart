class Doctor {
  String id;
  String firstName;
  String lastName;
  String specialization;
  String gender;
  String city;
  double sessionFees; // Updated to double
  String photoUrl;
  String bio;
  String email;
  Map<String, Map<String, String>> schedule;
  Duration sessionDuration;

  Doctor({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.specialization,
    required this.gender,
    required this.city,
    required this.sessionFees,
    required this.photoUrl,
    required this.bio,
    required this.email,
    required this.schedule,
    required this.sessionDuration,
  });

  // Method to get the full name
  String get fullName => '$firstName $lastName';
}
