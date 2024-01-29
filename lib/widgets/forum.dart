import 'package:flutter/material.dart';
import 'package:mentalhealthh/models/Icon.dart';
import 'package:mentalhealthh/widgets/Iconpost.dart';
import 'package:mentalhealthh/widgets/userpost.dart';

class Forum extends StatelessWidget {

  List<Iconofpost>iconsList=[
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
              width: screenWidth * 0.9, // Adjust the width as a percentage of screen width
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height:25),
                  Container(
                    height: 80,
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(color: Colors.brown, style: BorderStyle.solid),
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
                            Text("Ali ATTIA", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            Text("yesterday at 11 am", style: TextStyle(fontSize: 12)),
                          ],
                        ),
                        Spacer(flex:1),
                        IconButton(
                          icon: Icon(Icons.more_horiz),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  //title
                  userPost(),
                  SizedBox(height: 10),
                  Container(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for(int index=0;index<iconsList.length;index++)
                          IconPost(iconreaction: iconsList[index],)
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
