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

  // nama kolom
  List<String> header;

  // isi dokumen
  List<List<String>> body;

  SaveExcel({this.fileName, this.header, this.body});

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

    // generate cell
    List<List<String>> list = List.generate(body.length + 1, (index) => List.generate(header.length , (index1) => '$index $index1'));
    list.forEach((row) { sheet.appendRow(row); });

    // isi baris pertama dengan nama kolom
    for (int i = 0; i < header.length; i++) {
      sheet.row(0)[i].value = header[i];
    }

    // dan sisanya dengan data dari body
    for (int i = 0;i < body.length; i++) {
      for (int o = 0; o < body[i].length; o++) {
        sheet.row(i + 1)[o].value = body[i][o];
      }
    }

    // encode ke format excel
    return excel.encode();
  }
}