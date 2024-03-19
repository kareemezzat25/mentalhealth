import 'package:flutter/material.dart';
import 'package:mentalhealthh/views/createForum.dart';
import 'package:mentalhealthh/widgets/CommonDrawer.dart';
import 'Posts.dart';

class ForumsPage extends StatelessWidget {
  final String userId; // Add userId parameter

  ForumsPage({required this.userId}); // Update constructor

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Mentality',
            style: TextStyle(fontSize: 33, fontWeight: FontWeight.bold),
          ),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Create Forum'),
              Tab(text: 'Posts'),
            ],
          ),
        ),
        // Pass userId to CommonDrawer
        drawer: CommonDrawer(userId: userId),
        body: TabBarView(
          children: [
            createForum(),
            Posts(),
          ],
        ),
      ),
    );
  }
}
