import 'package:flutter/material.dart';

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
  final String? photoUrl; // Add the photoUrl parameter
  final int? commentsCount;
  final String? postPhotoUrl;

  Forum({
    this.postTitle,
    this.postContent,
    this.username,
    this.postedOn,
    this.onDelete,
    this.postId,
    this.appUserId,
    required this.userId,
    this.isAnonymous,
    this.photoUrl,
    this.postPhotoUrl,
    this.commentsCount, // Initialize the photoUrl parameter
  });

  @override
  _ForumState createState() => _ForumState();
}

class _ForumState extends State<Forum> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 5),
            UserInfo(
              username: widget.username,
              postedOn: widget.postedOn,
              isAnonymous: widget.isAnonymous,
              photoUrl: widget.photoUrl,
            ), // Pass the photoUrl to the UserInfo widget
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
            if (widget.postPhotoUrl != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(widget.postPhotoUrl!),
              ),
            SizedBox(height: 5),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.comment_outlined),
                    SizedBox(width: 5),
                    Text(widget.commentsCount?.toString() ?? '0'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10), // Additional space at the bottom
          ],
        ),
      ),
    );
  }
}
