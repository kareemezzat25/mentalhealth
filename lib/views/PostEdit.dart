import 'package:flutter/material.dart';
import 'package:mentalhealthh/services/postsApi.dart';

class PostEdit extends StatefulWidget {
  final int postId;
  final String oldTitle;
  final String oldContent;

  PostEdit({
    required this.postId,
    required this.oldTitle,
    required this.oldContent,
  });

  @override
  _PostEditState createState() => _PostEditState();
}

class _PostEditState extends State<PostEdit> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Initialize text fields with old title and content
    titleController.text = widget.oldTitle;
    contentController.text = widget.oldContent;
  }

  @override
  Widget build(BuildContext context) {
    // Implement UI for editing title and content
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: contentController,
              decoration: InputDecoration(labelText: 'Content'),
              maxLines: null,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                // Implement the logic to update the post on the server
                try {
                  await PostsApi.editPost(
                    widget.postId,
                    titleController.text,
                    contentController.text,
                  );

                  // Pass 'refresh' as the result to indicate that the post is edited
                  Navigator.pop(context, {
                    'title': titleController.text,
                    'content': contentController.text
                  });
                } catch (error) {
                  // Handle errors
                  print('Error editing post: $error');
                }
              },
              child: Text('Done'),
            ),
          ],
        ),
      ),
    );
  }
}
