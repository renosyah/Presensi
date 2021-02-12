import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mypresensi/notification/notification.dart';
import 'package:uuid/uuid.dart' as uuid;
import 'package:uuid/uuid_util.dart';

// ini adalah kelas yang digunakan untuk membuta kelas baru
// yg akan ditampilkan di list kelas dan akan discan oleh mahasiswa
class MakeClass extends StatefulWidget {
  MakeClass({Key key}) : super(key: key);

  @override
  _MakeClassState createState() => _MakeClassState();
}

class _MakeClassState extends State<MakeClass> {
  TextEditingController _classController = TextEditingController();

  String _className;
  String _qrCode;

  @override
  void initState() {
    super.initState();

    // membuat uuid untuk qrcode kelas
    _qrCode = uuid.Uuid().v4(options: {'rng': UuidUtil.cryptoRNG});
  }

  // fungsi untuk membuat kelas
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
    } else  if (Platform.isIOS) {
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
    final kelasRef = _firestore.collection('kelas').doc();

    await kelasRef.set({
      'nama' : _className,
      'qrcode' : _qrCode,
      'created_at': nowMs,
      'updated_at': nowMs,
      'id': deviceId,
      'device info': deviceData,
    });

    // memanagil fungsi push notifkasi
    await new NotificationRequest().push(
        new NotificationRequestData(
            apiKey: "AAAApY4cpIY:APA91bFavpyqZvVkKOHXueG_oggJ43ouWqueATXuOI1fzN0M6Uds2e8lCGVF4ZiV0GAl_IOxr7jxMdZjMVcwOFsGOS-DK9VRW-kVumz_H-LPU25AWi2dgwpn-smnqN_uGUV7IEjX03vW",
            topic: "events",
            notification: new NotificationPayload(
                title: "New Class",
                body: "${_className} has been created"
            ),
            data: new NotificationPayload(
                title: "New Class",
                body: "${_className} has been created"
            )
        )
    );

    // hancurkan halaman
    // kembali ke menu sebelumnya
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      SystemNavigator.pop();
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
                child: Image.asset('images/class.png'),
              ),
              SizedBox(
                height: 20.0,
              ),
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
                          hintText: 'Class Name',
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
                        _className = _classController.text;
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
