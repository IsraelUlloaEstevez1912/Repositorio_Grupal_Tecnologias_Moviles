import 'pdf_export_result.dart';
import 'pdf_export_saver_stub.dart'
    if (dart.library.io) 'pdf_export_saver_io.dart'
    if (dart.library.html) 'pdf_export_saver_web.dart' as impl;

export 'pdf_export_result.dart';

Future<PdfExportResult> savePdfBytes({
  required List<int> bytes,
  required String fileName,
}) {
  return impl.savePdfBytes(bytes: bytes, fileName: fileName);
}
