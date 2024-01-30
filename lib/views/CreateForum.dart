import 'package:flutter/material.dart';
import 'package:mentalhealthh/api/postsApi.dart';
import 'package:mentalhealthh/authentication/auth.dart';
import 'package:mentalhealthh/models/button.dart';
import 'package:mentalhealthh/views/Formview.dart';

class createForum extends StatelessWidget {
  TextEditingController TitleController = TextEditingController();
  TextEditingController TagsController = TextEditingController();
  TextEditingController DescriptionController = TextEditingController();

  void UploadImage() {}
  // Inside the Submit() function
  void Submit() async {
    // Get token
    String? token = await Auth.getToken();

    if (token != null) {
      // Call the createPost function here
      PostsApi.createPost(
        TitleController.text,
        DescriptionController.text,
        token,
      );
      // You may also want to refresh the forums content here
      // You can achieve this by calling a function to reload the posts
      // or by using a state management solution.
    } else {
      print('Token not available');
      // Handle case where token is not available
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: SingleChildScrollView(
        child: Column(
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
                hintText: "Enter Forum Title", controller: TitleController),
            SizedBox(height: 15),
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
            TextForm(hintText: "Tag1,Tag2.etc.", controller: TagsController),
            SizedBox(height: 15),
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
              hintText: "add Description to your Forum",
              controller: DescriptionController,
              largerHint: true,
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Row(
                    children: [
                      Text(
                        "Image",
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    MaterialButton(
                      minWidth: 9,
                      height: 50,
                      onPressed: UploadImage,
                      color: Color.fromARGB(255, 0, 0, 0),
                      textColor: Color.fromARGB(255, 255, 255, 255),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child:const Row(
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
                    SizedBox(width: 10), // Add spacing between the buttons
                    Button(
                      buttonColor: Color(0xff0B570E),
                      buttonText: 'Submit',
                      textColor: Colors.white,
                      widthButton: 160,
                      heightButton:50,
                      onPressed: () async {
                        // Get token
                        String? token = await Auth.getToken();

                        if (token != null) {
                          // Call the createPost function here
                          PostsApi.createPost(
                            TitleController.text,
                            DescriptionController.text,
                            token,
                          );
                          // You may also want to refresh the forums content here
                          // You can achieve this by calling a function to reload the posts
                          // or by using a state management solution.
                        } else {
                          print('Token not available');
                          // Handle case where token is not available
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
