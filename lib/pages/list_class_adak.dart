import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListClassAdak extends StatefulWidget {
  @override
  _ListClassAdakState createState() => _ListClassAdakState();
}

class _ListClassAdakState extends State<ListClassAdak> {
  var selectedCurrency, selectedType;
  String waktu;
  int n = 15;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: ListView(
        children: <Widget>[
          Column(
            children: [
              Align(
                child: Text(
                  "Pilih Mata Kuliah",
                  style: TextStyle(fontSize: 18.0),
                ),
                alignment: Alignment.topLeft,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("mataKuliah")
                        .snapshots(),
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
                                // final snackBar = SnackBar(
                                //   content: Text(
                                //     'Mata kuliah yang dipilih $currencyValue',
                                //     style: TextStyle(fontSize: 18.0),
                                //   ),
                                // );
                                // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                log('log : Mata kuliah yang dipilih $currencyValue');
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
              ),
              DataTable(columns: <DataColumn>[
                DataColumn(
                    label: Text(
                  'No',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                )),
                DataColumn(
                    label: Text(
                  'Waktu',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                )),
                DataColumn(
                    label: Text(
                  'Hadir',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                )),
                DataColumn(
                    label: Text(
                  'Alpha',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                )),
                DataColumn(
                    label: Text(
                  'Izin',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                )),
              ], rows: <DataRow>[
                DataRow(cells: <DataCell>[
                  DataCell(
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('presensi')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          Text("Loading.....");
                        else {
                          List<Widget> noItem = [];
                          for (int i = 1; i < snapshot.data.docs.length; i++) {
                            DocumentSnapshot snap = snapshot.data.docs[i];
                            noItem.add(Text(snap.data()[i]));
                          }
                        }
                        return Container();
                      },
                    ),
                  ),
                ])
              ]),
            ],
          )
        ],
      ),
    );
  }
}
