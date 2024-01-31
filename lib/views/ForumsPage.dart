import 'package:flutter/material.dart';
import 'package:mentalhealthh/views/textForm.dart';
import 'package:mentalhealthh/views/createForum.dart';
import 'package:mentalhealthh/widgets/CommonDrawer.dart';
import 'Posts.dart';
import 'PostComment.dart';

class ForumsPage extends StatelessWidget {
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
        drawer: CommonDrawer(),
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
