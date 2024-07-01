import 'package:flutter/material.dart';
import 'package:mentalhealthh/DoctorWidgets/DrCommonDrawer.dart';
import 'package:mentalhealthh/views/CreateForum.dart';
import 'package:mentalhealthh/views/Posts.dart';

class DoctorMainPage extends StatefulWidget {
  final String doctorId;

  DoctorMainPage({required this.doctorId});

  @override
  State<DoctorMainPage> createState() => _DoctorMainPageState();
}

class _DoctorMainPageState extends State<DoctorMainPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool confessionsOnly = false;

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

  void toggleConfessionsOnly(bool value) {
    setState(() {
      confessionsOnly = value;
    });
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
          actions: [
            Row(
              children: [
                Text('Confessions only'),
                Switch(
                  value: confessionsOnly,
                  onChanged: (value) {
                    toggleConfessionsOnly(value);
                  },
                ),
              ],
            ),
          ],
        ),
        drawer: DrCommonDrawer(doctorId: widget.doctorId),
        body: TabBarView(
          controller: _tabController,
          children: [
            Posts(
              key: ValueKey(confessionsOnly), // Add a ValueKey
              userId: widget.doctorId,
              showUserPosts: false,
              confessionsOnly: confessionsOnly,
            ),
            createForum(
              tabController: _tabController,
            ),
          ],
        ),
      ),
    );
  }
}
