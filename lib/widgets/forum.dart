import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mentalhealthh/api/postsApi.dart';
import 'package:mentalhealthh/models/Icon.dart';
import 'package:mentalhealthh/views/PostComment.dart';
import 'package:mentalhealthh/widgets/Iconpost.dart';
import 'package:http/http.dart' as http;

class Forum extends StatefulWidget {
  // Change to StatefulWidget
  final String? postTitle;
  final String? postContent;
  final String? username;
  final String? postedOn;
  final Function(String)? onDelete;
  final String? postId;
  final String? appUserId;
  final String? userId;

  Forum({
    this.postTitle,
    this.postContent,
    this.username,
    this.postedOn,
    this.onDelete,
    this.postId,
    this.appUserId,
    required this.userId,
  });

  @override
  _ForumState createState() => _ForumState();
}

class _ForumState extends State<Forum> {
  // Create State class
  List<Iconofpost> iconsList = [
    Iconofpost(iconData: Icons.favorite),
    Iconofpost(iconData: Icons.comment),
    Iconofpost(iconData: Icons.share),
  ];

  Future<void> deletePost(String postId) async {
    try {
      final response = await http.delete(
          Uri.parse('https://mentalmediator.somee.com/api/posts/$postId'));

      if (response.statusCode == 200) {
        widget.onDelete?.call(
            postId); // Use widget to access the properties of the parent widget
      } else {
        // Handle other status codes
      }
    } catch (error) {
      // Handle network errors
    }
  }

  @override
  Widget build(BuildContext context) {
    //log('Forum - userId: ${widget.userId}, appUserId: ${widget.appUserId}');
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 10, top: 5, bottom: 5),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Color(0xffEEEEEE),
                  borderRadius: BorderRadius.circular(15)),
              width: screenWidth * 0.9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 2),
                  Container(
                    height: 80,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              border: Border.all(
                                color: Colors.brown,
                                style: BorderStyle.solid,
                              ),
                              image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/Illustration.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.username ?? "",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                widget.postedOn ?? "",
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.postTitle ?? "",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  SizedBox(height: 5),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: Text(
                          widget.postContent ?? "",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (int index = 0; index < iconsList.length; index++)
                          IconPost(
                            iconreaction: iconsList[index],
                          ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PostComment(
                                  postId: int.parse(widget.postId ?? '0'),
                                  userId: widget.userId,
                                ),
                              ),
                            ).then((result) async {
                              // This code will be executed when returning from the second page
                              if (result != null) {
                                // Reload the data or perform any other actions you need
                              }
                            });
                          },
                          child: Icon(
                            Icons.comment,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
