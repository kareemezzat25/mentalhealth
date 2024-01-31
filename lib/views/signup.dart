import 'package:flutter/material.dart';
import 'package:mentalhealthh/authentication/auth.dart';
import 'login.dart';
import 'textForm.dart';
import 'dart:convert';
import "package:http/http.dart" as http;

import 'package:mentalhealthh/models/button.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController UsernameController = TextEditingController();

  void signup() async {
    try {
      // API endpoint
      final String apiUrl =
          'https://mentalmediator.somee.com/api/auth/register';

      // Request data
      Map<String, dynamic> requestData = {
        "firstName": firstNameController.text,
        "lastName": lastNameController.text,
        "email": emailController.text,
        "password": passwordController.text,
        "birthDate": birthDateController.text,
        "gender": genderController.text,
        "username": UsernameController.text
      };

      // Convert data to JSON
      String requestBody = jsonEncode(requestData);

      // Set headers
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      // Print the request data for debugging
      print('Request Data: $requestData');

      // Perform POST request
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: requestBody,
      );

      // Print the response for debugging
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      // Check response status code
      if (response.statusCode == 200) {
        // Signup successful, handle the response accordingly
        print('Signup successful');
      } else if (response.statusCode == 201) {
        // Signup successful, handle the response accordingly
        print('Signup successful');
        String token = json.decode(response.body)['token'];
        await Auth.setToken(token, emailController.text);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Login()));
      } else {
        // Signup failed, handle the error
        print('Signup failed. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      // Handle any network or other errors
      print('Error during signup: $error');
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
              const Column(
                children: [
                  Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Create an account, it's free",
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.only(left: 12),
                child: Row(
                  children: [
                    Text(
                      "Enter Username",
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              TextForm(hintText: "Username", controller: UsernameController),
              SizedBox(height: 5),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Text(
                              "Enter First Name",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.grey),
                            ),
                          ),
                          TextForm(
                              hintText: "First Name",
                              controller: firstNameController),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Text(
                              "Enter Last Name",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.grey),
                            ),
                          ),
                          TextForm(
                              hintText: "Last Name",
                              controller: lastNameController),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              const Padding(
                padding: EdgeInsets.only(left: 12),
                child: Row(
                  children: [
                    Text(
                      "Enter Email",
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              TextForm(hintText: "Email", controller: emailController),
              SizedBox(height: 5),
              const Padding(
                padding: EdgeInsets.only(left: 12),
                child: Row(
                  children: [
                    Text(
                      "Enter Password",
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              TextForm(
                  hintText: "Password",
                  controller: passwordController,
                  isPassword: true),
              SizedBox(height: 5),
              const Padding(
                padding: EdgeInsets.only(left: 12),
                child: Row(
                  children: [
                    Text(
                      "Enter Birth Date",
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              TextForm(hintText: "yyyy-mm-dd", controller: birthDateController),
              SizedBox(height: 5),
              const Padding(
                padding: EdgeInsets.only(left: 12),
                child: Row(
                  children: [
                    Text(
                      "Enter Gender",
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              TextForm(hintText: "Male/Female", controller: genderController),
              SizedBox(height: 5),
              Button(
                buttonColor: Color(0xff0B570E),
                buttonText: 'Sign up',
                textColor: Colors.white,
                onPressed: signup,
              ),
              Padding(
                padding: EdgeInsets.only(top: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?",
                        style: TextStyle(color: Color(0xff8D8D8D))),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Login()));
                      },
                      child: Text(
                        " Sign in",
                        style: TextStyle(color: Color(0xff0B570E)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
