import 'package:flutter/material.dart';
import 'package:mentalhealthh/models/Icon.dart';
import 'package:mentalhealthh/widgets/Iconpost.dart';
import 'package:mentalhealthh/widgets/userpost.dart';

class Forum extends StatelessWidget {
  final String? postTitle;
  final String? postContent;
  final String? username;
  final String? postedOn;

  Forum({this.postTitle, this.postContent, this.username, this.postedOn});

  List<Iconofpost> iconsList = [
    Iconofpost(iconData: Icons.favorite),
    Iconofpost(iconData: Icons.comment),
    Iconofpost(iconData: Icons.share),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Container(
              width: screenWidth * 0.9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 25),
                  Container(
                    height: 80,
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(
                                color: Colors.brown, style: BorderStyle.solid),
                            image: DecorationImage(
                              image:
                                  AssetImage('assets/images/Illustration.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(username ?? "",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            Text(postedOn ?? "",
                                style: TextStyle(fontSize: 12)),
                          ],
                        ),
                        Spacer(flex: 1),
                        IconButton(
                          icon: Icon(Icons.more_horiz),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  //title
                  Text(
                    postTitle ?? "",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  //description
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        postContent ?? "",
                        style: TextStyle(fontSize: 18),
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
