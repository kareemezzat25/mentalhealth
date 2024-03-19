import 'package:flutter/material.dart';
import 'package:mentalhealthh/api/UserProfileApi.dart';
import 'package:mentalhealthh/views/UserInfoEdit.dart';

class UserProfile extends StatefulWidget {
  final String userId;

  UserProfile({required this.userId});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  late Future<Map<String, dynamic>> _userDataFuture;

  @override
  void initState() {
    super.initState();
    _userDataFuture = fetchUserProfile(widget.userId);
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
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              padding: EdgeInsets.all(16.0),
              children: [
                ListTile(
                  title: Text('First Name: ${userData['firstName']}'),
                ),
                ListTile(
                  title: Text('Last Name: ${userData['lastName']}'),
                ),
                ListTile(
                  title: Text('Email: ${userData['email']}'),
                ),
                ListTile(
                  title: Text('Birthdate: ${userData['birthDate']}'),
                ),
                ListTile(
                  title: Text('Gender: ${userData['gender']}'),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () => _navigateToEditPage(userData),
                  child: Text('Edit'),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
