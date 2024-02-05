// PostComment.dart
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mentalhealthh/api/commentsApi.dart';
import 'package:mentalhealthh/api/postsApi.dart';
import 'package:mentalhealthh/authentication/auth.dart';
import 'package:mentalhealthh/models/button.dart';
import 'package:mentalhealthh/views/textForm.dart';

class PostComment extends StatefulWidget {
  final int postId;
  final String? userId;
  final String? appUserId; // Add this line // Make userId nullable

  PostComment({
    required this.postId,
    this.userId, // Make userId nullable
    this.appUserId, // Add this line
  });

  @override
  _PostCommentState createState() => _PostCommentState();
}

class _PostCommentState extends State<PostComment> {
  late Future<Map<String, dynamic>> postDetails;
  Map<String, dynamic> postDetailsData = {}; // Declare postDetailsData
  TextEditingController commentController = TextEditingController();
  Map<int, TextEditingController> replyControllers = {};
  bool isCurrentUserPostAuthor = false;

  @override
  void initState() {
    super.initState();
    postDetails = PostsApi.fetchPostDetails(widget.postId);

    // Fetch the logged-in userId
    Auth.getUserId().then((userId) {
      setState(() {
        // Check if the logged-in user is the author of the post
        isCurrentUserPostAuthor = userId == postDetailsData['appUserId'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    log('PostComment - userId: ${widget.userId}, appUserId: ${postDetailsData['appUserId']}'); // Add this line
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Details and Comments'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: postDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            Map<String, dynamic> postDetailsData = snapshot.data ?? {};
            log('PostComment body  - userId: ${widget.userId}, appUserId: ${postDetailsData['appUserId']}'); // Add this line
            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Post Details',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (widget.userId == postDetailsData['appUserId'])
                        PopupMenuButton<String>(
                          onSelected: (value) async {
                            // Handle menu item selection
                            if (value == 'edit') {
                              // Perform edit action
                            } else if (value == 'delete') {
                              // Perform delete action
                              // Inside your Posts page or wherever you call deletePost
                              await PostsApi.deletePost(
                                context: context,
                                postId: widget.postId,
                                onPostDeleted: () {
                                  // Callback function to reload posts
                                  //reloadPosts();
                                },
                              );
                              // Navigator.of(context).pushReplacement(
                              //   MaterialPageRoute(
                              //     builder: (context) => Posts(),
                              //   ),
                              // );
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'edit',
                              child: ListTile(
                                leading: Icon(Icons.edit),
                                title: Text('Edit'),
                              ),
                            ),
                            const PopupMenuItem<String>(
                              value: 'delete',
                              child: ListTile(
                                leading: Icon(Icons.delete),
                                title: Text('Delete'),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  // Existing code for post details...
                  SizedBox(height: 10),
                  Text(
                    'Title: ${postDetailsData['title']}',
                    style: TextStyle(fontSize: 18),
                  ),

                  SizedBox(height: 10),
                  Text(
                    'Content: ${postDetailsData['content']}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Posted By: ${postDetailsData['username']}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Posted On: ${postDetailsData['postedOn']}',
                    style: TextStyle(fontSize: 18),
                  ),

                  SizedBox(height: 20),
                  TextForm(
                    hintText: 'Add your comment',
                    controller: commentController,
                  ),
                  SizedBox(height: 10),
                  Button(
                    buttonColor: Colors.blue,
                    buttonText: 'Send',
                    textColor: Colors.white,
                    onPressed: () {
                      CommentApi.createComment(
                        widget.postId,
                        commentController.text,
                      );
                      commentController.clear();
                      setState(() {
                        postDetails = PostsApi.fetchPostDetails(widget.postId);
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Comments',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  // Display comments here
                  // You can use another FutureBuilder to fetch and display comments
                  // or use a ListView.builder for efficiency
                  // Example:
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: PostsApi.fetchPostComments(widget.postId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else {
                        List<Map<String, dynamic>> commentsData =
                            snapshot.data ?? [];
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: commentsData.length,
                          itemBuilder: (context, index) {
                            int commentId = commentsData[index]['id'];
                            replyControllers.putIfAbsent(
                              commentId,
                              () => TextEditingController(),
                            );

                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                      'Comment by: ${commentsData[index]['username']}',
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Commented On: ${commentsData[index]['commentedAt']}',
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          'Content: ${commentsData[index]['content']}',
                                        ),
                                      ],
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(Icons.reply),
                                      onPressed: () {
                                        // Handle reply button tap
                                        showReplyTextField(commentId);
                                      },
                                    ),
                                  ),
                                  // Display replies for this comment
                                  FutureBuilder<List<Map<String, dynamic>>>(
                                    future: PostsApi.fetchCommentReplies(
                                      widget.postId,
                                      commentId,
                                    ),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else if (snapshot.hasError) {
                                        return Center(
                                          child:
                                              Text('Error: ${snapshot.error}'),
                                        );
                                      } else {
                                        List<Map<String, dynamic>> repliesData =
                                            snapshot.data ?? [];
                                        return ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: repliesData.length,
                                          itemBuilder: (context, replyIndex) {
                                            return ListTile(
                                              title: Text(
                                                  'Reply by: ${repliesData[replyIndex]['username']}'),
                                              subtitle: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      'Replied On: ${repliesData[replyIndex]['repliedAt']}'),
                                                  SizedBox(height: 5),
                                                  Text(
                                                      'Content: ${repliesData[replyIndex]['content']}'),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  void showReplyTextField(int commentId) {
    TextEditingController replyController = replyControllers[commentId]!;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Reply to Comment'),
          content: TextField(
            controller: replyController,
            decoration: InputDecoration(
              hintText: 'Add your reply...',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                String replyContent = replyController.text;
                if (replyContent.isNotEmpty) {
                  await PostsApi.postCommentReply(
                    widget.postId,
                    commentId,
                    replyContent,
                  );
                  Navigator.of(context).pop();
                  setState(() {
                    // Refresh UI after adding reply
                  });
                }
              },
              child: Text('Send'),
            ),
          ],
        );
      },
    );
  }
}
