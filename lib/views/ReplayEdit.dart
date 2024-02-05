// ReplyEdit.dart
import 'package:flutter/material.dart';
import 'package:mentalhealthh/api/commentsApi.dart';

class ReplyEdit extends StatefulWidget {
  final int postId;
  final int commentId;
  final int replyId;
  final String oldContent;

  ReplyEdit({
    required this.postId,
    required this.commentId,
    required this.replyId,
    required this.oldContent,
  });

  @override
  _ReplyEditState createState() => _ReplyEditState();
}

class _ReplyEditState extends State<ReplyEdit> {
  TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    contentController.text = widget.oldContent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Reply'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: contentController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintText: 'Edit your reply...',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                // Update reply logic
                await CommentApi.updateReply(
                  widget.postId,
                  widget.commentId,
                  widget.replyId,
                  contentController.text,
                );

                // Return to PostComment.dart with updated data
                Navigator.pop(context, contentController.text);
              },
              child: Text('Done'),
            ),
          ],
        ),
      ),
    );
  }
}
