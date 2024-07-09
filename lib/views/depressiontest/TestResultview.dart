import 'package:flutter/material.dart';
import 'package:mentalhealthh/views/Doctors/Doctorsview.dart'; // Import your DoctorsPage widget
import 'package:mentalhealthh/views/authentication/signupview.dart';
import 'package:mentalhealthh/views/posts/Posts.dart'; // Import your Posts widget

class TestResultPage extends StatelessWidget {
  final String depressionIndicated;
  final String userid;

  TestResultPage(this.depressionIndicated, {required this.userid});

  @override
  Widget build(BuildContext context) {
    String resultMessage;
    String userID = userid;
    List<Widget> actionButtons = [];

    if (depressionIndicated == "Depressed") {
      resultMessage =
          'Based on your answers, you might be experiencing symptoms of depression. Please consider reaching out to a mental health professional for further evaluation and support.';

      // Add Find Doctor button
      actionButtons.add(
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Doctorsview(
                          userId: userid,
                        )),
              );
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              onPrimary: Colors.white,
            ),
            child: Text('Find Doctor'),
          ),
        ),
      );

      // Add spacing between buttons
      actionButtons.add(SizedBox(width: 10));

      // Add Join Support Community button
      actionButtons.add(
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Posts()),
              );
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.green,
              onPrimary: Colors.white,
            ),
            child: Text('Join Support Community'),
          ),
        ),
      );
    } else {
      resultMessage =
          'Your responses do not indicate symptoms of depression at this time. If you have concerns, please consult with a mental health professional.';

      // Add Find Doctor button (for consistency)
      actionButtons.add(
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Doctorsview(userId: userid)),
              );
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              onPrimary: Colors.white,
            ),
            child: Text('Find Doctor'),
          ),
        ),
      );

      // Add spacing between buttons
      actionButtons.add(SizedBox(width: 10));

      // Add Join Support Community button (for consistency)
      actionButtons.add(
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Posts()),
              );
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.green,
              onPrimary: Colors.white,
            ),
            child: Text('Join Support Community'),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Test Result'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Result",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color(0xff3699A2),
                          fontSize: 28,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      resultMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18.0),
                    ),
                    SizedBox(height: 20),
                    Divider(
                      thickness: 1,
                      indent: 20,
                      endIndent: 20,
                    ),
                    SizedBox(height: 20),
                    userid != ""
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: actionButtons,
                          )
                        : Column(
                            children: [
                              Text("Join to our commuinty",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 18)),
                              SizedBox(
                                height: 20,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Signup()),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.blue,
                                    onPrimary: Colors.white,
                                    minimumSize: Size(250, 50)),
                                child: Text('Sign Up'),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
