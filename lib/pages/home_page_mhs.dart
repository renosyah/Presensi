import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mypresensi/pages/listAgenda.dart';
import 'package:mypresensi/pages/scan_class.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class HomePageMahasiswa extends StatefulWidget {
  @override
  _HomePageMahasiswaState createState() => _HomePageMahasiswaState();
}

class _HomePageMahasiswaState extends State<HomePageMahasiswa> {

  User user;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  saveClass(String makulName) async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    String deviceId;
    Map<String, dynamic> deviceData;

    if (Platform.isAndroid) {
      final deviceInfo = await deviceInfoPlugin.androidInfo;
      deviceId = deviceInfo.androidId;
      deviceData = {
        'os_version': deviceInfo.version.sdkInt.toString(),
        'platform': 'android',
        'model': deviceInfo.model,
        'device': deviceInfo.device,
      };
    } else if (Platform.isIOS) {
      final deviceInfo = await deviceInfoPlugin.iosInfo;

      deviceId = deviceInfo.identifierForVendor;
      deviceData = {
        'os_version': deviceInfo.systemVersion,
        'platform': 'ios',
        'model': deviceInfo.model,
        'device': deviceInfo.name,
      };
    }

    final nowMs = DateTime.now();
    final presensiRef = _firestore.collection('presensi').doc();

    if ((await presensiRef.get()).exists) {
      await presensiRef.update({
        'waktu presensi': nowMs,
      });
    } else {
      await presensiRef.set({
        'mata_kuliah': makulName,
        'email': '${user.email}',
        'presensi': nowMs,
        'id': deviceId,
        'device info': deviceData,
      });
    }

  }

  @override
  void initState() {
    super.initState();
    User userData = FirebaseAuth.instance.currentUser;
    setState(() {
      user = userData;
    });
  }

  void openScan() async {
    String qrCode = await scanner.scan();
    _firestore.collection('kelas').where("qrcode",isEqualTo: qrCode).limit(1).snapshots().listen((data) {
        if (data.docs.isNotEmpty) saveClass(data.docs[0]['nama']);
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: size.height * 0.55,
            decoration: BoxDecoration(
              color: Colors.blue[600],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 70.0, horizontal: 20.0),
            child: Text(
              "${user.email} \nHave A Good Day",
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  .copyWith(fontWeight: FontWeight.w900, color: Colors.white),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 200.0, horizontal: 20.0),
            child: Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 0.85,
                children: <Widget>[
                  CategoryCard(
                    title: "Scan Class",
                    gambar: "images/qr.jpg",
                    press: () {
                      openScan();
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) => ScanClass()));
                    },
                  ),
                  CategoryCard(
                      title: "Agenda",
                      gambar: "images/cal.png",
                      press: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListAgenda()));
                      }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String gambar;
  final String title;
  final Function press;

  const CategoryCard({
    Key key,
    this.gambar,
    this.title,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(13),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(13),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 17),
                  blurRadius: 17,
                  spreadRadius: -23,
                  color: Colors.blue)
            ]),
        child: Material(
          color: Colors.transparent,
          child: RaisedButton(
            color: Colors.white,
            onPressed: press,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  Spacer(),
                  Image.asset(gambar),
                  Spacer(),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(fontSize: 23),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
