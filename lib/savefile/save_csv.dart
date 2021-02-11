import 'dart:io';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:open_file/open_file.dart' as op;
import 'package:excel/excel.dart';

class SaveCsv {
  String fileName;
  List<String> header;
  List<List<String>> body;

  SaveCsv({this.fileName, this.header, this.body});

  Future<String> get _localPath async {
    final directory = File('/storage/emulated/0/Download/'); // await path_provider.getExternalStorageDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/${fileName}.xlsx');
  }

  Future<void> writeCSV() async {
    write().then((file) async {
      String path = file.path;
      await op.OpenFile.open(path);
    });
  }


  Future<File> write() async {
    final file = await _localFile;

    if (file.existsSync()){
      file.deleteSync(recursive: true);
    }

    String doc = "";
    String h = header.join(', ');
    doc += "${h}\n";

    for (var b in body){
        String sb = b.join(', ');
        doc += "${sb}\n";
    }
    await file.writeAsString("${doc}",mode: FileMode.append, flush: true);

    return file;
  }
}


class SaveExcel {
  String fileName;
  List<String> header;
  List<List<String>> body;

  SaveExcel({this.fileName, this.header, this.body});

  Future<String> get _localPath async {
    final directory = File('/storage/emulated/0/Download/'); // await path_provider.getExternalStorageDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/${fileName}.xlsx');
  }

  Future<void> writeExcel() async {
    write().then((file) async {
      String path = file.path;
      await op.OpenFile.open(path);
    });
  }


  Future<File> write() async {
    final file = await _localFile;

    if (file.existsSync()){
      file.deleteSync(recursive: true);
    }

    var excel = Excel.createExcel();
    var sheet = excel['Sheet1'];

    List<List<String>> list = List.generate(body.length + 1, (index) => List.generate(header.length , (index1) => '$index $index1'));
    list.forEach((row) {
      sheet.appendRow(row);
    });

    for (int i = 0; i < header.length; i++) {
      sheet.row(0)[i].value = header[i];
    }

    for (int i = 0;i < body.length; i++) {
      for (int o = 0; o < body[i].length; o++) {
        sheet.row(i + 1)[o].value = body[i][o];
      }
    }

    excel.encode().then((onValue) {
      file
        ..createSync(recursive: true)
        ..writeAsBytesSync(onValue);
    });

    return file;
  }
}