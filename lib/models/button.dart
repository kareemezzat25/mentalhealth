import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Button extends StatelessWidget {
  final Color buttonColor;
  final String buttonText;
  final Color textColor; // Add this line
  Function()? onPressed;

  Button(
      {required this.buttonColor,
      required this.buttonText,
      this.textColor = Colors.black, // Default text color is black
      this.onPressed,
      });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: 180.0,
      height: 60,
      onPressed: onPressed,
      color: buttonColor,
      textColor: textColor, // Set text color
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        buttonText,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }
}
