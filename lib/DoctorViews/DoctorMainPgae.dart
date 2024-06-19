import 'package:flutter/material.dart';
import 'package:mentalhealthh/DoctorWidgets/DrCommonDrawer.dart';

class DoctorMainPage extends StatefulWidget {
  final String DoctorId; // Add userId parameter

  DoctorMainPage({required this.DoctorId});
  @override
  State<DoctorMainPage> createState() => _DoctorMainPageState();
}

class _DoctorMainPageState extends State<DoctorMainPage> {
  // Update constructor
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: DrCommonDrawer(doctorId: widget.DoctorId),
    );
  }
}
