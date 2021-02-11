import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListPresensi extends StatefulWidget {
  @override
  _ListPresensiState createState() => _ListPresensiState();
}

class _ListPresensiState extends State<ListPresensi> {

  Stream<QuerySnapshot> _presensi;

  @override
  void initState() {
    super.initState();

    _presensi  = FirebaseFirestore.instance
        .collection("presensi")
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
                  stream: _presensi,
                  builder: (context, snapshot) {
                    List<DataRow> noItem = [];
                    if (snapshot.hasData){
                      log("${snapshot.data.docs.toString()}");
                      int no = 1;
                      for (DocumentSnapshot snap in snapshot.data.docs) {
                        noItem.add(DataRow(
                            onSelectChanged: (bool selected) {
                              if (selected) {

                              }
                            },
                            cells: <DataCell>[
                              DataCell(Text("${no}")),
                              DataCell(Text("${snap.id}")),
                              DataCell(Text("${snap.data()['mata_kuliah']}")),
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
                                      'Class Name',
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
