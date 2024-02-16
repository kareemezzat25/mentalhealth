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
              padding: EdgeInsets.only(left: 10), // Adjust the padding as needed
              child: Image.asset(
                "assets/images/google_logo.png",
                fit: BoxFit.cover,
                width: 28, // Adjust the width of the image
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
