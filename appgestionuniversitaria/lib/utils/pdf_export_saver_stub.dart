import 'pdf_export_result.dart';

Future<PdfExportResult> savePdfBytes({
  required List<int> bytes,
  required String fileName,
}) async {
  throw UnsupportedError('La exportacion PDF no esta soportada en esta plataforma.');
}
