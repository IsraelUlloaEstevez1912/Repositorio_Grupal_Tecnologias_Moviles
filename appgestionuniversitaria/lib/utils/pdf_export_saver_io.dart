import 'dart:io';

import 'pdf_export_result.dart';

Future<PdfExportResult> savePdfBytes({
  required List<int> bytes,
  required String fileName,
}) async {
  final exportDirectory = await _resolveExportDirectory();
  await exportDirectory.create(recursive: true);

  final file = File(
    '${exportDirectory.path}${Platform.pathSeparator}$fileName',
  );

  await file.writeAsBytes(bytes, flush: true);

  return PdfExportResult(
    primaryMessage: 'El PDF se guardo correctamente en:',
    fallbackMessage: 'PDF guardado en: ${file.path}',
    path: file.path,
  );
}

Future<Directory> _resolveExportDirectory() async {
  if (Platform.isWindows) {
    final userProfile = Platform.environment['USERPROFILE'];
    if (userProfile != null && userProfile.isNotEmpty) {
      return Directory('$userProfile\\Downloads\\EduConnectReportes');
    }
  }

  if (Platform.isLinux || Platform.isMacOS) {
    final home = Platform.environment['HOME'];
    if (home != null && home.isNotEmpty) {
      return Directory(
        '$home${Platform.pathSeparator}Downloads${Platform.pathSeparator}EduConnectReportes',
      );
    }
  }

  return Directory(
    '${Directory.systemTemp.path}${Platform.pathSeparator}EduConnectReportes',
  );
}
