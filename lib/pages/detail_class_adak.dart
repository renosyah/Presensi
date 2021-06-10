import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mypresensi/kelas/kelas.dart';
import 'package:mypresensi/savefile/save_csv.dart';

// ini adalah kelas yang digunakan untuk menampilkan list
// presensi yang akan dicetak oleh adak
class DetailClassAdak extends StatefulWidget {

  Kelas kelas;
  DetailClassAdak({Key key, @required this.kelas}) : super(key: key);

  @override
  _DetailClassAdakState createState() => _DetailClassAdakState(kelas: kelas);
}

class _DetailClassAdakState extends State<DetailClassAdak> {

  Kelas kelas;
  _DetailClassAdakState({@required this.kelas});

  List<DataRow> _noItem = [];
  SaveExcel _saveExcel;

  @override
  void initState() {
    super.initState();

    //---------------------------------revisi--------------------------------------//
    // - data presensi diambil dari collection kelas (ok)
    // - tambah judul makul dan pertemuan (ok)
    // - format header dan data kehadiran no, nim, nama, status, tanggal (ok)
    // - tambah jumlah hadir dan tidak hadir (ok)


      List<String> header = ['No','Nim','Nama','Status','Waktu'];
      List<List<String>> body = [];
      int jumlah_hadir = 0;
      int jumlah_tidak_hadir = 0;

      for (Mahasiswa m in kelas.mahasiswa){
        if (m.hadir){
          jumlah_hadir++;
        } else {
          jumlah_tidak_hadir++;
        }
      }

      int no = 1;
      for (Mahasiswa m in kelas.mahasiswa) {
        body.add(["${no}","${m.nim}","${m.nama}","${ m.hadir ? "Hadir" : "tidak hadir" }","${m.waktu}"]);
        no++;
      }

      setState(() {
        _saveExcel = new SaveExcel(
            fileName : 'rekap_presensi_${kelas.makul} pertemuan ${kelas.pertemuan}',
            title: kelas.makul,
            subtitle: "Pertemuan : ${kelas.pertemuan}",
            header: header,
            body : body,
            end_title: "Jumlah Hadir : ${jumlah_hadir}",
            end_subtitle: "Jumlah Tidak Hadir : ${jumlah_tidak_hadir}"
        );
      });

      no = 1;
      for (Mahasiswa m in kelas.mahasiswa) {
        _noItem.add(DataRow(
            onSelectChanged: (bool selected) {
              if (selected) { }
            },
            cells: <DataCell>[
              DataCell(Text("${no}")),
              DataCell(Text("${m.nim}")),
              DataCell(Text("${m.nama}")),
              DataCell(Text("${ m.hadir ? "Hadir ": "tidak hadir" }")),
              DataCell(Text("${m.waktu}"))
            ])
        );
        no++;
      }
    }

    //-----------------------------------------------------------------------//


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Color.fromARGB(255, 32, 178, 170) ,
        title: Text(
          '${kelas.makul} Pertemuan : ${kelas.pertemuan}',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_saveExcel != null) {
            _saveExcel.writeExcel();
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
                child: Text("List Present of : ${kelas.makul}"),
              ),
              Column(
                children: [
                  SingleChildScrollView(
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
                                'Nim',
                                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold))
                        ),
                        DataColumn(
                            label: Text(
                                'Nama',
                                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold))
                        ),
                        DataColumn(
                            label: Text(
                                'Status',
                                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold))
                        ),
                        DataColumn(
                            label: Text(
                                'Waktu',
                                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold))
                        )
                      ],rows: _noItem)
                    )
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
