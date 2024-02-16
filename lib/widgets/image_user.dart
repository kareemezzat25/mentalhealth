
import 'package:flutter/material.dart';

class ImageUser extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                border: Border.all(
                    color: Colors.grey,
                    style: BorderStyle.solid),
                image: const DecorationImage(
                  image: AssetImage(
                      'assets/images/Memoji Boys 3-15.png'),
                  fit: BoxFit.cover,
                ),
              ),
            );
  }
}