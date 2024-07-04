import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mentalhealthh/views/authentication/loginview.dart';

class SignupApi {
  static Future<void> signup(
      BuildContext context, Map<String, dynamic> requestData) async {
    try {
      final String apiUrl =
          'https://nexus-api-h3ik.onrender.com/api/auth/register';

      String requestBody = jsonEncode(requestData);

      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: requestBody,
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please confirm your email"),
            duration: Duration(seconds: 10),
            action: SnackBarAction(
              label: "OK",
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );
      } else if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Signup successful. Please confirm your email"),
            duration: Duration(seconds: 5),
            action: SnackBarAction(
              label: "OK",
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
            ),
          ),
        );

        Future.delayed(Duration(seconds: 6), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Login()),
          );
        });
      } else {
        print('Signup failed. Status code: ${response.statusCode}');
        log('Response body: ${response.body}');

        try {
          final Map<String, dynamic> errorBody = jsonDecode(response.body);

          if (errorBody.containsKey('errors') &&
              errorBody['errors'].isNotEmpty) {
            final Map<String, dynamic> errors = errorBody['errors'];

            if (errors.containsKey('Email')) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(errors['Email'][0]),
                  duration: Duration(seconds: 5),
                ),
              );
            }

            if (errors.containsKey('Password')) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(errors['Password'][0]),
                  duration: Duration(seconds: 5),
                ),
              );
            }

            // Handle other error cases as needed
          }
        } catch (e) {
          print('Error decoding error response: $e');
        }
      }
    } catch (error) {
      print('Error during signup: $error');
    }
  }
}
