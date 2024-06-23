import 'package:flutter/material.dart';
import 'package:mentalhealthh/models/Doctor.dart'; // Replace with actual path to Doctor.dart
import 'package:mentalhealthh/services/doctorapi.dart';

class DoctorDetailPage extends StatelessWidget {
  final Doctor doctor;

  DoctorDetailPage({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(doctor.photoUrl),
                            radius: 60,
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  doctor.fullName,
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Gender: ${doctor.gender}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Email: ${doctor.email}',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Specialization: ${doctor.specialization}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Session Fees: ${doctor.sessionFees} hrs',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Biography: ${doctor.bio}',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20), // Spacer for future use
              
            ],
          ),
        ),
      ),
    );
  }
}
