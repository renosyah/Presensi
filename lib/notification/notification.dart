import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart' as flip;
import 'package:firebase_messaging/firebase_messaging.dart';


// variabel untuk notifikasi chanel
const flip.AndroidNotificationChannel channel = flip.AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: flip.Importance.max,
);

// instance firebase messaging
final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

// instance untuk notifikasi
final flip.FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = flip.FlutterLocalNotificationsPlugin();

// bentuk notifikasi
final flip.AndroidNotificationDetails androidPlatformChannelSpecifics =  flip.AndroidNotificationDetails(
    channel.id, channel.name, channel.description,
    icon: '@mipmap/ic_launcher',
    importance: flip.Importance.max,
    priority: flip.Priority.high,
    ticker: 'ticker'
);

// fungsi untuk menangani notifikasi yang datang dari background
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


// kelas notifikasi
class Notification {

  // fungsi inisialisasi notikasi
  // dan registrasi notifkasi saat aplikasi running
  void init() async {

    _firebaseMessaging.configure(
      onMessage: _backgroundMessageHandler,
      onBackgroundMessage: _backgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async { },
      onResume: (Map<String, dynamic> message) async { },
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


// kelas request notifikasi
class NotificationRequest {

  // fungsi push notifikasi ke server custom
  Future<EmptyResponse> push(NotificationRequestData data) async {
    final response = await http.post("https://go-firebase-notif-sender.herokuapp.com/api/v1/payload", body: jsonEncode(data.toJson()));

    if (response.statusCode == 200 || response.statusCode == 201) {
      return EmptyResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load orders');
    }
  }
}

// kelas untuk payload notifikasi yang akan dikirim
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

// kelas untuk response kosong
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

// data response kosong
class Data {
  Data();

  factory Data.fromJson(Map<String, dynamic> json) => Data(
  );

  Map<String, dynamic> toJson() => {
  };
}

// kelas untuk payload notifikasi yang akan diterima
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