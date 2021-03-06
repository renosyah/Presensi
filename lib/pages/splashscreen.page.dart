import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/scheduler.dart';
import 'package:mypresensi/pages/adak_controller.dart';
import 'package:mypresensi/pages/dosen_controller.dart';
import 'package:mypresensi/pages/mhs_controller.dart';
import 'package:mypresensi/pages/welcome_page.dart';
import 'package:mypresensi/session/session.dart';
import '../notification/notification.dart' as notif;
import 'dart:async';
import 'package:permission_handler/permission_handler.dart' as permission;

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

    var status = await permission.Permission.camera.status;
    if (status.isGranted) {

      new notif.Notification().init();

      var duration = const Duration(seconds: 2);
      return Timer(duration, () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MainPage()));
      });

    }  else {

      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Camera Permission'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('This app need to access camera or qrcode scan cannot be use,'),
                  Text('Access app setting and enable all permission required.'),
                  Text('Would you like to approve of this?'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Ignore'),
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => MainPage()));
                },
              ),
              TextButton(
                child: Text('Setting'),
                onPressed: () async {
                  bool settingsOpened = await permission.openAppSettings();
                  if (settingsOpened) {
                    BasicMessageChannel<String> lifecycleChannel = SystemChannels.lifecycle;
                    lifecycleChannel.setMessageHandler((msg) {
                      if (msg.contains("resumed")) {
                        lifecycleChannel.setMessageHandler(null);
                        startSplashScreen();
                      }
                      return;
                    });
                  }
                },
              )
            ],
          );
        },
      );
    }
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


class MainPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserSession>(
      future: SessionManager().load(),
      builder: (context, snapshot) {
        if (snapshot.hasData){
          var user = snapshot.data;

          if (user.role == 'adak') {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdakController()),
              );
            });
          // }
          // else if (user.role == 'dosen') {
          //   SchedulerBinding.instance.addPostFrameCallback((_) {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //           builder: (context) => DosenController()),
          //     );
          //   });
          } else if (user.role == 'user'){
            SchedulerBinding.instance.addPostFrameCallback((_) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MahasiswaController()),
              );
            });
          }
          return Container(
            child: Material(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
        return WelcomePage();
      },
    );
  }
}