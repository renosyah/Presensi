import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mypresensi/pages/detail_class.dart';

// ini adalah kelas yang digunakan untuk menampilkan list kelas
// yang dimana saat salah satu itek diklik
// maka akan dinavigasikan ke detail kelas
class ListClass extends StatefulWidget{
  @override
  _ListClassState createState() => _ListClassState();
}

class _ListClassState extends State<ListClass> {

  Stream<QuerySnapshot> _kelas;

  @override
  void initState() {
    super.initState();

    _kelas = FirebaseFirestore.instance
        .collection("kelas")
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: ListView(
        children: <Widget>[
          Column(
            children: [
                StreamBuilder<QuerySnapshot>(
                  stream: _kelas,
                  builder: (context, snapshot) {
                    List<DataRow> noItem = [];
                    if (snapshot.hasData){
                      log("${snapshot.data.docs.toString()}");
                      int no = 1;
                      for (DocumentSnapshot snap in snapshot.data.docs) {
                        noItem.add(DataRow(
                            onSelectChanged: (bool selected) {
                              if (selected) {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => DetailClass(qrCode:"${snap.data()['qrcode']}")));
                              }
                            },
                            cells: <DataCell>[
                              DataCell(Text("${no}")),
                              DataCell(Text("${snap.id}")),
                              DataCell(Text("${snap.data()['nama']}")),
                            ])
                        );
                        no++;
                      }
                    }
                    return SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(showCheckboxColumn : false,columns: <DataColumn>[
                              DataColumn(
                                  label: Text(
                                      'No',
                                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold))
                              ),
                              DataColumn(
                                  label: Text(
                                      ' Id',
                                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold))
                              ),
                              DataColumn(
                                  label: Text(
                                      'Name',
                                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold))
                              ),
                            ],rows: noItem)
                        )
                    );
                  }
              )
            ],
          )
        ],
      ),
    );
  }
}
