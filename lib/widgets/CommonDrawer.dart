// CommonDrawer.dart

import 'package:flutter/material.dart';
import 'package:mentalhealthh/authentication/auth.dart';
import 'package:mentalhealthh/views/ForumsPage.dart';

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
              padding: const EdgeInsets.symmetric(vertical:20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(color: Colors.grey, style: BorderStyle.solid),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/Illustration.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),SizedBox(width: 10),
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
                      SizedBox(height: 2,),
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
                      ]),
            ),
          ),
          const ListTile(
            leading: Icon(Icons.home_outlined),
            title: Text("Home"),
          ),
          const ListTile(
            leading: Icon(Icons.edit_outlined),
            title: Text("Depression Test"),
          ),
          ListTile(
            leading: const Icon(Icons.bookmark_outline_outlined),
            title: Text("Forums"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ForumsPage()),
              );
            },
          ),
          const ListTile(
            leading: Icon(Icons.dark_mode_outlined),
            title: Text("Night mode"),
          ),
        ],
      ),
    );
  }
}
