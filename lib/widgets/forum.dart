import 'package:flutter/material.dart';
import 'package:mentalhealthh/models/Icon.dart';
import 'package:mentalhealthh/views/PostComment.dart';
import 'package:mentalhealthh/widgets/Iconpost.dart';

class Forum extends StatefulWidget {
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
  List<Iconofpost> iconsList = [
    Iconofpost(iconData: Icons.favorite),
    Iconofpost(iconData: Icons.comment),
    Iconofpost(iconData: Icons.share),
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
                                  color: Colors.grey,
                                  style: BorderStyle.solid,
                                ),
                                image: DecorationImage(
                                  image: AssetImage(
                                    'assets/images/Illustration.png',
                                  ),
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
                                  calculateTimeDifference(
                                      widget.postedOn ?? ""),
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                    ),
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

  String calculateTimeDifference(String postDateTime) {
    DateTime postTime = DateTime.parse(postDateTime);
    Duration difference = DateTime.now().difference(postTime);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} ${(difference.inDays / 365).floor() == 1 ? 'year' : 'years'}';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} ${(difference.inDays / 30).floor() == 1 ? 'month' : 'months'}';
    } else if (difference.inDays > 7) {
      return '${(difference.inDays / 7).floor()} ${(difference.inDays / 7).floor() == 1 ? 'week' : 'weeks'}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'}';
    } else {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'}';
    }
  }
}
