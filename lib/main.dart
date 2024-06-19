import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:mentalhealthh/views/homeview.dart';

void main() {
  //  final cacheManager = CacheManager(Config(
  //   'customCacheKey',
  //   stalePeriod: Duration(days: 30),
  //   maxNrOfCacheObjects: 100,
  // ));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        duration: 3000,
        splash: const Text('Mental health',
            style: TextStyle(
                fontSize: 36,
                fontFamily: 'Hurricane',
                fontWeight: FontWeight.bold,
                color: Color(0xff01579B))),
        splashTransition: SplashTransition.fadeTransition,
        backgroundColor: Colors.white,
        nextScreen: HomePage(),
      ),
    );
  }
}

