import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:mentalhealthh/DoctorViews/DoctorMainPgae.dart';
import 'package:mentalhealthh/authentication/auth.dart';
import 'package:mentalhealthh/views/ForumsPage.dart';
import 'dart:convert';
import 'textForm.dart';
import 'package:mentalhealthh/models/button.dart';
import 'package:mentalhealthh/views/signup.dart';
import 'package:mentalhealthh/widgets/signinwithgoogle.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController forgotPasswordEmailController = TextEditingController();

  String emailError = '';
  String passwordError = '';
  String genericError = '';

  void signInWithGoogle() async {
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

  void login() async {
    try {
      final String apiUrl =
          'https://nexus-api-h3ik.onrender.com/api/auth/signin';

      Map<String, dynamic> requestData = {
        "email": emailController.text,
        "password": passwordController.text,
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

        await Auth.setToken(context, token, emailController.text, userId);
        await Auth.setUserName(context, userName);
        await Auth.setPhotoUrl(photoUrl);

        log('Response body: ${response.body}');

        if (roles.contains("Doctor")) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => DoctorMainPage(doctorId: userId)),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ForumsPage(userId: userId)),
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
                setState(() {
                  genericError = error['description'];
                });
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

  Future<String?> getToken() async {
    return await Auth.getToken();
  }

  void forgotPassword() async {
  String email = forgotPasswordEmailController.text.trim();

  if (email.isEmpty) {
    setState(() {
      genericError = 'Please enter your email.';
    });
    return;
  }

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
            content: Text('An email with reset password link has been sent to your email address.'),
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
      setState(() {
        genericError = 'Failed to send reset link. Please try again.';
      });
      print('Forgot password failed. Status code: ${response.statusCode}');
      log('Response body: ${response.body}');
    }
  } catch (error) {
    setState(() {
      genericError = 'Error during request. Please try again.';
    });
    print('Error during forgot password: $error');
  }
}


  void showForgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Forgot Password'),
          content: TextField(
            controller: forgotPasswordEmailController,
            decoration: InputDecoration(hintText: "Enter your email"),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('Submit'),
              onPressed: forgotPassword,
            ),
          ],
        );
      },
    );
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
                    onTap: showForgotPasswordDialog,
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
