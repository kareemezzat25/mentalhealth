// CommonDrawer.dart

import 'package:flutter/material.dart';
import 'package:mentalhealthh/views/ForumsPage.dart';

class CommonDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 180,
      child: ListView(
        children: [
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
