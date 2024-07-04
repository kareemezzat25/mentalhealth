import 'package:flutter/material.dart';
import 'package:mentalhealthh/services/commentsApi.dart';
import 'package:mentalhealthh/services/postsApi.dart';
import 'package:mentalhealthh/views/posts/CommentEdit.dart';
import 'package:mentalhealthh/views/posts/ReplayEdit.dart';
import 'package:mentalhealthh/views/posts/calculateTimeDifference.dart';
import 'package:mentalhealthh/widgets/ForbidenDialog.dart';
import 'package:mentalhealthh/widgets/image_user.dart';

class CommentSection extends StatefulWidget {
  final int postId;
  final String? userId;
  final String? appUserId;
  final Map<String, dynamic> postDetailsData;
  final TextEditingController commentController;
  final Map<int, TextEditingController> replyControllers;
  final VoidCallback changePostData;

  CommentSection({
    required this.postId,
    required this.userId,
    required this.appUserId,
    required this.postDetailsData,
    required this.commentController,
    required this.replyControllers,
    required this.changePostData,
  });

  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  late TextEditingController commentController;
  late Map<int, TextEditingController> replyControllers;

  @override
  void initState() {
    super.initState();
    commentController = TextEditingController();
    replyControllers = {};
  }

  @override
  void dispose() {
    commentController.dispose();
    replyControllers.forEach((key, controller) {
      controller.dispose();
    });
    super.dispose();
  }

  void changePostData() {
    setState(() {
      // Update post details or refresh UI after any comment/reply operation
    });
  }

  void showReplyTextField(int commentId) {
    TextEditingController replyController =
        replyControllers[commentId] ?? TextEditingController();
    replyControllers[commentId] = replyController;

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
                  final response = await CommentApi.postCommentReply(
                    widget.postId,
                    commentId,
                    replyContent,
                  );
                  if (response['title'] == 'Forbidden') {
                    await showForbiddenDialog(context);
                  } else {
                    Navigator.of(context).pop();
                    changePostData();
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

  Future<Map<String, dynamic>> fetchCommentDetails(
      int postId, int commentId) async {
    // Implement your logic to fetch comment details using the appropriate API or service
    try {
      return await CommentApi.fetchCommentDetails(postId, commentId);
    } catch (e) {
      throw e; // Handle error appropriately
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 60,
          child: Row(
            children: [
              Flexible(
                child: TextField(
                  controller: commentController,
                  decoration: InputDecoration(
                    hintText: 'Add your comment',
                  ),
                ),
              ),
              SizedBox(width: 5),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xff0098FA),
                  onPrimary: Colors.white,
                  minimumSize: Size(120, 50),
                ),
                onPressed: () async {
                  String commentContent = commentController.text;
                  if (commentContent.isNotEmpty) {
                    final response = await CommentApi.createComment(
                      widget.postId,
                      commentContent,
                    );
                    if (response['title'] == 'Forbidden') {
                      await showForbiddenDialog(context);
                    } else {
                      commentController.clear();
                      changePostData();
                    }
                  }
                },
                child: Text('Send'),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        FutureBuilder<List<Map<String, dynamic>>>(
          future: PostsApi.fetchPostComments(widget.postId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              List<Map<String, dynamic>> commentsData = snapshot.data ?? [];
              return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: commentsData.length,
                itemBuilder: (context, index) {
                  int commentId = commentsData[index]['id'];
                  return FutureBuilder<Map<String, dynamic>>(
                    future: fetchCommentDetails(widget.postId, commentId),
                    builder: (context, commentSnapshot) {
                      if (commentSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center();
                      } else if (commentSnapshot.hasError) {
                        return Center(
                          child: Text('Error: ${commentSnapshot.error}'),
                        );
                      } else {
                        Map<String, dynamic> commentDetails =
                            commentSnapshot.data ?? {};
                        bool isCurrentUserCommentAuthor =
                            widget.userId == commentDetails['appUserId'];

                        return Card(
                          color: Color(0xffFFFFFF),
                          margin: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  title: Row(
                                    children: [
                                      ImageUser(
                                          url: commentsData[index]['photoUrl']),
                                      SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${commentsData[index]['username']}',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            '${CalculateTimeDifference().calculateTimeDifference(commentsData[index]['commentedAt'])} ',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                      if (isCurrentUserCommentAuthor)
                                        PopupMenuButton<String>(
                                          onSelected: (value) async {
                                            if (value == 'edit') {
                                              String? result =
                                                  await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      CommentEdit(
                                                    postId: widget.postId,
                                                    commentId: commentId,
                                                    oldContent:
                                                        commentsData[index]
                                                            ['content'],
                                                  ),
                                                ),
                                              );

                                              if (result != null) {
                                                changePostData();
                                              }
                                            } else if (value == 'delete') {
                                              await CommentApi.deleteComment(
                                                widget.postId,
                                                commentId,
                                              );
                                              changePostData();
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
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${commentsData[index]['content']}',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(Icons.reply),
                                    onPressed: () {
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
                                      return Center();
                                    } else if (snapshot.hasError) {
                                      return Center(
                                        child: Text('Error: ${snapshot.error}'),
                                      );
                                    } else {
                                      List<Map<String, dynamic>> repliesData =
                                          snapshot.data ?? [];
                                      return ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: repliesData.length,
                                        itemBuilder: (context, replyIndex) {
                                          int replyId =
                                              repliesData[replyIndex]['id'];

                                          // Check if the logged-in user is the author of the reply
                                          bool isCurrentUserReplayAuthor =
                                              widget.userId ==
                                                  repliesData[replyIndex]
                                                      ['appUserId'];

                                          return Padding(
                                            padding: const EdgeInsets.only(
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
                                                        '${repliesData[replyIndex]['username']}',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        '${CalculateTimeDifference().calculateTimeDifference(repliesData[replyIndex]['repliedAt'])} ',
                                                        style: TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                    ],
                                                  ),
                                                  if (isCurrentUserReplayAuthor)
                                                    PopupMenuButton<String>(
                                                      onSelected:
                                                          (value) async {
                                                        // Handle menu item selection for replies
                                                        if (value == 'edit') {
                                                          String? result =
                                                              await Navigator
                                                                  .push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      ReplyEdit(
                                                                postId: widget
                                                                    .postId,
                                                                commentId:
                                                                    commentId,
                                                                replyId:
                                                                    replyId,
                                                                oldContent:
                                                                    repliesData[
                                                                            replyIndex]
                                                                        [
                                                                        'content'],
                                                              ),
                                                            ),
                                                          );

                                                          if (result != null) {
                                                            changePostData();
                                                          }
                                                        } else if (value ==
                                                            'delete') {
                                                          await CommentApi
                                                              .deleteReply(
                                                            widget.postId,
                                                            commentId,
                                                            replyId,
                                                          );
                                                          changePostData();
                                                        }
                                                      },
                                                      itemBuilder: (BuildContext
                                                              context) =>
                                                          <PopupMenuEntry<
                                                              String>>[
                                                        const PopupMenuItem<
                                                            String>(
                                                          value: 'edit',
                                                          child: ListTile(
                                                            leading: Icon(
                                                                Icons.edit),
                                                            title: Text('Edit'),
                                                          ),
                                                        ),
                                                        const PopupMenuItem<
                                                            String>(
                                                          value: 'delete',
                                                          child: ListTile(
                                                            leading: Icon(
                                                                Icons.delete),
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
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${repliesData[replyIndex]['content']}',
                                                    style:
                                                        TextStyle(fontSize: 17),
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
    );
  }
}
