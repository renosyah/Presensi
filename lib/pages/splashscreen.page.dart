import 'package:flutter/material.dart';
import 'package:mypresensi/main.dart';
import '../notification/notification.dart' as notif;
import 'dart:async';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {


  @override
  void initState() {
    super.initState();
    startSplashScreen();
  }

  startSplashScreen() async {

    new notif.Notification().init();

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
