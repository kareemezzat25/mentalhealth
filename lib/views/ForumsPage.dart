import 'package:flutter/material.dart';
import 'package:mentalhealthh/models/button.dart';
import 'package:mentalhealthh/views/Formview.dart';
import 'package:mentalhealthh/widgets/CommonDrawer.dart';
import 'CreateForum.dart';
import 'PostComment.dart';

class ForumsPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
  length: 3,
  child: Scaffold(
    appBar: AppBar(
      title: Text(
        'Mentality',
        style: TextStyle(fontSize: 33, fontWeight: FontWeight.bold),
      ),
      bottom: TabBar(
        tabs: [
          Tab(text: 'Forums'),
          Tab(text: 'Create Forum'),
          Tab(text: 'Post Comment'),
        ],
      ),
    ),
    drawer: CommonDrawer(),
    body: TabBarView(
      children: [
        ForumsContent(),
        CreateForum(),
        PostComment(),
      ],
    ),
  ),
);

  }
}

class ForumsContent extends StatelessWidget {
  TextEditingController TitleController = TextEditingController();
  TextEditingController TagsController = TextEditingController();
  TextEditingController DescriptionController = TextEditingController();

  void UploadImage(){

  }
  void Submit(){

  }

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      body: Padding(
        padding:EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              Text("Forums Details",style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                  ),
              SizedBox(height: 10),
              Text("Enter all the required data to be accurate",
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
                TextForm(hintText: "Enter Forum Title", controller: TitleController),
          
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
                TextForm(hintText: "add Description to your Forum", controller: DescriptionController,largerHint: true,),
                SizedBox(height: 20,),
                
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
          minWidth: 11,
          height: 60,
          onPressed: UploadImage,
          color: Color.fromARGB(255, 0, 0, 0),
          textColor: Color.fromARGB(255, 255, 255, 255),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              Icon(
                Icons.upload,
                color: Colors.white,
              ),
              SizedBox(width: 10),
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
          onPressed: Submit,
        ),
      ],
    ),
  ],
),

                                
                      
            ],
          ),
        ),
      ) 
        
    );
  }
}
