import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mentalhealthh/services/postsApi.dart';
import 'package:mentalhealthh/authentication/auth.dart';
import 'package:mentalhealthh/models/button.dart';
import 'package:mentalhealthh/views/Posts.dart';
import 'package:mentalhealthh/views/textForm.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class createForum extends StatefulWidget {
  final TabController tabController;

  createForum({required this.tabController});

  @override
  _createForumState createState() => _createForumState();
}

class _createForumState extends State<createForum> {
  TextEditingController TitleController = TextEditingController();
  TextEditingController TagsController = TextEditingController();
  TextEditingController DescriptionController = TextEditingController();
  bool isAnonymous = false;
  File? _imageFile; // Add a variable to hold the selected image file

  String titleError = '';
  String descriptionError = '';

  // Function to handle image picking
  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Function to handle image uploading
  Future<String?> uploadImage(File imageFile) async {
    String? token = await Auth.getToken();
    if (token == null) return null;

    final request =
        http.MultipartRequest('POST', Uri.parse('https://your-upload-url'));
    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(await http.MultipartFile.fromPath('file', imageFile.path,
        filename: path.basename(imageFile.path)));

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseBody);
      return jsonResponse['url']; // Return the image URL
    } else {
      print('Image upload failed with status: ${response.statusCode}');
      return null;
    }
  }

  void validateInputs() {
    setState(() {
      titleError = TitleController.text.isEmpty ? '* Title is required' : '';
      descriptionError =
          DescriptionController.text.isEmpty ? '* Description is required' : '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return exit(0);
        }));
        return false;
      },
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(right: 15, left: 15, top: 15),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: 10),
                Text(
                  "Forums Details",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Enter all the required data to be accurate",
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
                SizedBox(height: 20),
                if (titleError.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Text(
                      titleError,
                      style: TextStyle(color: Colors.red, fontSize: 18),
                    ),
                  ),
                const Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Row(
                    children: [
                      Text(
                        "Title",
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                TextForm(
                  hintText: "Enter Forum Title",
                  controller: TitleController,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Row(
                    children: [
                      Text(
                        "Tags",
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                TextForm(
                  hintText: "Tag1,Tag2.etc.",
                  controller: TagsController,
                ),
                SizedBox(height: 15),
                if (descriptionError.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Text(
                      descriptionError,
                      style: TextStyle(color: Colors.red, fontSize: 18),
                    ),
                  ),
                const Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Row(
                    children: [
                      Text(
                        "Description",
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                TextForm(
                  hintText: "Add Description to your Forum",
                  controller: DescriptionController,
                  largerHint: true,
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Switch(
                        activeColor: Color(0xff4285F4),
                        inactiveTrackColor: Color.fromARGB(171, 163, 164, 183),
                        value: isAnonymous,
                        onChanged: (value) {
                          setState(() {
                            isAnonymous = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    MaterialButton(
                      minWidth: 9,
                      height: 50,
                      onPressed: pickImage,
                      color: Color.fromARGB(255, 0, 0, 0),
                      textColor: Color.fromARGB(255, 255, 255, 255),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.upload,
                            color: Colors.white,
                          ),
                          SizedBox(width: 5),
                          Text(
                            "Upload Image",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    Button(
                      buttonColor: Color(0xff01579B),
                      buttonText: 'Submit',
                      textColor: Colors.white,
                      widthButton: 160,
                      heightButton: 50,
                      onPressed: () async {
                        validateInputs();

                        if (titleError.isEmpty && descriptionError.isEmpty) {
                          String? token = await Auth.getToken();

                          if (token != null) {
                            String? imageUrl;
                            if (_imageFile != null) {
                              imageUrl = await uploadImage(_imageFile!);
                            }

                            PostsApi.createPost(
                                TitleController.text,
                                DescriptionController.text,
                                token,
                                context,
                                isAnonymous,
                                imageUrl);

                            // Switch to the "Posts" tab
                            widget.tabController.animateTo(0);
                          } else {
                            print('Token not available');
                          }
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
