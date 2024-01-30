import 'package:flutter/material.dart';
import 'login.dart';
import 'signup.dart';

class HomePage extends StatelessWidget {
  HomePage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 35),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Welcome',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30)),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                          'Automatic identity verification which enables you to verify your identity',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15, color: Colors.grey)),
                    ]),
                Container(
                    height: MediaQuery.of(context).size.height / 3,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image:
                                AssetImage('assets/images/Illustration.png')))),
                Column(
                  children: [
                    MaterialButton(
                        minWidth: double.infinity,
                        height: 60,
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Login();
                          }));
                        },
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text("Login",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18))),
                    SizedBox(height: 20),
                    MaterialButton(
                        color: Color(0xff4CAF50),
                        minWidth: double.infinity,
                        height: 60,
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Signup();
                          }));
                        },
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text("Signup",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18))),
                  ],
                )
              ])),
    ));
  }
}
