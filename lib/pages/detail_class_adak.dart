import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:mypresensi/savefile/save_csv.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid/uuid.dart' as uuid;
import 'package:uuid/uuid_util.dart';

class DetailClassAdak extends StatefulWidget {

  String id,name;
  DetailClassAdak({Key key, @required this.id,@required this.name}) : super(key: key);

  @override
  _DetailClassAdakState createState() => _DetailClassAdakState(id : id,name: name);
}

class _DetailClassAdakState extends State<DetailClassAdak> {

  String id,name;
  _DetailClassAdakState({@required this.id,@required this.name});

  Stream<QuerySnapshot> _presensi;
  SaveCsv saveCsv;

  @override
  void initState() {
    super.initState();

    _presensi = FirebaseFirestore.instance
        .collection("presensi").where("id_class", isEqualTo: id)
        .snapshots();

    _presensi.listen((data) {
        if (data.docs.isNotEmpty){
          List<String> header = ['No','Id','Student Email','Attend At'];
          List<List<String>> body = [];

          int no = 1;
          for (DocumentSnapshot snap in data.docs) {
            body.add(["${no}","${snap.id}","${snap.data()['email']}","${snap.data()['presensi'].toDate()}"]);
            no++;
          }

          setState(() {
            saveCsv = new SaveCsv(fileName : 'rekap_presensi_${name}', header: header, body : body);
          });

        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Color.fromARGB(255, 32, 178, 170) ,
        title: Text(
          'Detail Class ${name}',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (saveCsv != null) {

            saveCsv.writeCSV();

            showDialog<void>(
              context: context,
              barrierDismissible: false, // user must tap button!
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('File Saved'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text('File document for ${name} hass been save in download folder'),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text('Ok'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              },
            );
          }
        },
        child: Icon(Icons.download_rounded),
        backgroundColor: Color.fromARGB(255, 32, 178, 170),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Center(),
              SizedBox(
                height: 20.0,
              ),
              Center(
                child: Text("List Present of class : ${name}"),
              ),
              Column(
                children: [
                  StreamBuilder<QuerySnapshot>(
                      stream: _presensi,
                      builder: (context, snapshot) {
                        List<DataRow> noItem = [];
                        if (snapshot.hasData){
                          int no = 1;
                          for (DocumentSnapshot snap in snapshot.data.docs) {
                            noItem.add(DataRow(
                                onSelectChanged: (bool selected) {
                                  if (selected) { }
                                },
                                cells: <DataCell>[
                                  DataCell(Text("${no}")),
                                  DataCell(Text("${snap.id}")),
                                  DataCell(Text("${snap.data()['email']}")),
                                  DataCell(Text("${snap.data()['presensi'].toDate()}")),
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
                                          'Student Email',
                                          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold))
                                  ),
                                  DataColumn(
                                      label: Text(
                                          'Attend At',
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
        ),
      ),
    );
  }
}
