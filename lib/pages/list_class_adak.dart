import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mypresensi/pages/detail_class_adak.dart';

class ListClassAdak extends StatefulWidget {
  @override
  _ListClassAdakState createState() => _ListClassAdakState();
}

class _ListClassAdakState extends State<ListClassAdak> {

  Stream<QuerySnapshot>  _kelas;

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
                      int no = 1;
                      for (DocumentSnapshot snap in snapshot.data.docs) {
                        noItem.add(DataRow(
                            onSelectChanged: (bool selected) {
                              if (selected) {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => DetailClassAdak(id : snap.id,name: snap.data()['nama'],)));
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
                              )
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
