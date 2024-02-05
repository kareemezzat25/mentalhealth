// CommentEdit.dart
import 'package:flutter/material.dart';
import 'package:mentalhealthh/api/commentsApi.dart';

class CommentEdit extends StatefulWidget {
  final int postId;
  final int commentId;
  final String oldContent;

  CommentEdit({
    required this.postId,
    required this.commentId,
    required this.oldContent,
  });

  @override
  _CommentEditState createState() => _CommentEditState();
}

class _CommentEditState extends State<CommentEdit> {
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
        title: Text('Edit Comment'),
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
                hintText: 'Edit your comment...',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                // Update comment logic
                await CommentApi.updateComment(
                  widget.postId,
                  widget.commentId,
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
