import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mypresensi/kelas/kelas.dart';

// ini adalah kelas yang digunakan untuk menampilkan list presensi
// yang telah dihadiri oleh mahasiswa
class ListPresensi extends StatefulWidget {
  @override
  _ListPresensiState createState() => _ListPresensiState();
}

class _ListPresensiState extends State<ListPresensi> {

  //---------------------------------revisi--------------------------------------//
  // - data presensi diambil dari collection kelas (ok)

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
                      int no = 1;
                      for (DocumentSnapshot snap in snapshot.data.docs) {
                        Kelas kelas = Kelas.fromJson(snap.data());
                        int jumlah_hadir = 0;
                        int jumlah_tidak_hadir = 0;

                        for (Mahasiswa m in kelas.mahasiswa){
                          if (m.hadir){
                            jumlah_hadir++;
                          } else {
                            jumlah_tidak_hadir++;
                          }
                        }

                        noItem.add(DataRow(
                            onSelectChanged: (bool selected) {
                              if (selected) { }
                            },
                            cells: <DataCell>[
                              DataCell(Text("${no}")),
                              DataCell(Text("${kelas.pertemuan}")),
                              DataCell(Text("${kelas.makul}")),
                              DataCell(Text("${jumlah_hadir}")),
                              DataCell(Text("${jumlah_tidak_hadir}")),
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
                                      'Pertemuan',
                                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold))
                              ),
                              DataColumn(
                                  label: Text(
                                      'Matakuliah',
                                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold))
                              ),
                              DataColumn(
                                  label: Text(
                                      'Hadir',
                                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold))
                              ),
                              DataColumn(
                                  label: Text(
                                      'Tidak Hadir',
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

//-----------------------------------------------------------------------//