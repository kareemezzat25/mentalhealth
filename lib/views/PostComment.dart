import 'package:flutter/material.dart';
import 'package:mentalhealthh/api/commentsApi.dart';
import 'package:mentalhealthh/api/postsApi.dart';
import 'package:mentalhealthh/authentication/auth.dart';
import 'package:mentalhealthh/models/button.dart';
import 'package:mentalhealthh/views/CommentEdit.dart';
import 'package:mentalhealthh/views/PostEdit.dart';
import 'package:mentalhealthh/views/ReplayEdit.dart';
import 'package:mentalhealthh/views/textForm.dart';
import 'package:intl/intl.dart'; // Import the intl package for formatting

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

  void changePostData() {
    setState(() {
      postDetails = PostsApi.fetchPostDetails(widget.postId);
    });
  }

  Future<Map<String, dynamic>> fetchCommentDetails(
      int postId, int commentId) async {
    try {
      final Map<String, dynamic> commentDetails =
          await CommentApi.fetchCommentDetails(postId, commentId);
      return commentDetails;
    } catch (error) {
      print('Error fetching comment details: $error');
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
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
            postDetailsData = snapshot.data ?? {};
            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${postDetailsData['username']}',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "  • ",
                            style: TextStyle(fontSize: 22),
                          ),
                          Text(
                            '${calculatePostTimeDifference(postDetailsData['postedOn'])} ago',
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                      if (widget.userId == postDetailsData['appUserId'])
                        PopupMenuButton<String>(
                          onSelected: (value) async {
                            // Handle menu item selection
                            if (value == 'edit') {
                              // Fetch old title and content
                              String oldTitle = postDetailsData['title'];
                              String oldContent = postDetailsData['content'];
                              // Navigate to PostEdit.dart and wait for the result
                              Map<String, dynamic>? result =
                                  await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PostEdit(
                                    postId: widget.postId,
                                    oldTitle: oldTitle,
                                    oldContent: oldContent,
                                  ),
                                ),
                              );
                              if (result != null) {
                                changePostData();
                                // Result is not null, indicating a successful edit
                                // Refresh the UI with the updated post details
                                setState(() {
                                  postDetailsData = snapshot.data ?? {};
                                });
                              }
                              // Perform edit action
                            } else if (value == 'delete') {
                              // Perform delete action
                              // Inside your Posts page or wherever you call deletePost
                              await PostsApi.deletePost(
                                context: context,
                                postId: widget.postId,
                                onPostDeleted: () {},
                              );
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
                  Text(
                    '${postDetailsData['title']}',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${postDetailsData['content']}',
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 10),
                  TextForm(
                    hintText: 'Add your comment',
                    controller: commentController,
                  ),
                  SizedBox(height: 10),
                  Button(
                    buttonColor: Colors.blue,
                    buttonText: 'Send',
                    textColor: Colors.white,
                    onPressed: () async {
                      String commentContent = commentController.text;
                      if (commentContent.isNotEmpty) {
                        CommentApi.createComment(widget.postId, commentContent);
                        commentController.clear();
                        setState(() {
                          postDetails =
                              PostsApi.fetchPostDetails(widget.postId);
                        });
                      }
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
                            return FutureBuilder<Map<String, dynamic>>(
                              future:
                                  fetchCommentDetails(widget.postId, commentId),
                              builder: (context, commentSnapshot) {
                                if (commentSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center();
                                } else if (commentSnapshot.hasError) {
                                  return Center(
                                    child:
                                        Text('Error: ${commentSnapshot.error}'),
                                  );
                                } else {
                                  Map<String, dynamic> commentDetails =
                                      commentSnapshot.data ?? {};
                                  bool isCurrentUserCommentAuthor =
                                      widget.userId ==
                                          commentDetails['appUserId'];

                                  return Card(
                                    margin: EdgeInsets.symmetric(vertical: 8),
                                    child: Column(
                                      children: [
                                        ListTile(
                                          title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    '${commentsData[index]['username']}',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    "• ",
                                                    style:
                                                        TextStyle(fontSize: 22),
                                                  ),
                                                  Text(
                                                    '${calculateCommentTimeDifference(commentsData[index]['commentedAt'])} ago',
                                                    style:
                                                        TextStyle(fontSize: 15),
                                                  ),
                                                ],
                                              ),
                                              if (isCurrentUserCommentAuthor)
                                                PopupMenuButton<String>(
                                                  onSelected: (value) async {
                                                    // Handle menu item selection for comments
                                                    if (value == 'edit') {
                                                      // Navigate to CommentEdit.dart
                                                      String? result =
                                                          await Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              CommentEdit(
                                                            postId:
                                                                widget.postId,
                                                            commentId:
                                                                commentId,
                                                            oldContent:
                                                                commentsData[
                                                                        index]
                                                                    ['content'],
                                                          ),
                                                        ),
                                                      );

                                                      if (result != null) {
                                                        // Refresh UI after returning from CommentEdit.dart
                                                        setState(() {
                                                          postDetails = PostsApi
                                                              .fetchPostDetails(
                                                                  widget
                                                                      .postId);
                                                        });
                                                      }
                                                    } else if (value ==
                                                        'delete') {
                                                      // Perform delete action for comments
                                                      await CommentApi
                                                          .deleteComment(
                                                        widget.postId,
                                                        commentId,
                                                      );
                                                      setState(() {
                                                        // Refresh UI after deleting comment
                                                        commentsData =
                                                            snapshot.data ?? [];
                                                      });
                                                    }
                                                  },
                                                  itemBuilder: (BuildContext
                                                          context) =>
                                                      <PopupMenuEntry<String>>[
                                                    const PopupMenuItem<String>(
                                                      value: 'edit',
                                                      child: ListTile(
                                                        leading:
                                                            Icon(Icons.edit),
                                                        title: Text('Edit'),
                                                      ),
                                                    ),
                                                    const PopupMenuItem<String>(
                                                      value: 'delete',
                                                      child: ListTile(
                                                        leading:
                                                            Icon(Icons.delete),
                                                        title: Text('Delete'),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                            ],
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${commentsData[index]['content']}',
                                                style: TextStyle(fontSize: 19),
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
                                        FutureBuilder<
                                            List<Map<String, dynamic>>>(
                                          future: PostsApi.fetchCommentReplies(
                                            widget.postId,
                                            commentId,
                                          ),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Center();
                                            } else if (snapshot.hasError) {
                                              return Center(
                                                child: Text(
                                                    'Error: ${snapshot.error}'),
                                              );
                                            } else {
                                              List<Map<String, dynamic>>
                                                  repliesData =
                                                  snapshot.data ?? [];
                                              return ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: repliesData.length,
                                                itemBuilder:
                                                    (context, replyIndex) {
                                                  int replyId =
                                                      repliesData[replyIndex]
                                                          ['id'];

                                                  // Check if the logged-in user is the author of the reply
                                                  bool
                                                      isCurrentUserReplayAuthor =
                                                      widget.userId ==
                                                          repliesData[
                                                                  replyIndex]
                                                              ['appUserId'];

                                                  return Card(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            vertical: 8),
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 12.0),
                                                          child: ListTile(
                                                            title: Row(
                                                              children: [
                                                                Text(
                                                                  '${repliesData[replyIndex]['username']}',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                Text(
                                                                  " • ",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          22),
                                                                ),
                                                                Text(
                                                                  '${calculateReplyTimeDifference(repliesData[replyIndex]['repliedAt'])} ago',
                                                                ),
                                                                if (isCurrentUserReplayAuthor)
                                                                  PopupMenuButton<
                                                                      String>(
                                                                    onSelected:
                                                                        (value) async {
                                                                      // Handle menu item selection for replies
                                                                      if (value ==
                                                                          'edit') {
                                                                        // Navigate to ReplayEdit.dart
                                                                        String?
                                                                            result =
                                                                            await Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                ReplyEdit(
                                                                              postId: widget.postId,
                                                                              commentId: commentId,
                                                                              replyId: replyId,
                                                                              oldContent: repliesData[replyIndex]['content'],
                                                                            ),
                                                                          ),
                                                                        );

                                                                        if (result !=
                                                                            null) {
                                                                          // Refresh UI after returning from ReplayEdit.dart
                                                                          setState(
                                                                              () {
                                                                            postDetails =
                                                                                PostsApi.fetchPostDetails(widget.postId);
                                                                          });
                                                                        }
                                                                      } else if (value ==
                                                                          'delete') {
                                                                        // Perform delete action for replies
                                                                        await CommentApi.deleteReply(
                                                                            widget.postId,
                                                                            commentId,
                                                                            replyId);
                                                                        setState(
                                                                            () {
                                                                          // Refresh UI after deleting reply
                                                                          repliesData =
                                                                              snapshot.data ?? [];
                                                                        });
                                                                      }
                                                                    },
                                                                    itemBuilder: (BuildContext
                                                                            context) =>
                                                                        <PopupMenuEntry<
                                                                            String>>[
                                                                      const PopupMenuItem<
                                                                          String>(
                                                                        value:
                                                                            'edit',
                                                                        child:
                                                                            ListTile(
                                                                          leading:
                                                                              Icon(Icons.edit),
                                                                          title:
                                                                              Text('Edit'),
                                                                        ),
                                                                      ),
                                                                      const PopupMenuItem<
                                                                          String>(
                                                                        value:
                                                                            'delete',
                                                                        child:
                                                                            ListTile(
                                                                          leading:
                                                                              Icon(Icons.delete),
                                                                          title:
                                                                              Text('Delete'),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                              ],
                                                            ),
                                                            subtitle: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  '${repliesData[replyIndex]['content']}',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          17),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
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

  // Add this function outside the build method
  String calculateCommentTimeDifference(String commentDateTime) {
    // Parse the commentDateTime string to a DateTime object
    DateTime commentTime = DateTime.parse(commentDateTime);

    // Calculate the time difference
    Duration difference = DateTime.now().difference(commentTime);

    // Determine the appropriate unit (minutes, hours, days, etc.)
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

  // Add this function outside the build method
  String calculateReplyTimeDifference(String replyDateTime) {
    // Parse the replyDateTime string to a DateTime object
    DateTime replyTime = DateTime.parse(replyDateTime);

    // Calculate the time difference
    Duration difference = DateTime.now().difference(replyTime);

    // Determine the appropriate unit (minutes, hours, days, etc.)
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

  // Add this function outside the build method
  String calculatePostTimeDifference(String replyDateTime) {
    // Parse the replyDateTime string to a DateTime object
    DateTime replyTime = DateTime.parse(replyDateTime);

    // Calculate the time difference
    Duration difference = DateTime.now().difference(replyTime);

    // Determine the appropriate unit (minutes, hours, days, etc.)
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

  void showReplyTextField(int commentId) {
    TextEditingController replyController =
        replyControllers[commentId] ?? TextEditingController();
    replyControllers[commentId] =
        replyController; // Ensure the controller is stored in the map

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
