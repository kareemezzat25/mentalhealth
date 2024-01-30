import 'package:flutter/material.dart';
import 'package:mentalhealthh/models/Icon.dart';
import 'package:mentalhealthh/widgets/Iconpost.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class Forum extends StatelessWidget {
  final String? postTitle;
  final String? postContent;
  final String? username;
  final String? postedOn;
  final Function(String)? onDelete;

  Forum({this.postTitle, this.postContent, this.username, this.postedOn,this.onDelete});

  List<Iconofpost> iconsList = [
    Iconofpost(iconData: Icons.favorite),
    Iconofpost(iconData: Icons.comment),
    Iconofpost(iconData: Icons.share),
  ];
  Future<void> deletePost(String postId) async {
    try {
      final response = await http.delete(Uri.parse('https://mentalmediator.somee.com/api/posts/$postId'));

      if (response.statusCode == 200) {
        // Post deleted successfully
        onDelete?.call(postId); // Notify parent widget about deletion
      } else {
        // Handle other status codes
        // You may want to show an error message
      }
    } catch (error) {
      // Handle network errors
      // You may want to show an error message
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left:20,right:10, top:5,bottom: 5),
        child: Row(
          children: [
            Container(
              decoration:BoxDecoration(
                color: Color(0xffEEEEEE),
                borderRadius: BorderRadius.circular(15)
              ),
              width: screenWidth * 0.9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 2),
                  Container(
                    height: 80,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              border: Border.all(
                                color: Colors.brown,
                                style: BorderStyle.solid,
                              ),
                              image: DecorationImage(
                                image: AssetImage('assets/images/Illustration.png'),
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
                                username ?? "",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                postedOn ?? "",
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          Spacer(),
                          PopupMenuButton<String>(
                            onSelected: (value) {
                              // Handle menu item selection
                              if (value == 'edit') {
                                // Perform edit action
                              } else if (value == 'delete') {
                                // Perform delete action
                              }
                            },
                            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
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
                            
                            child: Icon(Icons.more_horiz),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  //title
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      postTitle ?? "",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  SizedBox(height: 5),
                  //description
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: Text(
                          postContent ?? "",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (int index = 0; index < iconsList.length; index++)
                          IconPost(
                            iconreaction: iconsList[index],
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
