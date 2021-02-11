import 'dart:developer';
import 'dart:io';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:open_file/open_file.dart' as op;

class SaveCsv {
  String fileName;
  List<String> header;
  List<List<String>> body;

  SaveCsv({this.fileName, this.header, this.body});

  Future<String> get _localPath async {
    final directory = File('/storage/emulated/0/Download'); //await path_provider.getExternalStorageDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/${fileName}.csv');
  }

  Future<void> writeCSV() async {
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

    file.writeAsString("${doc}",mode: FileMode.append, flush: true);
    //op.OpenFile.open('/storage/emulated/0/Download/');
  }
}