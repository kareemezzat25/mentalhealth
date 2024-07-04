import 'dart:convert';

import 'package:flutter/material.dart';
  import 'package:http/http.dart' as http;

class ChooseEmailScreen extends StatelessWidget {
  final String chosenEmail;

  ChooseEmailScreen({required this.chosenEmail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Email'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Selected Email:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              chosenEmail,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                sendResetPasswordLink(chosenEmail);
              },
              child: Text('Send Reset Password Link'),
            ),
          ],
        ),
      ),
    );
  }

 void sendResetPasswordLink(String email) async {
  try {
    final String apiUrl = 'https://nexus-api-h3ik.onrender.com/api/auth/send-reset-password-link';
    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      body: jsonEncode({'email': email}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      print('Reset password link sent successfully to $email');
      // Handle success
    } else {
      print('Failed to send reset password link. Status code: ${response.statusCode}');
      // Handle failure
    }
  } catch (error) {
    print('Error sending reset password link: $error');
    // Handle any errors
  }
}
}
