import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Token {
  static updateToken() async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging();
    String token = await firebaseMessaging.getToken();
    print("Update Firebase Token : + $token");
    User user = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance
        .collection("userDatas")
        .doc(user.uid)
        .update({'token': token});
  }

  static removeToken() async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging();
    String token = await firebaseMessaging.getToken();
    User user = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance
        .collection("pushToken")
        .doc(user.uid)
        .update({'token': token});
  }

}
