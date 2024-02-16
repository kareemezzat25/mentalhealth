// CommonDrawer.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mentalhealthh/authentication/auth.dart';
import 'package:mentalhealthh/views/ForumsPage.dart';
import 'package:mentalhealthh/views/homeview.dart';
import 'package:mentalhealthh/views/login.dart';

class CommonDrawer extends StatefulWidget {
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
            leading: Icon(Icons.article_outlined),
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
                MaterialPageRoute(builder: (context) => ForumsPage()),
              );
            },
          ),
          const ListTile(
            leading: Icon(Icons.dark_mode_outlined),
            title: Text("Night mode"),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200),
            child: ListTile(
              tileColor: Color(0xff000000),
              leading: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
              title:
                  const Text("Logout", style: TextStyle(color: Colors.white)),
              onTap: () {
                // Perform logout action
                //Auth.signOut();
                // Navigate to login page or initial screen after logout
                Navigator.pop(context); // Close the drawer
                // Navigate to login screen or any other screen after logout
                // Example: Navigator.pushReplacementNamed(context, '/login');
                // Navigate to login screen and replace the current route
                // Navigate to login screen and remove all previous routes
                // Navigate to login page and remove all previous routes from the stack
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Login()), // Replace LoginPage with the actual login page class
                  (route) =>
                      false, // This line removes all previous routes from the stack
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
