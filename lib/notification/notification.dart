import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart' as flip;
import 'package:firebase_messaging/firebase_messaging.dart';

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

class Notification {

  void init() async {

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        _backgroundMessageHandler(message);
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
}