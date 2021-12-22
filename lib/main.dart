import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:qrcode/screens/auth/login.dart';
import 'package:qrcode/screens/splash/splash.dart';
import 'package:qrcode/services/navigation_key.dart';
import 'package:qrcode/services/notification_service.dart';
import 'package:qrcode/utils/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await NotificationService.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: NavigationService.navigatorKey,
        title: 'BEAW',
        theme: ThemeData(
            primarySwatch: AppColors.primaryColor,
            fontFamily: "Raleway",
            scaffoldBackgroundColor: Colors.black),
        home: Splash());
  }
}
