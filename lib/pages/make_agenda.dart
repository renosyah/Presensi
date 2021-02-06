import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MakeAgenda extends StatefulWidget {
  @override
  _MakeAgendaState createState() => _MakeAgendaState();
}

class _MakeAgendaState extends State<MakeAgenda> {
  var selectedCurrency, selectedType;

  String tokenString;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  TextEditingController jamController = TextEditingController();
  TextEditingController kelasController = TextEditingController();
  TextEditingController ruanganController = TextEditingController();
  TextEditingController keteranganController = TextEditingController();

  void validation() {
    if (kelasController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Kelas tidak boleh kosong."),
        ),
      );
      return;
    }

    if (ruanganController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Ruangan tidak boleh kosong."),
        ),
      );
      return;
    }
    if (jamController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Jam tidak boleh kosong.'),
        ),
      );
      return;
    }
    if (keteranganController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Keterangan tidak boleh kosong.'),
        ),
      );
      return;
    } else {
      sendAgenda();
    }
  }

  sendAgenda() async {
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

    final kelasRef = _firestore.collection('agenda').doc();

    if ((await kelasRef.get()).exists) {
      await kelasRef.update({
        'update_at': nowMs,
      });
    } else {
      await kelasRef.set({
        'mata_kuliah': selectedCurrency,
        'kelas': kelasController.text.trim(),
        'ruang': ruanganController.text.trim(),
        'jam': jamController.text.trim(),
        'keterangan': keteranganController.text.trim(),
        'created_at': nowMs,
        'updated_at': nowMs,
        'id': deviceId,
        'device info': deviceData,
      });
    }
    sendAndRetrieveMessage(_buildToken());
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) {
      _firebaseMessaging
          .requestNotificationPermissions(IosNotificationSettings());
    }
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
      print("onMessage: $message");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Buat Agenda',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 30.0),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Mata Kuliah',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                SizedBox(width: 3.0),
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("mataKuliah")
                        .snapshots()
                        .where((event) => false),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        Text("Loading.....");
                      else {
                        List<DropdownMenuItem> currencyItems = [];
                        for (int i = 0; i < snapshot.data.docs.length; i++) {
                          DocumentSnapshot snap = snapshot.data.docs[i];
                          currencyItems.add(
                            DropdownMenuItem(
                              child: Text(
                                snap.data()['mata_kuliah'],
                                style: TextStyle(fontSize: 18.0),
                              ),
                              value: "${snap.data()['mata_kuliah']}",
                            ),
                          );
                        }
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(width: 50.0),
                            DropdownButton(
                              items: currencyItems,
                              onChanged: (currencyValue) {
                                final snackBar = SnackBar(
                                  content: Text(
                                    'Mata kuliah yang dipilih $currencyValue',
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                                setState(() {
                                  selectedCurrency = currencyValue;
                                });
                              },
                              value: selectedCurrency,
                              isExpanded: false,
                              hint: new Text(
                                "Pilih",
                                style: TextStyle(fontSize: 18.0),
                              ),
                            ),
                          ],
                        );
                      }
                      return Container();
                    }),
                TextFormField(
                  controller: kelasController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: 'Kelas',
                  ),
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: ruanganController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: 'Ruang',
                  ),
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: jamController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: 'Jam',
                  ),
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: keteranganController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: 'Keterangan',
                  ),
                  style: TextStyle(fontSize: 18),
                  maxLines: 10,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.bottomRight,
                  child: RaisedButton(
                    onPressed: () {
                      sendAgenda();

                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => ListAgenda()));
                    },
                    child: Text(
                      'Kirim',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ),
                // Container(
                //   alignment: Alignment.bottomRight,
                //   child: RaisedButton(
                //     onPressed: () {
                //       _buildToken();
                //       Text(
                //         'Token',
                //         style: TextStyle(fontSize: 18.0),
                //       );
                //     },
                //   ),
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }

  final String serverToken =
      "AAAApY4cpIY:APA91bFavpyqZvVkKOHXueG_oggJ43ouWqueATXuOI1fzN0M6Uds2e8lCGVF4ZiV0GAl_IOxr7jxMdZjMVcwOFsGOS-DK9VRW-kVumz_H-LPU25AWi2dgwpn-smnqN_uGUV7IEjX03vW";

  Future<Map<String, dynamic>> sendAndRetrieveMessage(Widget token) async {
    await http.post('https://fcm.googleapis.com/fcm/send',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverToken'
        },
        body: jsonEncode(<String, dynamic>{
          'notification': <String, dynamic>{
            'body': "mata kuliah: $selectedCurrency \nkelas: " +
                kelasController.text +
                "\njam:" +
                jamController.text +
                "\nruang:" +
                ruanganController.text +
                "\nketerangan:" +
                keteranganController.text,
            'title': "PEMBERITAHUAN",
          },
          'to':
              'eExlxDYQQfOA4iTSy8jIoM:APA91bFR-b8IgtLeNMA99__xbfC6h-t6RkLGTxuIAXBaDISNTXbA5sSOARKxCor2OIb6Fns8elcqjIDQBHOdnyZnCRa2Kb0xNM_64Q7_TCafC6NA8xiAalJiaVSLgvy6WFgoyNV50u7O',
        }));
    jamController.text = '';
    ruanganController.text = '';
    keteranganController.text = '';
    kelasController.text = '';
    final Completer<Map<String, dynamic>> completer =
        Completer<Map<String, dynamic>>();

    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
      completer.complete(message);
    });
    return completer.future;
  }

  Widget _buildToken() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("userDatas").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            Text("Loading.....");
          else {
            List<Widget> widgets = [];
            for (int i = 0; i < snapshot.data.docs.length; i++) {
              DocumentSnapshot shot = snapshot.data.docs[i];
              widgets.add(
                Text(tokenString = shot.data()['token']),
              );
            }
          }
          return Container();
        });
  }
}
