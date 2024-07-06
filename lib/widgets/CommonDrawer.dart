import 'package:flutter/material.dart';
import 'package:mentalhealthh/authentication/auth.dart';
import 'package:mentalhealthh/views/Doctors/Doctorsview.dart';
import 'package:mentalhealthh/views/appointments/Appointmentsview.dart';
import 'package:mentalhealthh/views/articles/ArticlesView.dart';
import 'package:mentalhealthh/views/Forumsview.dart';
import 'package:mentalhealthh/views/notifications/notificationsview.dart';
import 'package:mentalhealthh/views/posts/Posts.dart';
import 'package:mentalhealthh/views/authentication/loginview.dart';
import 'package:mentalhealthh/views/Profiles/UserProfile.dart'; // Import UserProfile.dart
import 'package:mentalhealthh/views/depressiontest/DepressionTest.dart'; // Import DepressionTest.dart
import 'package:mentalhealthh/views/chatbot/chatbotview.dart';
import 'package:provider/provider.dart'; // Import provider package
import 'package:mentalhealthh/providers/notification_count_provider.dart'; // Import NotificationCountProvider

class CommonDrawer extends StatefulWidget {
  final String userId; // Add userId parameter

  CommonDrawer({required this.userId}); // Update constructor
  @override
  _CommonDrawerState createState() => _CommonDrawerState();
}

class _CommonDrawerState extends State<CommonDrawer> {
  String userName = '';
  String userEmail = '';
  String photoUrl = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  _loadUserData() async {
    try {
      // Fetch user data
      String? retrievedUserName = await Auth.getUserName();
      String? retrievedUserEmail = await Auth.getEmail();
      String? retrievedPhotoUrl = await Auth.getPhotoUrl();

      setState(() {
        this.userName = retrievedUserName ?? '';
        this.userEmail = retrievedUserEmail ?? '';
        this.photoUrl = retrievedPhotoUrl ?? '';
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
              color: Color(0xffCAE7EF),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(
                          color: Colors.grey, style: BorderStyle.solid),
                      image: photoUrl.isNotEmpty // Check if photoUrl is not empty
                          ? DecorationImage(
                              image: NetworkImage(photoUrl), // Use NetworkImage with photoUrl
                              fit: BoxFit.cover,
                            )
                          : null, // If photoUrl is empty, don't display any image
                    ),
                    child: photoUrl
                            .isEmpty // If photoUrl is empty, display a default icon
                        ? Icon(Icons.account_circle_outlined, size: 40)
                        : null,
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
                              fontSize: 16,
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
          ListTile(
            leading: Icon(Icons.assignment_outlined),
            title: Text("Depression Test"),
            onTap: () {
              // Close the drawer
              Navigator.pop(context);

              // Navigate to the Depression Test screen
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>DepressionTest(userId: widget.userId)),
              );
            },
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
                    builder: (context) => Forumsview(userId: widget.userId)),
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
                    builder: (context) => UserDoctorProfile(
                        userId: widget.userId, roles: ['User'])),
              );
            },
          ),
          Consumer<NotificationCountProvider>(
            builder: (context, notificationCountProvider, _) => ListTile(
              leading: Stack(
                children: [
                  Icon(Icons.notifications),
                  if (notificationCountProvider.unreadCount > 0)
                    Positioned(
                      right: 0,
                      child: CircleAvatar(
                        radius: 8,
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        child: Text(
                          '${notificationCountProvider.unreadCount}',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                ],
              ),
              title: Text('Notifications'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Notificationsview(userId: widget.userId,),
                  ),
                );
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.article_outlined),
            title: Text('My Forums'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => Posts(
                          userId: widget.userId,
                          showUserPosts: true,
                          roles: ["User"],
                        )),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.chat_bubble_outline),
            title: Text("Chatbot"),
            onTap: () {
              // Close the drawer
              Navigator.pop(context);

              // Navigate to Chatbot screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatbotPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.schedule),
            title: Text("Doctors"),
            onTap: () {
              Navigator.pop(context); // Close the drawer

              // Navigate to DoctorsPage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Doctorsview(userId: widget.userId,)),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.schedule),
            title: Text("Appointments"),
            onTap: () {
              Navigator.pop(context); // Close the drawer

              // Navigate to DoctorsPage
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Appointmentsview(
                          userId: widget.userId,
                        )),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.article_rounded),
            title: Text("Articles"),
            onTap: () {
              Navigator.pop(context); // Close the drawer

              // Navigate to DoctorsPage
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ArticlesView(
                          userId: widget.userId,
                        )),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 60,
            ),
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
