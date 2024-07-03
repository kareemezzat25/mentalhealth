import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:mentalhealthh/models/user_model.dart';
import 'package:mentalhealthh/views/homeview.dart';
import 'package:provider/provider.dart';
import 'package:mentalhealthh/providers/schedule_provider.dart'; // Import your ScheduleProvider

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => ScheduleProvider()), // Provide ScheduleProvider here
        // Add other providers if needed
        ChangeNotifierProvider<UserModel>(create: (_) => UserModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AnimatedSplashScreen(
          duration: 3000,
          splash: const Text('Nexus',
              style: TextStyle(
                  fontSize: 36,
                  fontFamily: 'Hurricane',
                  fontWeight: FontWeight.bold,
                  color: Color(0xff01579B))),
          splashTransition: SplashTransition.fadeTransition,
          backgroundColor: Colors.white,
          nextScreen: HomePage(),
        ),
      ),
    );
  }
}
