import 'dart:io';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:open_file/open_file.dart' as op;
import 'package:excel/excel.dart';


// ini adalah class yang memiliki
// fungsi menyimpan ke dalam file
// excel
class SaveExcel {

  // nama file
  String fileName;

  // title
  String title;

  // sub title
  String subtitle;

  // nama kolom
  List<String> header;

  // isi dokumen
  List<List<String>> body;

  // title
  String end_title;

  // sub title
  String end_subtitle;

  SaveExcel({this.fileName, this.title, this.subtitle, this.header, this.body, this.end_title, this.end_subtitle});

  // mengambil alamat lokasi penyimpanan
  Future<String> get _localPath async {
    final directory = File('/storage/emulated/0/Download/'); // await path_provider.getExternalStorageDirectory();
    return directory.path;
  }

  // membuat file
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/${fileName}.xlsx');
  }

  // tuliskan ke dalam format excel
  Future<void> writeExcel() async {
    final file = await _localFile;

    // jika ada, hapus dulu
    if (file.existsSync()){ file.deleteSync(recursive: true); }

    // memanggil fungsi untuk mengisi file
    // dengan data excel
    write().then((onValue) {
      file
        ..createSync(recursive: true)
        ..writeAsBytesSync(onValue);

      String path = file.path;

      // membuka file excel yang telah dibuat
      op.OpenFile.open(path);
    });
  }

  // fungsi untuk mengisi file excel
  Future<List<int>> write() async {

    // buat instance excel
    var excel = Excel.createExcel();
    var sheet = excel['Sheet1'];
    int title_offset = 2;
    int header_offset = 1;

    int offset = title_offset + header_offset;

    // generate cell
    List<List<String>> list = List.generate(offset + body.length + 2, (index) => List.generate(header.length , (index1) => ''));
    list.forEach((row) { sheet.appendRow(row); });

    // isi baris pertama dengan title
    sheet.row(0)[0].value = title;

    // isi baris kedua dengan sub
    sheet.row(1)[0].value = subtitle;

    // isi baris pertama dengan nama kolom
    for (int i = 0; i < header.length; i++) {
      sheet.row(title_offset)[i].value = header[i];
    }


    // dan sisanya dengan data dari body
    for (int i = 0;i < body.length; i++) {
      for (int o = 0; o < body[i].length; o++) {
        sheet.row(offset + i)[o].value = body[i][o];
      }
    }

    int end_set = offset + body.length;

    // isi baris terahir dengan title
    sheet.row(0 + end_set)[0].value = end_title;

    // isi baris terahir dengan sub
    sheet.row(1 + end_set)[0].value = end_subtitle;

    // encode ke format excel
    return excel.encode();
  }
}