import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
                            cells: <DataCell>[
                              DataCell(Text("${no}")),
                              DataCell(Container(
                                height: 200,
                                width: 200,
                                child: QrImage(
                                  data:"${snap.data()['qrcode']}",
                                  version: QrVersions.auto,
                                  size: 200.0,
                                  gapless: false,
                                ),
                              )),
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
                            child: DataTable(dataRowHeight: 200, columns: <DataColumn>[
                              DataColumn(
                                  label: Text(
                                      'No',
                                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold))
                              ),
                              DataColumn(
                                  label: Text(
                                      'QrCode',
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
