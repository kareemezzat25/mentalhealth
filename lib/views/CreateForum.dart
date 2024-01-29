import 'package:flutter/material.dart';
import 'package:mentalhealthh/widgets/forum.dart';

class CreateForum extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          height: 550, // Set a finite height here
          child: Forum(),
        );
      },
    );
  }
}
