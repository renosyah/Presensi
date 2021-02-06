import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mypresensi/pages/token.dart';
import 'package:qrscan/qrscan.dart' as scanner;


class ScanClass extends StatefulWidget {
  @override
  _ScanClassState createState() => _ScanClassState();
}

class _ScanClassState extends State<ScanClass> {
  String text = '';

  User user;
  Future<void> getUserData() async {
    User userData = FirebaseAuth.instance.currentUser;
    setState(() {
      user = userData;
    });
  }

  saveClass() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

    String deviceId;

    FirebaseFirestore _firestore = FirebaseFirestore.instance;
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
    }
    if (Platform.isIOS) {
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
        'mata_kuliah': text,
        'email': '${user.email}',
        'presensi': nowMs,
        'id': deviceId,
        'device info': deviceData,
      });
    }
    await Token.updateToken();
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Scan Class',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text),
            SizedBox(height: 20.0),
            RaisedButton(
              onPressed: () async {
                text = await scanner.scan();
                saveClass();
              },
              child: Text('Scan'),
            )
          ],
        ),
      ),
    );
  }
}
