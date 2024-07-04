import 'package:flutter/material.dart';
import 'package:mentalhealthh/views/posts/CreateForum.dart';
import 'package:mentalhealthh/views/posts/Posts.dart';
import 'package:mentalhealthh/widgets/CommonDrawer.dart';

class Forumsview extends StatefulWidget {
  final String userId; // Add userId parameter

  Forumsview({required this.userId}); // Update constructor

  @override
  _ForumsPageState createState() => _ForumsPageState();
}

class _ForumsPageState extends State<Forumsview>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Nexus',
            style: TextStyle(fontSize: 33, fontWeight: FontWeight.bold),
          ),
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'Posts'),
              Tab(text: 'Create Forum'),
            ],
          ),
        ),
        // Pass userId to CommonDrawer
        drawer: CommonDrawer(userId: widget.userId),
        body: TabBarView(
          controller: _tabController,
          children: [
            Posts(userId: widget.userId, showUserPosts: false),
            createForum(
              tabController: _tabController,
            ),
          ],
        ),
      ),
    );
  }
}


