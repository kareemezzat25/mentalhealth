
import 'package:flutter/material.dart';

import 'package:mentalhealthh/services/loginApi.dart';
import 'package:mentalhealthh/widgets/signinwithgoogle.dart';
import 'package:mentalhealthh/models/button.dart';
import 'package:mentalhealthh/views/authentication/signupview.dart';
import 'package:mentalhealthh/widgets/textForm.dart';



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

  void signInWithGoogle() {
    LoginApi.signInWithGoogle(context);
  }

  void login() {
    LoginApi.login(context, emailController.text, passwordController.text);
  }

  void forgotPassword() {
    LoginApi.forgotPassword(context, forgotPasswordEmailController.text.trim());
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
