import 'package:flutter/material.dart';
import 'package:mentalhealthh/views/Formview.dart';
import 'package:mentalhealthh/views/createForum.dart';
import 'package:mentalhealthh/widgets/CommonDrawer.dart';
import 'Posts.dart';
import 'PostComment.dart';

class ForumsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
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
              Tab(text: 'Post Comment'),
            ],
          ),
        ),
        drawer: CommonDrawer(),
        body: TabBarView(
          children: [
            createForum(),
            Posts(),
            PostComment(),
          ],
        ),
      ),
    );
  }
}
