import 'package:flutter/material.dart';
import 'package:mentalhealthh/models/Icon.dart';
import 'package:mentalhealthh/views/PostComment.dart';
import 'package:mentalhealthh/widgets/Iconpost.dart';
import 'package:mentalhealthh/widgets/userdata.dart';

class Forum extends StatefulWidget {
  final String? postTitle;
  final String? postContent;
  final String? username;
  final String? postedOn;
  final Function(String)? onDelete;
  final String? postId;
  final String? appUserId;
  final String? userId;
  final bool? isAnonymous;

  Forum({
    this.postTitle,
    this.postContent,
    this.username,
    this.postedOn,
    this.onDelete,
    this.postId,
    this.appUserId,
    required this.userId,
    this.isAnonymous
  });

  @override
  _ForumState createState() => _ForumState();
}

class _ForumState extends State<Forum> {
  List<Iconofpost> iconsList = [
    Iconofpost(iconData: Icons.favorite),
    Iconofpost(iconData: Icons.comment_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xffDCDCDC),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 10, top: 5, bottom: 5),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Color(0xffFFFFFF),
                    borderRadius: BorderRadius.circular(15)),
                width: screenWidth * 0.9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 2),
                    
                    UserInfo(username: widget.username, postedOn: widget.postedOn,isAnonymous: widget.isAnonymous,),
                    SizedBox(height: 3),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.postTitle ?? "",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            height: 1.0),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 2),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 80,
                        child: Text(
                          widget.postContent ?? "",
                          style: TextStyle(fontSize: 18, height: 1.0),
                          maxLines: 4, // Adjust as needed
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (int index = 0; index < iconsList.length; index++)
                            IconPost(
                              iconreaction: iconsList[index],
                            ),  
                        ],
                      ),
                    ),
                    SizedBox(height: 10), // Additional space at the bottom
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
