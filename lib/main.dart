import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mypresensi/pages/adak_controller.dart';
import 'package:mypresensi/pages/dosen_controller.dart';
import 'package:mypresensi/pages/mhs_controller.dart';
import 'package:mypresensi/pages/splashscreen.page.dart';
import 'package:mypresensi/pages/welcome_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashScreenPage(),
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('userDatas')
                  .doc(snapshot.data.uid)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData) {
                  final user = snapshot.data.data();

                  if (user['rule'] == 'adak') {
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AdakController()),
                      );
                    });
                  } else if (user['rule'] == 'dosen') {
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DosenController()),
                      );
                    });
                  } else {
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MahasiswaController()),
                      );
                    });
                  }
                }
                return Container(
                  child: Material(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              });
        }
        return WelcomePage();
      },
    );
  }
}
