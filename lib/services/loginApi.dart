import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:mentalhealthh/DoctorViews/DoctorMainview.dart';
import 'package:mentalhealthh/authentication/auth.dart';
import 'package:mentalhealthh/views/Forumsview.dart';

class LoginApi {
  static Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final String accessToken = googleAuth.accessToken!;

        final String apiUrl =
            'https://mentalmediator.somee.com/api/auth/external-login-callback';
        final http.Response response = await http.get(
          Uri.parse(apiUrl),
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        );

        if (response.statusCode == 200) {
          print("login Successful");
        } else {
          print('Login failed. Status code: ${response.statusCode}');
          log('Response body: ${response.body}');
        }
      } else {
        print("User canceled Google Sign-In");
      }
    } catch (error) {
      print('Error during Google Sign-In: $error');
    }
  }

  static Future<void> login(
      BuildContext context, String email, String password) async {
    try {
      final String apiUrl =
          'https://nexus-api-h3ik.onrender.com/api/auth/signin';

      Map<String, dynamic> requestData = {
        "email": email,
        "password": password,
      };

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
        String token = json.decode(response.body)['token'];
        String userId = json.decode(response.body)['userId'];
        String userName = json.decode(response.body)['userName'];
        String photoUrl = json.decode(response.body)['photoUrl'];
        List<dynamic> roles = json.decode(response.body)['roles'];

        await Auth.setToken(context, token, email, userId);
        await Auth.setUserName(context, userName);
        await Auth.setPhotoUrl(photoUrl);

        log('Response body: ${response.body}');

        if (roles.contains("Doctor")) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => DoctorMainview(doctorId: userId,roles: roles,)),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Forumsview(userId: userId,roles:roles)),
          );
        }
      } else {
        print('Login failed. Status code: ${response.statusCode}');
        log('Response body: ${response.body}');

        try {
          final Map<String, dynamic> errorBody = jsonDecode(response.body);

          if (errorBody.containsKey('errors') &&
              errorBody['errors'].isNotEmpty) {
            final List<dynamic> errors = errorBody['errors'];

            for (var error in errors) {
              if (error.containsKey('description')) {
                // Return or handle the error description
              }
            }
          }
        } catch (e) {
          print('Error decoding error response: $e');
        }
      }
    } catch (error) {
      print('Error during login: $error');
    }
  }

  static Future<void> forgotPassword(BuildContext context, String email) async {
    final String apiUrl =
        'https://nexus-api-h3ik.onrender.com/api/auth/send-reset-password-link?email=$email';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    try {
      print('Sending request to $apiUrl');
      print('Headers: $headers');

      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text(
                  'An email with reset password link has been sent to your email address.'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        print('Forgot password failed. Status code: ${response.statusCode}');
        log('Response body: ${response.body}');
      }
    } catch (error) {
      print('Error during forgot password: $error');
    }
  }
}
