import 'package:flutter/material.dart';
import 'package:mentalhealthh/models/Icon.dart';

class IconPost extends StatefulWidget {
  final Iconofpost iconreaction;

  IconPost({required this.iconreaction});

  @override
  State<IconPost> createState() => _IconPostState();
}

class _IconPostState extends State<IconPost> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              widget.iconreaction.incrementrecation();
            });
          },
          icon: Icon(widget.iconreaction.iconData, size: 25, color: Colors.grey),
        ),
        SizedBox(width: 2),
        Text("${widget.iconreaction.numberrecations}"),
      ],
    );
  }
}








