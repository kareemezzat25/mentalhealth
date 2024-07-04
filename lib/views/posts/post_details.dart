import 'package:flutter/material.dart';
import 'package:mentalhealthh/views/posts/calculateTimeDifference.dart';
import 'package:mentalhealthh/views/posts/PostEdit.dart';
import 'package:mentalhealthh/services/postsApi.dart';

class PostDetails extends StatefulWidget {
  Map<String, dynamic> postDetailsData;
  final dynamic widget;

  PostDetails({
    Key? key,
    required this.postDetailsData,
    required this.widget,
  }) : super(key: key);

  @override
  State<PostDetails> createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [
          SizedBox(height: 15),
          Container(
            decoration: BoxDecoration(
              color: Color(0xffFFFFFF),
              borderRadius: BorderRadius.circular(15),
            ),
            width: screenWidth * 0.9,
            child: Padding(
              padding: const EdgeInsets.all(10),
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
                              color: Colors.grey, style: BorderStyle.solid),
                          image: DecorationImage(
                            image: widget.postDetailsData['isAnonymous'] ==
                                        true ||
                                    widget.postDetailsData['photoUrl'] == null
                                ? AssetImage('assets/images/anonymous.png')
                                : NetworkImage(
                                        widget.postDetailsData['photoUrl'])
                                    as ImageProvider,
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
                            '${widget.postDetailsData['username'] ?? 'Anonymous'}',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${CalculateTimeDifference().calculateTimeDifference(widget.postDetailsData['postedOn'])} ',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      if (widget.widget.userId ==
                          widget.postDetailsData['appUserId'])
                        PopupMenuButton<String>(
                          onSelected: (value) async {
                            if (value == 'edit') {
                              String oldTitle = widget.postDetailsData['title'];
                              String oldContent =
                                  widget.postDetailsData['content'];
                              Map<String, dynamic>? result =
                                  await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PostEdit(
                                    postId: widget.widget.postId,
                                    oldTitle: oldTitle,
                                    oldContent: oldContent,
                                  ),
                                ),
                              );
                              if (result != null) {
                                widget.widget.changePostData();
                                setState(() {
                                  widget.postDetailsData = result;
                                });
                              }
                            } else if (value == 'delete') {
                              await PostsApi.deletePost(
                                context: context,
                                postId: widget.widget.postId,
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
                    '${widget.postDetailsData['title']}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 15),
                  Text(
                    '${widget.postDetailsData['content']}',
                    style: TextStyle(fontSize: 18),
                  ),
                  if (widget.postDetailsData['postPhotoUrl'] != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child:
                          Image.network(widget.postDetailsData['postPhotoUrl']),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
