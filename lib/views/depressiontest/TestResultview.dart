import 'package:flutter/material.dart';
import 'package:mentalhealthh/views/Doctors/Doctorsview.dart'; // Import your DoctorsPage widget
import 'package:mentalhealthh/views/authentication/signupview.dart';
import 'package:mentalhealthh/views/posts/Posts.dart'; // Import your Posts widget

class TestResultPage extends StatelessWidget {
  final String depressionIndicated;
  final String userid;

  TestResultPage(this.depressionIndicated,{required this.userid});

  @override
  Widget build(BuildContext context) {
    String resultMessage;
    String userID =userid;
    List<Widget> actionButtons = [];

    if (depressionIndicated=="Depressed") {
      resultMessage =
          'Based on your answers, you might be experiencing symptoms of depression. Please consider reaching out to a mental health professional for further evaluation and support.';
      
      // Add Find Doctor button
      actionButtons.add(
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push
              ( 
                context,
                MaterialPageRoute(builder: (context) => Doctorsview(userId: userid,)),
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
                MaterialPageRoute(builder: (context) => Doctorsview(userId: userid)),
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
                    const Text("Result",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xff3699A2),
                      fontSize: 28,
                      fontWeight: FontWeight.bold
                    ),),
                    
                    SizedBox(height: 40,),
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
                    userid!=""?Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: actionButtons,):
                    Column(
                      children: [
                        Text("Join to our commuinty",
                        textAlign: TextAlign.center,
                        style:TextStyle(fontSize: 18)),
                        SizedBox(height: 20,),
                        ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Signup()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          onPrimary: Colors.white,
                          minimumSize: Size(250,50)
                        ),
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
          /*Card(
            elevation: 2,
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'How Our Test Works:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '1. Response Weighting: We assign weights to your responses to determine if the overall sentiment tends to be more negative.',
                  ),
                  SizedBox(height: 10,),
                  Text(
                    '2. Sentiment Analysis: We use advanced techniques like VADER and RoBERTa, combined with user analysis, to assess if your responses indicate potential issues.',
                  ),
                  SizedBox(height: 10,),
                  Text(
                    '3. Depression Analysis: We compare your responses against a database of over 10,000 depression cases using machine learning models (decision trees, logistic regression, and support vector machines) to identify similarities.',
                  ),
                  SizedBox(height: 20),
                  Text(
                    'This multi-phase approach allows us to provide a comprehensive assessment. However, it\'s important to note that this test is not a clinical diagnosis. Always consult with a mental health professional for a proper evaluation.',
                  ),
                ],
              ),
            ),
          ),*/
          
          
        ],
      ),
    );
  }
}
