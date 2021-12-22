import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:qrcode/screens/nav_pages/bottom_navigation.dart';
import 'package:qrcode/screens/nav_pages/user_notification.dart';

import 'navigation_key.dart';

foo<T>(T c) {
  return c;
}

class NotificationService {
  ///
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  ///
  static void showNotification(RemoteMessage message) async {
    print("Showing Notification");

    flutterLocalNotificationsPlugin.show(
        message.hashCode,
        message.notification?.title,
        message.notification?.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
          ),
          iOS: const IOSNotificationDetails(
            presentAlert: true,
          ),
        ),
        payload: "");
  }

  /// Background Handler Method
  static Future<void> _firebaseBackgroundNotificationHandler(
      RemoteMessage message) async {
    print("called");
    if (message.data != null) {
      print("Background");
      showNotification(message);
    }
  }

  static int i = 0;

  static Future<void> init() async {
    log("Notification Service Started", name: "NOTIFICATION SERVICE");

    ///Init android settings
    const initSettingsAndroid =
        AndroidInitializationSettings('@drawable/launch_background');

    /// Init IOS settings
    const IOSInitializationSettings initSettingsIOS = IOSInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    const initializationSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIOS,
    );

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (payload) async {
        Navigator.pushReplacement(
            foo(NavigationService.navigatorKey.currentContext),
            MaterialPageRoute(
                builder: (_) => BottomNavigation(
                      index: 1,
                    )));
      },
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Notification settings
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    ///
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: Platform.isIOS ? false : true,
      badge: Platform.isIOS ? false : true,
      sound: Platform.isIOS ? false : true,
    );

    await FirebaseMessaging.instance
        .getToken()
        .then((value) => print("FCM TOKEN: $value"));

    ///Background Notification service
    FirebaseMessaging.onBackgroundMessage(
        _firebaseBackgroundNotificationHandler);

    /// Foreground Notification Stream..
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("Message Received 1 ::: $message");
      print("Message Received 2 ::: ${message.data}");
      print("Message Received 3 ::: ${message.notification}");

      /// Checking if [message] data and [Firebase.instance.currentUser] uId is empty or null.
//      if (message.data.isNotEmpty) {
//        print("Message Received 4 ");
//
//        print("Message Received 7 ");
      showNotification(message);
//      }
    });
  }

  static navigateTo({
    dynamic data,
  }) {
    print("Navigate");
  }
}
