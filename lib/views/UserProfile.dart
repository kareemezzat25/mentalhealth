import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mentalhealthh/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:mentalhealthh/api/UserProfileApi.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mentalhealthh/views/UserInfoEdit.dart';
import 'package:mentalhealthh/authentication/auth.dart';

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
          photoUrl: userData['photoUrl'],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    UserModel userModel = Provider.of<UserModel>(context); // Access UserModel

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
                  subtitle: Text('${userData['email'] ?? userModel.userEmail}'),
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
                      padding: EdgeInsets.symmetric(
                          horizontal: 40, vertical: 16), // Custom padding
                      textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ), // Custom text style
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
}
