// CommonDrawer.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mentalhealthh/authentication/auth.dart';
import 'package:mentalhealthh/views/ForumsPage.dart';
import 'package:mentalhealthh/views/homeview.dart';
import 'package:mentalhealthh/views/login.dart';
import 'package:mentalhealthh/views/UserProfile.dart'; // Import UserProfile.dart

class CommonDrawer extends StatefulWidget {
  final String userId; // Add userId parameter

  CommonDrawer({required this.userId}); // Update constructor
  @override
  _CommonDrawerState createState() => _CommonDrawerState();
}

class _CommonDrawerState extends State<CommonDrawer> {
  String userName = '';
  String userEmail = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  _loadUserData() async {
    try {
      // Fetch user data
      String? userName = await Auth.getUserName();
      String? userEmail = await Auth.getEmail();

      setState(() {
        this.userName = userName ?? '';
        this.userEmail = userEmail ?? '';
      });
    } catch (error) {
      print('Error loading user data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 200,
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xffD2DFD2),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(
                          color: Colors.grey, style: BorderStyle.solid),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/Memoji Boys 3-15.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            userName,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Flexible(
                          child: Text(
                            userEmail,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const ListTile(
            leading: Icon(Icons.home_outlined),
            title: Text("Home"),
          ),
          const ListTile(
            leading: Icon(Icons.assignment_outlined),
            title: Text("Depression Test"),
          ),
          ListTile(
            leading: const Icon(Icons.bookmark_outline_outlined),
            title: Text("Forums"),
            onTap: () {
              // Close the drawer
              Navigator.pop(context);

              // Navigate to forums screen and replace the current route
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => ForumsPage(userId: widget.userId)),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.account_circle_outlined),
            title: Text("User Profile"),
            onTap: () {
              // Close the drawer
              Navigator.pop(context);

              // Navigate to UserProfile screen
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UserProfile(userId: widget.userId)),
              );
            },
          ),
          const ListTile(
            leading: Icon(Icons.article_outlined),
            title: Text("Discover Articles"),
          ),
          const ListTile(
            leading: Icon(Icons.article_outlined),
            title: Text("Discover Doctors"),
          ),
          const ListTile(
            leading: Icon(Icons.dark_mode_outlined),
            title: Text("Night mode"),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: ListTile(
              tileColor: Color(0xff000000),
              leading: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
              title:
                  const Text("Logout", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context); // Close the drawer

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Login()), // Replace LoginPage with the actual login page class
                  (route) => false,
                );

                // // Exit the app
                // SystemNavigator.pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
