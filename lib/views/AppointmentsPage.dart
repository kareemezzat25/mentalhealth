import 'package:flutter/material.dart';
import 'package:mentalhealthh/models/Doctor.dart'; // Replace with actual path to Doctor.dart
import 'package:mentalhealthh/services/doctorapi.dart';
import 'package:mentalhealthh/views/DoctorDetailPage.dart';

class AppointmentsPage extends StatefulWidget {
  @override
  _AppointmentsPageState createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  List<Doctor> doctors = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchDoctorsData();
  }

  Future<void> fetchDoctorsData() async {
    setState(() {
      isLoading = true; // Set loading state
    });

    try {
      // Instantiate DoctorsApi and call fetchDoctors method
      List<Doctor> fetchedDoctors = await DoctorsApi().fetchDoctors();

      setState(() {
        doctors = fetchedDoctors;
        isLoading = false; // Set loading state to false after data is fetched
      });
    } catch (error) {
      print('Error fetching doctors: $error');
      setState(() {
        isLoading = false; // Ensure loading state is set to false in case of error
      });
      // Handle error state in your UI as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: doctors.length,
              itemBuilder: (context, index) {
                Doctor doctor = doctors[index];
                String imageUrl = doctor.photoUrl.isNotEmpty
                    ? doctor.photoUrl
                    : 'https://www.shutterstock.com/image-vector/default-avatar-profile-icon-social-600nw-1677509740.jpg'; // Set a default image URL

                return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DoctorDetailPage(doctor: doctor),
                        ),
                      );
                    },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 99, 185, 225), // Set the color of the card to blue
                      borderRadius: BorderRadius.circular(15), // Set border radius here
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(imageUrl),
                                radius: 40,
                              ),
                              SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      doctor.fullName, // Use first name and last name here
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black, // Set the text color to white for better contrast
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      '${doctor.specialization}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white, // Set the text color to white for better contrast
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'Gender: ${doctor.gender}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white, // Set the text color to white for better contrast
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'City: ${doctor.city}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white, // Set the text color to white for better contrast
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'Session Fees: ${doctor.sessionFees} hrs',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white, // Set the text color to white for better contrast
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
