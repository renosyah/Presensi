import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid/uuid.dart' as uuid;
import 'package:uuid/uuid_util.dart';

class DetailClass extends StatefulWidget {

  String qrCode;
  DetailClass({Key key, @required this.qrCode}) : super(key: key);

  @override
  _DetailClassState createState() => _DetailClassState(qrCode: qrCode);
}

class _DetailClassState extends State<DetailClass> {

  String qrCode;
  _DetailClassState({@required this.qrCode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail Class',
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
                  data:"${qrCode}",
                  version: QrVersions.auto,
                  size: 200.0,
                  gapless: false,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Center(
                child: Text("Scan this QRcode to present"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
