import 'package:flutter/material.dart';
import 'package:mentalhealthh/models/user_model.dart';
import 'package:mentalhealthh/views/ForumsPage.dart';
import 'package:mentalhealthh/views/UserProfile.dart';
import 'package:mentalhealthh/views/login.dart';
import 'package:provider/provider.dart';
import 'package:mentalhealthh/authentication/auth.dart';

class CommonDrawer extends StatelessWidget {
  final String userId;

  CommonDrawer({required this.userId});

  @override
  Widget build(BuildContext context) {
    UserModel userModel = Provider.of<UserModel>(context); // Access UserModel

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
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(
                          color: Colors.grey, style: BorderStyle.solid),
                      image: userModel.photoUrl.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(userModel.photoUrl),
                              fit: BoxFit.cover,
                            )
                          : const DecorationImage(
                              image: AssetImage(
                                  'assets/images/Memoji Boys 3-15.png'),
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
                            userModel.userName,
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
                            userModel.userEmail,
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
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => ForumsPage(userId: userId)),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.account_circle_outlined),
            title: Text("User Profile"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UserProfile(userId: userId)),
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
                  MaterialPageRoute(builder: (context) => Login()),
                  (route) => false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
