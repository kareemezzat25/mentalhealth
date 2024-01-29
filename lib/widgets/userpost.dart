
import 'package:flutter/material.dart';

class userPost extends StatelessWidget
{
  @override
  Widget build (BuildContext context)
  {
    return   Container(
      height: 350,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "How to get over 'F' grade?",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(height: 10),
          //description
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                "When life hands you an 'F,' it's easy to feel like it's game over. But let's hit pause and remember: one test doesn't define you. 💪 Embrace the setback, seek support, and use it as a stepping stone to come back stronger. Your journey is still unfolding, and success is a marathon, not a sprint. Keep pushing forward!",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          //image
          Container(
              height: 140,
              alignment: Alignment.center,
              decoration:BoxDecoration(
                  image:DecorationImage(image: AssetImage("assets/images/Illustration.png"))
              )),
          Container(
            height: 50,

          ),
        ],
      ),
    );
  }
}


