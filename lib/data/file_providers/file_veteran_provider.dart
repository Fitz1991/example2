import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:veterans/model/veterans/veteran.dart';

class FileVeteranProvider {
  File file;

  Stream<File> savePdf(Veteran veteran) async* {
    if (await Permission.storage.request().isGranted) {
      Directory documentDirectory = await getTemporaryDirectory();

      String documentPath = documentDirectory.path;

      if (await File("$documentPath/${veteran.fio}.pdf").exists())
        await File("$documentPath/${veteran.fio}.pdf").delete();

      file = File("$documentPath/${veteran.fio}.pdf");

      file.writeAsBytesSync(veteran.pdfFile);
      yield file;
    }
  }
}
