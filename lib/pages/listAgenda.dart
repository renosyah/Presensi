import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListAgenda extends StatefulWidget {
  @override
  _ListAgendaState createState() => _ListAgendaState();
}

class _ListAgendaState extends State<ListAgenda> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'List Agenda',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('agenda').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Text('Loading');
            } else {
              return Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                child: Card(
                  elevation: 2.0,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      List<Widget> widgets = [];
                      widgets.add(Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                            "Mata Kuliah : " +
                                snapshot.data.docs[index]['mata_kuliah'],
                            style: TextStyle(fontSize: 18.0)),
                      ));
                      widgets.add(Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                            "Kelas : " + snapshot.data.docs[index]['kelas'],
                            style: TextStyle(fontSize: 18.0)),
                      ));
                      widgets.add(Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                              "Jam : " + snapshot.data.docs[index]['jam'],
                              style: TextStyle(fontSize: 18.0))));
                      widgets.add(Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                            "Ruang : " + snapshot.data.docs[index]['ruang'],
                            style: TextStyle(fontSize: 18.0)),
                      ));
                      widgets.add(Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                            "Keterangan : " +
                                snapshot.data.docs[index]['keterangan'],
                            style: TextStyle(fontSize: 18.0)),
                      ));
                      widgets.add(
                        SizedBox(height: 20.0),
                      );
                      return Column(
                        children: widgets,
                      );
                    },
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
