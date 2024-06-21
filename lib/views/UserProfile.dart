import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mentalhealthh/services/UserProfileApi.dart';
import 'package:mentalhealthh/views/UserDoctorInfoEdit.dart';

class UserDoctorProfile extends StatefulWidget {
  final String userId;
  final List<String> roles;

  UserDoctorProfile({required this.userId, required this.roles});

  @override
  _UserDoctorProfileState createState() => _UserDoctorProfileState();
}

class _UserDoctorProfileState extends State<UserDoctorProfile> {
  late Future<Map<String, dynamic>> _userDataFuture;
  File? _image;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _userDataFuture = fetchUserProfile(widget.userId, widget.roles);
  }

  @override
  Widget build(BuildContext context) {
    final isDoctor = widget.roles.contains('Doctor');
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(isDoctor ? 'Doctor Profile' : 'User Profile'),
      ),
      body: FutureBuilder(
        future: _userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error fetching user profile'),
            );
          } else {
            Map<String, dynamic> userData =
                snapshot.data as Map<String, dynamic>;

            // Display different details based on roles
            if (widget.roles.contains('Doctor')) {
              return ListView(
                children: [
                  SizedBox(height: 20),
                  Center(
                    child: CircleAvatar(
                      radius: 122,
                      backgroundImage: _image != null
                          ? FileImage(_image!)
                          : NetworkImage(userData['photoUrl']) as ImageProvider,
                    ),
                  ),
                  SizedBox(height: 20),
                  ListTile(
                    title: Text(
                      'Email:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${userData['email']}'),
                  ),
                  ListTile(
                    title: Text(
                      'First Name:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${userData['firstName']}'),
                  ),
                  ListTile(
                    title: Text(
                      'Last Name:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${userData['lastName']}'),
                  ),
                  ListTile(
                    title: Text(
                      'Specialization:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${userData['specialization']}'),
                  ),
                  ListTile(
                    title: Text(
                      'Biography:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${userData['biography']}'),
                  ),
                  ListTile(
                    title: Text(
                      'Gender:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${userData['gender']}'),
                  ),
                  ListTile(
                    title: Text(
                      'Birth Date:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${userData['birthDate']}'),
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        String? result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserDoctorInfoEdit(
                              userId: widget.userId,
                              firstName: userData['firstName'],
                              lastName: userData['lastName'],
                              gender: userData['gender'],
                              birthDate: userData['birthDate'],
                              photoUrl: userData['photoUrl'],
                              specialization: userData['specialization'],
                              biography: userData['biography'],
                            ),
                          ),
                        );
                        if (result != null) {
                          setState(() {
                            _userDataFuture =
                                fetchUserProfile(widget.userId, widget.roles);
                          });
                        }
                      },
                      child: Text('Edit'),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff01579B),
                        onPrimary: Colors.white,
                        padding: EdgeInsets.symmetric(
                            horizontal: 40, vertical: 16),
                        textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              // Existing code for regular user profile
              return ListView(
                children: [
                  SizedBox(height: 20),
                  Center(
                    child: CircleAvatar(
                      radius: 122,
                      backgroundImage: _image != null
                          ? FileImage(_image!)
                          : NetworkImage(userData['photoUrl']) as ImageProvider,
                    ),
                  ),
                  SizedBox(height: 20),
                  ListTile(
                    title: Text(
                      'Email:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${userData['email']}'),
                  ),
                  ListTile(
                    title: Text(
                      'First Name:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${userData['firstName']}'),
                  ),
                  ListTile(
                    title: Text(
                      'Last Name:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${userData['lastName']}'),
                  ),
                  ListTile(
                    title: Text(
                      'Gender:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${userData['gender']}'),
                  ),
                  ListTile(
                    title: Text(
                      'Birth Date:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${userData['birthDate']}'),
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        String? result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserDoctorInfoEdit(
                              userId: widget.userId,
                              firstName: userData['firstName'],
                              lastName: userData['lastName'],
                              gender: userData['gender'],
                              birthDate: userData['birthDate'],
                              photoUrl: userData['photoUrl'],
                            ),
                          ),
                        );
                        if (result != null) {
                          setState(() {
                            _userDataFuture =
                                fetchUserProfile(widget.userId, widget.roles);
                          });
                        }
                      },
                      child: Text('Edit'),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff01579B),
                        onPrimary: Colors.white,
                        padding: EdgeInsets.symmetric(
                            horizontal: 40, vertical: 16),
                        textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          }
        },
      ),
    );
  }
}


