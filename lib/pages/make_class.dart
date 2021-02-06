import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MakeClass extends StatefulWidget {
  MakeClass({Key key}) : super(key: key);

  @override
  _MakeClassState createState() => _MakeClassState();
}

class _MakeClassState extends State<MakeClass> {
  TextEditingController _classController = TextEditingController();

  String data;
  String qrData = "No Data Found";
  bool hasdata = false;

  createClass() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

    String deviceId;

    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    Map<String, dynamic> deviceData;

    if (Platform.isAndroid) {
      final deviceInfo = await deviceInfoPlugin.androidInfo;

      deviceId = deviceInfo.androidId;
      deviceData = {
        'device': deviceInfo.device,
        'os_version': deviceInfo.version.sdkInt.toString(),
        'model': deviceInfo.model,
        'platform': 'android',
      };
    }
    if (Platform.isIOS) {
      final deviceInfo = await deviceInfoPlugin.iosInfo;

      deviceId = deviceInfo.identifierForVendor;
      deviceData = {
        'device': deviceInfo.name,
        'os_version': deviceInfo.systemVersion,
        'model': deviceInfo.model,
        'platform': 'ios',
      };
    }

    final nowMs = DateTime.now();

    final kelasRef = _firestore.collection('mataKuliah').doc();

    if ((await kelasRef.get()).exists) {
      await kelasRef.update({
        'update_at': nowMs,
      });
    } else {
      await kelasRef.set({
        'mata_kuliah': data,
        'created_at': nowMs,
        'updated_at': nowMs,
        'id': deviceId,
        'device info': deviceData,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Make Class',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: 50.0),
              Center(
                child: QrImage(
                  data: '$data',
                  version: QrVersions.auto,
                  size: 200.0,
                  gapless: false,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Flexible(
              //       child: Text(
              //         'Link  : ${(qrData)}',
              //         textAlign: TextAlign.center,
              //         style: TextStyle(fontSize: 20.0),
              //       ),
              //     ),
              //     IconButton(
              //         icon: Icon(Icons.launch_outlined),
              //         onPressed: hasdata
              //             ? () async {
              //                 if (await canLaunch(qrData)) {
              //                   await launch(qrData);
              //                 } else {
              //                   throw "Couldn't launch";
              //                 }
              //               }
              //             : null)
              //   ],
              // ),
              Container(
                height: 50.0,
                width: 350.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(100),
                  ),
                  color: Colors.white,
                ),
                child: Center(
                  child: ListTile(
                    title: Container(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: TextFormField(
                        controller: _classController,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          icon: Container(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Icon(
                              Icons.vpn_key,
                              color: Colors.black,
                            ),
                          ),
                          hintText: 'Enter Class',
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                margin: EdgeInsets.only(bottom: 50.0),
                height: 70.0,
                width: 150.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  color: Color.fromRGBO(255, 144, 39, 1.0),
                ),
                child: FlatButton(
                    onPressed: () {
                      setState(() {
                        data = _classController.text;
                        createClass();
                      });
                    },
                    child: Text('Create')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
