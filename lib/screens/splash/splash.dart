import 'dart:async';

//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:qrcode/screens/auth/login.dart';
import 'package:qrcode/screens/nav_pages/bottom_navigation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:qrcode/screens/nav_pages/user_notification.dart';
import 'package:qrcode/widgets/user_notification_list.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  String? token;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  startTimer() {
    Timer(Duration(seconds: 2), () async {
      FlutterSecureStorage storage = FlutterSecureStorage();
      if (await storage.containsKey(key: "qridcode")) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => BottomNavigation()));
//            MaterialPageRoute(builder: (_) => Login()));
      } else {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => Login()));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/images/logo.png",
          width: MediaQuery.of(context).size.width * 0.7,
        ),
      ),
    );
  }
}
