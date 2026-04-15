// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:html' as html;

import 'pdf_export_result.dart';

Future<PdfExportResult> savePdfBytes({
  required List<int> bytes,
  required String fileName,
}) async {
  final blob = html.Blob(<Object>[bytes], 'application/pdf');
  final url = html.Url.createObjectUrlFromBlob(blob);

  final anchor = html.AnchorElement(href: url)
    ..download = fileName
    ..style.display = 'none';

  html.document.body?.children.add(anchor);
  anchor.click();
  anchor.remove();
  html.Url.revokeObjectUrl(url);

  return const PdfExportResult(
    primaryMessage: 'La descarga del PDF se inicio en el navegador.',
    fallbackMessage: 'La descarga del PDF se inicio en el navegador.',
    downloadedInBrowser: true,
  );
}
