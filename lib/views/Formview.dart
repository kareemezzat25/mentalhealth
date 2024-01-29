import 'package:flutter/material.dart';

class TextForm extends StatefulWidget {
  final String? hintText;
  final TextEditingController controller;
  final bool isPassword;
  final bool largerHint;

  TextForm({
    required this.hintText,
    required this.controller,
    this.isPassword = false,
    this.largerHint = false,
  });

  @override
  _TextFormState createState() => _TextFormState();
}

class _TextFormState extends State<TextForm> {
  bool isObscure = true;
  double textFieldHeight = 50; // Default height

  @override
  Widget build(BuildContext context) {
    // Check if the largerHint parameter is true to set a larger height
    if (widget.largerHint) {
      textFieldHeight = 125;
    } else {
      textFieldHeight = 75; // Reset to default height
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Container(
        height: textFieldHeight,
        child: TextField(
          controller: widget.controller,
          obscureText: widget.isPassword ? isObscure : false,
          maxLines: textFieldHeight > 75 ? 8 : 1, // Allow multiple lines if height is greater than default
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.white),
            ),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      isObscure ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        isObscure = !isObscure;
                      });
                    },
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
