import 'package:flutter/material.dart';

class GoogleSignInButton extends StatelessWidget {
  final Function onPressed;

  GoogleSignInButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        decoration: BoxDecoration(
          color: Color(0xffE9F1FF),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey),
        ),
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 12), // Adjust the padding as needed
              child: Image.network(
                'http://pngimg.com/uploads/google/google_PNG19635.png',
                fit: BoxFit.cover,
                width: 24, // Adjust the width of the image
                height: 40, // Adjust the height of the image
              ),
            ),
            SizedBox(
              width: 5.0,
            ),
           Padding(padding: EdgeInsets.only(left:3),
           child: 
           Text('Sign-in with Google',
           style:TextStyle(color:Color(0xff4285F4))
           ))
          ],
        ),
      ),
    );
  }
}
