import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mentalhealthh/services/postsApi.dart';
import 'package:mentalhealthh/widgets/ForbidenDialog.dart';
import 'dart:io';

class PostEdit extends StatefulWidget {
  final int postId;
  final String oldTitle;
  final String oldContent;
  final String? oldImageUrl;
  final bool isAnonymous;

  PostEdit({
    required this.postId,
    required this.oldTitle,
    required this.oldContent,
    this.oldImageUrl,
    required this.isAnonymous,
  });

  @override
  _PostEditState createState() => _PostEditState();
}

class _PostEditState extends State<PostEdit> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  File? _image;
  bool _isAnonymous = false;

  @override
  void initState() {
    super.initState();

    // Initialize text fields with old title and content
    titleController.text = widget.oldTitle;
    contentController.text = widget.oldContent;
    _isAnonymous = widget.isAnonymous;
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Post'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: contentController,
              decoration: InputDecoration(
                labelText: 'Content',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              maxLines: 4, // Allow multiple lines for content
            ),
            SizedBox(height: 16),
            if (_image != null)
              Image.file(_image!)
            else if (widget.oldImageUrl != null)
              Image.network(widget.oldImageUrl!),
            SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color(0xff01579B),
                onPrimary: Colors.white,
              ),
              onPressed: _pickImage,
              child: Text('Change Image'),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Post as Anonymous'),
                Switch(
                  value: _isAnonymous,
                  onChanged: (value) {
                    setState(() {
                      _isAnonymous = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color(0xff01579B),
                onPrimary: Colors.white,
              ),
              onPressed: () async {
                try {
                  final response = await PostsApi.editPost(
                    widget.postId,
                    titleController.text,
                    contentController.text,
                    image: _image,
                    isAnonymous: _isAnonymous,
                  );
                  if (response['title'] == 'Forbidden') {
                    await showForbiddenDialog(context);
                  } else {
                    // Pass 'refresh' as the result to indicate that the post is edited
                    Navigator.pop(context, {
                      'title': titleController.text,
                      'content': contentController.text,
                      'imageUrl': response['imageUrl'],
                      'isAnonymous': _isAnonymous,
                    });
                  }
                } catch (error) {
                  // Handle errors
                  print('Error editing post: $error');
                }
              },
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
