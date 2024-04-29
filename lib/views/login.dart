import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:mentalhealthh/authentication/auth.dart';
import 'package:mentalhealthh/views/ForumsPage.dart';
import 'package:mentalhealthh/views/Posts.dart';
import 'dart:convert';
import 'textForm.dart';
import 'package:mentalhealthh/models/button.dart';
import 'package:mentalhealthh/views/signup.dart';
//import 'package:mentalhealthh/views/MainHomeview.dart';
import 'package:mentalhealthh/widgets/signinwithgoogle.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String emailError = '';
  String passwordError = '';
  String genericError = ''; // Added to store generic error message
  void signInWithGoogle() async {
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final String accessToken = googleAuth.accessToken!;

        // Call External Login API
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
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (context) => ForumsPage()),
          // );
        } else {
          print('Login failed. Status code: ${response.statusCode}');
          log('Response body: ${response.body}');
        }
      } else {
        print("User canceled Google Sign-In");
      }
    } catch (error) {
      // Handle any errors
    }
  }

  void login() async {
    try {
      // API endpoint
      final String apiUrl =
          'https://nexus-api-h3ik.onrender.com/api/auth/signin';

      // Request data
      Map<String, dynamic> requestData = {
        "email": emailController.text,
        "password": passwordController.text,
      };

      // Convert data to JSON
      String requestBody = jsonEncode(requestData);

      // Set headers
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      // Perform POST request
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: requestBody,
      );

      // Check response status code
      if (response.statusCode == 200) {
        // Login successful, handle the response accordingly
        String token = json.decode(response.body)['token'];
        String userId = json.decode(response.body)['userId'];
        String userName =json.decode(response.body)['userName']; // Add this line
        String photoUrl = json.decode(response.body)['photoUrl'];

        await Auth.setToken(token, emailController.text, userId);
        await Auth.setUserName(userName);
        await Auth.setPhotoUrl(photoUrl); // Add this line

        log('Response body: ${response.body}');

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Posts()));
      } else {
        // Login failed, handle the error
        print('Login failed. Status code: ${response.statusCode}');
        log('Response body: ${response.body}');

        try {
          final Map<String, dynamic> errorBody = jsonDecode(response.body);

          if (errorBody.containsKey('errors') &&
              errorBody['errors'].isNotEmpty) {
            final List<dynamic> errors = errorBody['errors'];

            for (var error in errors) {
              if (error.containsKey('description')) {
                setState(() {
                  genericError = error['description'];
                });
              }
            }
          }
        } catch (e) {
          // Handle JSON decoding error
          print('Error decoding error response: $e');
        }
      }
    } catch (error) {
      // Handle any network or other errors
      print('Error during login: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 60),
              const Text(
                "Sign in",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text("Login to your account",
                  style: TextStyle(fontSize: 15, color: Colors.grey)),
              SizedBox(height: 60),
              Padding(
                  padding: const EdgeInsets.only(left: 12, right: 120),
                  child: GoogleSignInButton(onPressed: signInWithGoogle)),
              SizedBox(height: 15),
              if (genericError.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(left: 14),
                  child: Text(
                    genericError,
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),
              const Padding(
                padding: EdgeInsets.only(left: 14),
                child: Row(
                  children: [
                    Text("Enter Email",
                        style: TextStyle(fontSize: 15, color: Colors.grey)),
                  ],
                ),
              ),
              TextForm(
                hintText: "Email",
                controller: emailController,
              ),

              SizedBox(height: 15),
              // Display generic error message for any other errors

              Padding(
                padding: EdgeInsets.only(left: 14),
                child: Row(
                  children: [
                    Text("Enter password",
                        style: TextStyle(fontSize: 15, color: Colors.grey)),
                  ],
                ),
              ),
              TextForm(
                hintText: "Password",
                controller: passwordController,
                isPassword: true,
              ),

              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      // we edit it later
                      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Signup()));
                    },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(color: Color(0xff4285F4)),
                    ),
                  ),
                  SizedBox(width: 20),
                ],
              ),
              SizedBox(height: 10),
              Button(
                buttonColor: Color(0xff01579B),
                buttonText: 'Sign in',
                textColor: Colors.white,
                onPressed: login,
              ),
              SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return Signup();
                      }));
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(color: Color(0xff8D8D8D)),
                        ),
                        Text(
                          "Sign up",
                          style: TextStyle(color: Color(0xff4285F4)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
