import 'package:flutter/material.dart';
import 'package:mentalhealthh/services/postsApi.dart';
import 'package:mentalhealthh/authentication/auth.dart';
import 'package:mentalhealthh/views/posts/post_details.dart';
import 'package:mentalhealthh/views/posts/comment_section.dart';

class PostComment extends StatefulWidget {
  final int postId;
  final String? userId;
  final String? appUserId;

  PostComment({
    required this.postId,
    this.userId,
    this.appUserId,
  });

  @override
  _PostCommentState createState() => _PostCommentState();
}

class _PostCommentState extends State<PostComment> {
  late Future<Map<String, dynamic>> postDetails;
  Map<String, dynamic> postDetailsData = {};
  TextEditingController commentController = TextEditingController();
  Map<int, TextEditingController> replyControllers = {};
  bool isCurrentUserPostAuthor = false;

  @override
  void initState() {
    super.initState();
    postDetails = PostsApi.fetchPostDetails(widget.postId);

    Auth.getUserId().then((userId) {
      setState(() {
        isCurrentUserPostAuthor =
            userId == postDetailsData['appUserId'].toString();
      });
    });
  }

  void changePostData() {
    setState(() {
      postDetails = PostsApi.fetchPostDetails(widget.postId);
    });
  }

  Future<bool> _onWillPop() async {
    Navigator.pop(context, "refresh");
    return false; // Return false to prevent the default pop behavior
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text('Post and Comments'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, "refresh");
            }
          )
        ),
        body: SingleChildScrollView(
          child: FutureBuilder<Map<String, dynamic>>(
            future: postDetails,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                postDetailsData = snapshot.data ?? {};
                return Column(
                  children: [
                    PostDetails(
                      postDetailsData: postDetailsData,
                      widget: widget,
                      changePostData: changePostData,
                    ),
                    CommentSection(
                      postId: widget.postId,
                      userId: widget.userId,
                      appUserId: widget.appUserId,
                      postDetailsData: postDetailsData,
                      commentController: commentController,
                      replyControllers: replyControllers,
                      changePostData: changePostData,
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
