import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mentalhealthh/api/UserProfileApi.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mentalhealthh/views/UserInfoEdit.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class UserProfile extends StatefulWidget {
  final String userId;

  UserProfile({required this.userId});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  late Future<Map<String, dynamic>> _userDataFuture;
  File? _image;

  @override
  void initState() {
    super.initState();
    _userDataFuture = fetchUserProfile(widget.userId);
  }

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _navigateToEditPage(Map<String, dynamic> userData) {
    String photoUrl = userData['photoUrl'] ?? ''; 
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserInfoEdit(
          userId: widget.userId,
          firstName: userData['firstName'],
          lastName: userData['lastName'],
          gender: userData['gender'],
          birthDate: userData['birthDate'],
          photoUrl:photoUrl, // Pass photoUrl to UserInfoEdit
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(        
        title: Text(
          'User Profile',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent, // Custom app bar color
        elevation: 0,
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
              child: Text(
                'Error fetching user profile',
                style: TextStyle(color: Colors.red), // Custom error text color
              ),
            );
          } else {
            Map<String, dynamic> userData =
                snapshot.data as Map<String, dynamic>;
            return ListView(
              padding: EdgeInsets.all(20),
              children: [
                SizedBox(height: 20),
                Center(
                  child: CircleAvatar(
                    radius: 100,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _image != null
                        ? FileImage(_image!)
                        : NetworkImage(userData['photoUrl']) as ImageProvider,
                  ),
                ),
                SizedBox(height: 20),
                _buildInfoTile('Email:', userData['email']),
                _buildInfoTile('First Name:', userData['firstName']),
                _buildInfoTile('Last Name:', userData['lastName']),
                _buildInfoTile('Birthdate:', userData['birthDate']),
                _buildInfoTile('Gender:', userData['gender']),
                SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    width: 170, // Set the desired width
                    child: ElevatedButton(
                      onPressed: () async {
                        String? result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserInfoEdit(
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
                            _userDataFuture = fetchUserProfile(widget.userId);
                          });
                        }
                      },
                      child: Text('Edit'),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff01579B), // Custom button color
                        onPrimary: Colors.white, // Custom text color
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16), // Custom padding
                        textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ), // Custom text style
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildInfoTile(String title, String value) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      subtitle: Text(
        value,
        style: TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }
}
