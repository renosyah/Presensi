import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mypresensi/kelas/kelas.dart';
import 'package:mypresensi/notification/notification.dart';
import 'package:mypresensi/pages/listAgenda.dart';
import 'package:mypresensi/pages/scan_class.dart';
import 'package:mypresensi/session/session.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class HomePageMahasiswa extends StatefulWidget {
  @override
  _HomePageMahasiswaState createState() => _HomePageMahasiswaState();
}

class _HomePageMahasiswaState extends State<HomePageMahasiswa> {

  //User user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;


  //---------------------------------revisi--------------------------------------//
  // - data presensi diambil/validasi/update dari collection kelas (ok)
  // - pada saat scan, check jika id mahasiswa ada di kelas/pertemuan makul (ok)
  // - jika tidak ada, tampilkan alert dialog, 'anda tidak mengambil kelas ini' (ok)
  // - update status mahasiswa di kelas/pertemuan makul dari hadir = false => hadir true (ok)


  // fungsi menyimpan presensi
  // dengan id class dan nama kelas/makul
  updatePresensiKelas(String userId, QueryDocumentSnapshot kelasSnapshot) async {

    var userDatas = await FirebaseFirestore.instance
        .collection("userDatas")
        .doc(userId)
        .get();

    if (!userDatas.exists){
      return;
    }

    Kelas kelas = Kelas.fromJson(kelasSnapshot.data());

    int pos = 0;
    bool exist = false;
    for (int i=0;i<kelas.mahasiswa.length;i++){
        if (kelas.mahasiswa[i].nim == userDatas.data()['nim']){
          exist = true;
          break;
        }
        pos++;
    }

    if (!exist){
      Scaffold.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mahasiswa tidak terdaftar di matakuliah ini!'),
        ),
      );
      return;
    }

    kelas.mahasiswa[pos].hadir = true;
    kelas.mahasiswa[pos].waktu = DateTime.now().toString();

    await _firestore.collection('kelas').doc(kelasSnapshot.id).update(kelas.toJson());

    // memanggil fungsi untuk push notifikasi
   await new NotificationRequest().push(
        new NotificationRequestData(
          apiKey: "AAAApY4cpIY:APA91bFavpyqZvVkKOHXueG_oggJ43ouWqueATXuOI1fzN0M6Uds2e8lCGVF4ZiV0GAl_IOxr7jxMdZjMVcwOFsGOS-DK9VRW-kVumz_H-LPU25AWi2dgwpn-smnqN_uGUV7IEjX03vW",
          topic: "events",
          notification: new NotificationPayload(
              title: "Presensi",
              body: "${userDatas.data()['nim']} has made a presence in ${kelasSnapshot.data()['makul']}"
          ),
          data: new NotificationPayload(
            title: "Presensi",
            body: "${userDatas.data()['nim']} has made a presence in ${kelasSnapshot.data()['makul']}"
          )
        )
    );
  }


  // deklarasi funsi untuk scan qrcode
  void openScan() async {
    String qrCode = await scanner.scan();

    // cari kelas berdasarkan qrcode
    FirebaseFirestore.instance
        .collection("kelas")
        .where("qr_code", isEqualTo: qrCode)
        .limit(1)
        .get().then((data){
            SessionManager().load().then((value){
              if (data.docs.isNotEmpty) updatePresensiKelas(value.id, data.docs[0]);
            });
        });
  }

  //-----------------------------------------------------------------------//




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
            child: FutureBuilder<UserSession>(
              future: SessionManager().load(),
              builder: (context,snapshot){
                if (snapshot.hasData){
                  return Text(
                    "${snapshot.data.email} \nHave A Good Day",
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        .copyWith(fontWeight: FontWeight.w900, color: Colors.white),
                  );
                }
                return Text(
                  "Have A Good Day",
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .copyWith(fontWeight: FontWeight.w900, color: Colors.white),
                );
              },
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

                      // memanggil fungsi open scan
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
