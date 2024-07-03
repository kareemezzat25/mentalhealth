import 'package:flutter/material.dart';

class ImageUser extends StatelessWidget {
  final String url;

  ImageUser({required this.url});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        radius: 20,
        backgroundColor: Colors.grey,
        backgroundImage: NetworkImage(url),
      );
  }
  
}
