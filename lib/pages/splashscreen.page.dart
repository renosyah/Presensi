import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mypresensi/main.dart';
import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart' as flip;

const flip.AndroidNotificationChannel channel = flip.AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: flip.Importance.max,
);
final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
final flip.FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = flip.FlutterLocalNotificationsPlugin();

final flip.AndroidNotificationDetails androidPlatformChannelSpecifics =  flip.AndroidNotificationDetails(
    channel.id, channel.name, channel.description,
    icon: '@mipmap/ic_launcher',
    importance: flip.Importance.max,
    priority: flip.Priority.high,
    ticker: 'ticker'
);

Future<dynamic> _backgroundMessageHandler(Map<String, dynamic> message) async {
  print("onBackgroundMessage: $message");
  if (message.containsKey('data')) {
    var title = message['data']['title'];
    var body = message['data']['body'];

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<flip.AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await flutterLocalNotificationsPlugin.show(
        0, title, body,flip.NotificationDetails(
          android: androidPlatformChannelSpecifics
      ), payload: 'item x'
    );
  }
}

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {

  @override
  void initState() {
    super.initState();
    initCloudMessaging();
    startSplashScreen();
  }

  initCloudMessaging() async {

    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage: $message");
        },
        onBackgroundMessage: _backgroundMessageHandler,
        onLaunch: (Map<String, dynamic> message) async {
          print("onLaunch: $message");
        },
        onResume: (Map<String, dynamic> message) async {
          print("onResume: $message");
        },
    );

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true)
    );

    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });

    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      print("Push Messaging token: $token");
    });

    _firebaseMessaging.subscribeToTopic('events');
  }

  startSplashScreen() async {

    var duration = const Duration(seconds: 2);
    return Timer(duration, () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MainPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 0, 191, 255),
            Color.fromARGB(255, 224, 255, 255)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomCenter,
        )),
        child: Center(
          child: Image.asset("images/acacom.png", width: 700.0, height: 200.0),
        ),
      ),
    );
  }
}
