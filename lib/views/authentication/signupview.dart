import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mentalhealthh/services/SignupApi.dart';
import 'loginview.dart';
import '../../widgets/textForm.dart';
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
  //TextEditingController genderController = TextEditingController();

  String emailError = '';
  String passwordError = '';
  String genderError = '';
  String birthDateError = '';
  String selectedGender = '';

  void signup() async {
    try {
      Map<String, dynamic> requestData = {
        "firstName": firstNameController.text,
        "lastName": lastNameController.text,
        "email": emailController.text,
        "password": passwordController.text,
        "birthDate": birthDateController.text,
        "gender": selectedGender,
        "role": "User"
      };

      await SignupApi.signup(context, requestData);
    } catch (error) {
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
              if (emailError.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: Text(
                    emailError,
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),
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
              if (passwordError.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: Text(
                    "Password Must be at least 8 characters , have ('0'-'9') & ('A'-'Z'),  ",
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),
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
              if (birthDateError.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: Text(
                    birthDateError,
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),
              SizedBox(height: 5),
              const Padding(
                padding: EdgeInsets.only(left: 12),
                child: Row(
                  children: [
                    Text(
                      "Select Gender",
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              //TextForm(hintText: "male/female", controller: genderController),

              Row(
                children: [
                  Radio(
                    value: 'male',
                    groupValue: selectedGender,
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value as String;
                      });
                    },
                  ),
                  Text(
                    'Male',
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                  Radio(
                    value: 'female',
                    groupValue: selectedGender,
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value as String;
                      });
                    },
                  ),
                  Text('Female',
                      style: TextStyle(color: Colors.grey, fontSize: 15)),
                ],
              ),

              if (genderError.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: Text(
                    genderError,
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),
              SizedBox(height: 5),
              Button(
                buttonColor: Color(0xff01579B),
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
                        style: TextStyle(color: Color(0xff01579B)),
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
