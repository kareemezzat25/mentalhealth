import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mentalhealthh/authentication/auth.dart';
import 'dart:convert';
import 'textForm.dart';
import 'package:mentalhealthh/models/button.dart';
import 'package:mentalhealthh/views/signup.dart';
import 'package:mentalhealthh/views/MainHomeview.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:mentalhealthh/widgets/signinwithgoogle.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void login() async {
    try {
      // API endpoint
      final String apiUrl = 'https://mentalmediator.somee.com/api/auth/signin';

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

      print(response.body);
      // Check response status code
      // Inside the login() function
      if (response.statusCode == 200) {
        // Login successful, handle the response accordingly
        String token = json.decode(response.body)['token'];
        await Auth.setToken(token, emailController.text);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainHome()));
      } else {
        // Login failed, handle the error
        print('Login failed. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
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
                    child: GoogleSignInButton(
                      onPressed: () {
                        // Handle Google Sign-In
                      },
                    )),
                SizedBox(height: 15),
                const Padding(
                  padding: EdgeInsets.only(left: 14),
                  child: Row(
                    children: [
                      Text("Enter Email or username",
                          style: TextStyle(fontSize: 15, color: Colors.grey)),
                    ],
                  ),
                ),
                TextForm(
                  hintText: "Email",
                  controller: emailController,
                ),
                SizedBox(height: 15),
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
                  buttonColor: Color(0xff0B570E),
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
                            style: TextStyle(color: Color(0xff0B570E)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
