import 'dart:convert';

import 'package:http/http.dart' as http;
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

class NotificationRequest {
  Future<EmptyResponse> push(NotificationRequestData data) async {
    final response = await http.post("https://go-firebase-notif-sender.herokuapp.com/api/v1/payload", body: jsonEncode(data.toJson()));

    if (response.statusCode == 200 || response.statusCode == 201) {
      return EmptyResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load orders');
    }
  }
}

class NotificationRequestData {
  String apiKey;
  String topic;
  NotificationPayload notification;
  NotificationPayload data;

  NotificationRequestData({this.apiKey, this.topic, this.notification, this.data});

  NotificationRequestData.fromJson(Map<String, dynamic> json) {
    apiKey = json['api_key'];
    topic = json['topic'];
    notification = json['notification'] != null
        ? new NotificationPayload.fromJson(json['notification'])
        : null;
    data =
    json['data'] != null ? new NotificationPayload.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['api_key'] = this.apiKey;
    data['topic'] = this.topic;
    if (this.notification != null) {
      data['notification'] = this.notification.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class EmptyResponse {
  EmptyResponse({
    this.status,
    this.message,
  });

  int status;
  String message;

  factory EmptyResponse.fromJson(Map<String, dynamic> json) => EmptyResponse(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}

class Data {
  Data();

  factory Data.fromJson(Map<String, dynamic> json) => Data(
  );

  Map<String, dynamic> toJson() => {
  };
}

class NotificationPayload {
  String title;
  String body;

  NotificationPayload({this.title, this.body});

  NotificationPayload.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['body'] = this.body;
    return data;
  }
}