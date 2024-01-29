import 'package:flutter/material.dart';

class Userinfopost extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return  Container(
        height: 80,
        child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: Colors.brown, style: BorderStyle.solid),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/Illustration.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 10),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Ali ATTIA", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("yesterday at 11 am", style: TextStyle(fontSize: 12)),
                ],
              ),
            ]));
  }
}