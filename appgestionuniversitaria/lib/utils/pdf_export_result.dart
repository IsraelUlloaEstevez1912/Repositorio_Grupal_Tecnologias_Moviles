class PdfExportResult {
  const PdfExportResult({
    required this.primaryMessage,
    required this.fallbackMessage,
    this.path,
    this.downloadedInBrowser = false,
  });

  final String primaryMessage;
  final String fallbackMessage;
  final String? path;
  final bool downloadedInBrowser;

  String successMessage(String desktopMessage) {
    if (downloadedInBrowser) {
      return 'Descarga del PDF iniciada en el navegador.';
    }

    return desktopMessage;
  }
}
