import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListClassAdak extends StatefulWidget {
  @override
  _ListClassAdakState createState() => _ListClassAdakState();
}

class _ListClassAdakState extends State<ListClassAdak> {

  Stream<QuerySnapshot> _presensi,_makul;
  var _selectedMakul;

  @override
  void initState() {
    super.initState();
    _presensi = FirebaseFirestore.instance
        .collection('presensi')
        .snapshots();

    _makul = FirebaseFirestore.instance
        .collection("mataKuliah")
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
              // Align(
              //   child: Text(
              //     "Pilih Mata Kuliah",
              //     style: TextStyle(fontSize: 18.0),
              //   ),
              //   alignment: Alignment.topLeft,
              // ),
              // Align(
              //   alignment: Alignment.topLeft,
              //   child: StreamBuilder<QuerySnapshot>(
              //       stream: _makul,
              //       builder: (context, snapshot) {
              //         if (!snapshot.hasData)
              //           Text("Loading.....");
              //         else {
              //           List<DropdownMenuItem> currencyItems = [];
              //           for (int i = 0; i < snapshot.data.docs.length; i++) {
              //             DocumentSnapshot snap = snapshot.data.docs[i];
              //             currencyItems.add(
              //               DropdownMenuItem(
              //                 child: Text(
              //                   snap.data()['mata_kuliah'],
              //                   style: TextStyle(fontSize: 18.0),
              //                 ),
              //                 value: "${snap.id}",
              //               ),
              //             );
              //           }
              //           return Column(
              //             mainAxisAlignment: MainAxisAlignment.start,
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: <Widget>[
              //               SizedBox(width: 50.0),
              //               DropdownButton(
              //                 items: currencyItems,
              //                 onChanged: (value) {
              //                   setState(() {
              //                     _selectedMakul = value;
              //                   });
              //                 },
              //                 value: _selectedMakul,
              //                 isExpanded: false,
              //                 hint: new Text(
              //                   "Pilih",
              //                   style: TextStyle(fontSize: 18.0),
              //                 ),
              //               ),
              //             ],
              //           );
              //         }
              //         return Container();
              //       }),
              // ),
              StreamBuilder<QuerySnapshot>(
                  stream: _presensi,
                  builder: (context, snapshot) {
                    List<DataRow> noItem = [];
                    if (snapshot.hasData){
                      log("${snapshot.data.docs.toString()}");
                      int no = 1;
                      for (DocumentSnapshot snap in snapshot.data.docs) {
                        noItem.add(DataRow(
                            cells: <DataCell>[
                              DataCell(Text("${no}")),
                              DataCell(Text("${snap.id}")),
                              DataCell(Text("${snap.data()['presensi'].toDate()}")),
                              DataCell(Text("${snap.data()['mata_kuliah']}"))
                            ])
                        );
                        no++;
                      }
                    }
                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(columns: <DataColumn>[
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
                              'Waktu',
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
