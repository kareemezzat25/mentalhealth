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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserInfoEdit(
          userId: widget.userId,
          firstName: userData['firstName'],
          lastName: userData['lastName'],
          gender: userData['gender'],
          birthDate: userData['birthDate'],
          photoUrl: userData['photoUrl'], // Pass photoUrl to UserInfoEdit
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('User Profile'),
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
                    'Birthdate:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('${userData['birthDate']}'),
                ),
                ListTile(
                  title: Text(
                    'Gender:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('${userData['gender']}'),
                ),
                SizedBox(height: 20.0),
                Center(
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
                            photoUrl: userData[
                                'photoUrl'], // Pass photoUrl to UserInfoEdit
                          ),
                        ),
                      );
                      if (result != null) {
                        // Refresh UI after returning from UserInfoEdit
                        setState(() {
                          _userDataFuture = fetchUserProfile(widget.userId);
                        });
                      }
                    },
                    child: Text('Edit'),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
