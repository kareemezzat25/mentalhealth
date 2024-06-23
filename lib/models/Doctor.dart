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
  });

  // Method to get the full name
  String get fullName => '$firstName $lastName';
}
