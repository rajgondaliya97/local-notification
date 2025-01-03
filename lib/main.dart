import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Local Notification Demo'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              bool _check = await checkNotificationPermission();
              _check == true ? 
              showNotification(
                'Hello User',
                'My name is Raj',
              ) : print("Accept Reqvest>>>>>>");
            },
            child: const Text('Show Notification'),
          ),
        ),
      ),
    );
  }
}

Future<void> showNotification(String title, String body) async {
  print(">>>>>>>>>>>>>>>>>>>>>>>>>");
 // bool _check = await checkNotificationPermission();
  print(">>>>>>>>>>>>>>>>>>>>>>>>>");
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'channel_id', // Channel ID
    'Channel Name', // Channel name
    channelDescription: 'Channel Description',
    importance: Importance.high,
    priority: Priority.high,
  );
  print("<<<<<<<<<<<<<<>>>>>>>>>>>>>>");
  const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails();

  const NotificationDetails notificationDetails = NotificationDetails(
    android: androidDetails,
    iOS: iOSDetails,
  );

  await flutterLocalNotificationsPlugin.show(
    0, // Notification ID
    title, // Title
    body, // Body
    notificationDetails,
  );
}

Future checkNotificationPermission() async {

  final permission = await Permission.notification.request();
  if (permission.isGranted) {
    return true;
  } else if (permission.isDenied) {
    return false;
  } else if (permission.isPermanentlyDenied) {
    return false;
  }
}
