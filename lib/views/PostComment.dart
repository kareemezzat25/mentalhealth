import 'package:flutter/material.dart';
import 'package:mentalhealthh/services/commentsApi.dart';
import 'package:mentalhealthh/services/postsApi.dart';
import 'package:mentalhealthh/authentication/auth.dart';
import 'package:mentalhealthh/models/button.dart';
import 'package:mentalhealthh/views/CommentEdit.dart';
import 'package:mentalhealthh/views/PostEdit.dart';
import 'package:mentalhealthh/views/ReplayEdit.dart';
import 'package:mentalhealthh/views/textForm.dart';
import 'package:intl/intl.dart';
import 'package:mentalhealthh/widgets/ForbidenDialog.dart';
import 'package:mentalhealthh/widgets/image_user.dart'; // Import the intl package for formatting

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
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xffDCDCDC),
      appBar: AppBar(
        title: Text('Post and Comments'),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<Map<String, dynamic>>(
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
              return Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 15),
                      Container(
                        decoration: BoxDecoration(
                            color: Color(0xffFFFFFF),
                            borderRadius: BorderRadius.circular(15)),
                        width: screenWidth * 0.9,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 10, bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40),
                                      border: Border.all(
                                          color: Colors.grey,
                                          style: BorderStyle.solid),
                                      image: DecorationImage(
                                        image: postDetailsData['isAnonymous'] ==
                                                    true ||
                                                postDetailsData['photoUrl'] ==
                                                    null
                                            ? AssetImage(
                                                'assets/images/anonymous.png')
                                            : NetworkImage(
                                                    postDetailsData['photoUrl'])
                                                as ImageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${postDetailsData['username'] ?? 'Anonymous'}',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '${calculateTimeDifference(postDetailsData['postedOn'])} ',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  if (widget.userId ==
                                      postDetailsData['appUserId'])
                                    PopupMenuButton<String>(
                                      onSelected: (value) async {
                                        // Handle menu item selection
                                        if (value == 'edit') {
                                          // Fetch old title and content
                                          String oldTitle =
                                              postDetailsData['title'];
                                          String oldContent =
                                              postDetailsData['content'];
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
                                              postDetailsData =
                                                  snapshot.data ?? {};
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
                              SizedBox(height: 10),
                              Text(
                                '${postDetailsData['title']}',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 15),
                              Text(
                                '${postDetailsData['content']}',
                                style: TextStyle(fontSize: 18),
                              ),
                              if (postDetailsData['postPhotoUrl'] !=
                                  null) // Display image if imageUrl is available
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: Image.network(
                                      postDetailsData['postPhotoUrl']),
                                ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Row(
                            children: [
                              Text(
                                'Comments',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                '${postDetailsData['commentsCount']}',
                                style: TextStyle(fontSize: 22),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 60,
                        child: Row(
                          children: [
                            Flexible(
                              child: TextForm(
                                hintText: 'Add your comment',
                                controller: commentController,
                              ),
                            ),
                            SizedBox(width: 5),
                            Button(
                              buttonColor: Color(0xff0098FA),
                              buttonText: 'Send',
                              textColor: Colors.white,
                              widthButton: 120,
                              heightButton: 50,
                              onPressed: () async {
                                String commentContent = commentController.text;
                                if (commentContent.isNotEmpty) {
                                  final response =
                                      await CommentApi.createComment(
                                          widget.postId, commentContent);
                                  if (response['title'] == 'Forbidden') {
                                    await showForbiddenDialog(context);
                                  } else {
                                    commentController.clear();
                                    setState(() {
                                      // Update postDetails to refresh comments
                                    });
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      FutureBuilder<List<Map<String, dynamic>>>(
                        future: PostsApi.fetchPostComments(widget.postId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
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
                              physics:
                                  NeverScrollableScrollPhysics(), // Make the ListView unscrollable
                              shrinkWrap: true,
                              itemCount: commentsData.length,
                              itemBuilder: (context, index) {
                                int commentId = commentsData[index]['id'];
                                return FutureBuilder<Map<String, dynamic>>(
                                  future: fetchCommentDetails(
                                      widget.postId, commentId),
                                  builder: (context, commentSnapshot) {
                                    if (commentSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center();
                                    } else if (commentSnapshot.hasError) {
                                      return Center(
                                        child: Text(
                                            'Error: ${commentSnapshot.error}'),
                                      );
                                    } else {
                                      Map<String, dynamic> commentDetails =
                                          commentSnapshot.data ?? {};
                                      bool isCurrentUserCommentAuthor =
                                          widget.userId ==
                                              commentDetails['appUserId'];

                                      return Card(
                                        color: Color(0xffFFFFFF),
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        child: Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ListTile(
                                                title: Row(
                                                  children: [
                                                    ImageUser(
                                                        url: commentsData[index]
                                                            ['photoUrl']),
                                                    SizedBox(width: 10),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          '${commentsData[index]['username']}',
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(
                                                          '${calculateTimeDifference(commentsData[index]['commentedAt'])} ',
                                                          style: TextStyle(
                                                              fontSize: 12),
                                                        ),
                                                      ],
                                                    ),
                                                    if (isCurrentUserCommentAuthor)
                                                      PopupMenuButton<String>(
                                                        onSelected:
                                                            (value) async {
                                                          // Handle menu item selection for comments
                                                          if (value == 'edit') {
                                                            // Navigate to CommentEdit.dart
                                                            String? result =
                                                                await Navigator
                                                                    .push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        CommentEdit(
                                                                  postId: widget
                                                                      .postId,
                                                                  commentId:
                                                                      commentId,
                                                                  oldContent: commentsData[
                                                                          index]
                                                                      [
                                                                      'content'],
                                                                ),
                                                              ),
                                                            );

                                                            if (result !=
                                                                null) {
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
                                                                  snapshot.data ??
                                                                      [];
                                                            });
                                                          }
                                                        },
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context) =>
                                                                <PopupMenuEntry<
                                                                    String>>[
                                                          const PopupMenuItem<
                                                              String>(
                                                            value: 'edit',
                                                            child: ListTile(
                                                              leading: Icon(
                                                                  Icons.edit),
                                                              title:
                                                                  Text('Edit'),
                                                            ),
                                                          ),
                                                          const PopupMenuItem<
                                                              String>(
                                                            value: 'delete',
                                                            child: ListTile(
                                                              leading: Icon(
                                                                  Icons.delete),
                                                              title: Text(
                                                                  'Delete'),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                  ],
                                                ),
                                                subtitle: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '${commentsData[index]['content']}',
                                                        style: TextStyle(
                                                            fontSize: 18),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                trailing: IconButton(
                                                  icon: Icon(Icons.reply),
                                                  onPressed: () {
                                                    // Handle reply button tap
                                                    showReplyTextField(
                                                        commentId);
                                                  },
                                                ),
                                              ),
                                              // Display replies for this comment
                                              FutureBuilder<
                                                  List<Map<String, dynamic>>>(
                                                future: PostsApi
                                                    .fetchCommentReplies(
                                                  widget.postId,
                                                  commentId,
                                                ),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return Center();
                                                  } else if (snapshot
                                                      .hasError) {
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
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      itemCount:
                                                          repliesData.length,
                                                      itemBuilder: (context,
                                                          replyIndex) {
                                                        int replyId =
                                                            repliesData[
                                                                    replyIndex]
                                                                ['id'];

                                                        // Check if the logged-in user is the author of the reply
                                                        bool
                                                            isCurrentUserReplayAuthor =
                                                            widget.userId ==
                                                                repliesData[
                                                                        replyIndex]
                                                                    [
                                                                    'appUserId'];

                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 10,
                                                                  bottom: 10,
                                                                  left: 30,
                                                                  right: 10),
                                                          child: ListTile(
                                                            title: Row(
                                                              children: [
                                                                ImageUser(
                                                                    url: repliesData[
                                                                            replyIndex]
                                                                        [
                                                                        'photoUrl']),
                                                                SizedBox(
                                                                    width: 10),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      '${repliesData[replyIndex]['username']}',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    Text(
                                                                      '${calculateTimeDifference(repliesData[replyIndex]['repliedAt'])} ',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12),
                                                                    ),
                                                                  ],
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
                                                        );
                                                      },
                                                    );
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
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
                ),
              );
            }
          },
        ),
      ),
    );
  }

  // Add this function outside the build method
  String calculateTimeDifference(String postDateTime) {
    DateTime postTime = DateTime.parse(postDateTime);

    // Consider UTC+2 time zone offset (2 hours)
    DateTime adjustedPostTime = postTime.add(Duration(hours: 3));

    Duration difference = DateTime.now().difference(adjustedPostTime);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} ${(difference.inDays / 365).floor() == 1 ? 'year ago' : 'years ago'}';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} ${(difference.inDays / 30).floor() == 1 ? 'month ago' : 'months ago'}';
    } else if (difference.inDays > 7) {
      return '${(difference.inDays / 7).floor()} ${(difference.inDays / 7).floor() == 1 ? 'week ago' : 'weeks ago'}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day ago' : 'days ago'}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour ago' : 'hours ago'}';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute ago' : 'minutes ago'}';
    } else
      return 'now';
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
                  await CommentApi.postCommentReply(
                    widget.postId,
                    commentId,
                    replyContent,
                  );

                  if (replyContent.isNotEmpty) {
                    final response = await CommentApi.postCommentReply(
                      widget.postId,
                      commentId,
                      replyContent,
                    );
                    if (response['title'] == 'Forbidden') {
                      await showForbiddenDialog(context);
                    } else {
                      Navigator.of(context).pop();
                      setState(() {
                        // Refresh UI after adding reply
                      });
                    }
                  }
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
