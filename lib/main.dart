import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:mentalhealthh/Providers/doctor_notification_count_provider.dart';
import 'package:mentalhealthh/models/user_model.dart';
import 'package:mentalhealthh/views/homeview.dart';
import 'package:provider/provider.dart';
import 'package:mentalhealthh/providers/schedule_provider.dart';
import 'package:mentalhealthh/providers/notification_count_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ScheduleProvider()),
        ChangeNotifierProvider(create: (_) => UserModel()),
        ChangeNotifierProvider(create: (_) => NotificationCountProvider()),
        ChangeNotifierProvider(
            create: (_) => DoctorNotificationCountProvider()),
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
