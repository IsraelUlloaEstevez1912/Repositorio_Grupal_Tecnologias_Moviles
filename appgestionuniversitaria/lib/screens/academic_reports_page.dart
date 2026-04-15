import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../utils/pdf_export_saver.dart';
import '../widgets/app_bottom_nav.dart';

class AcademicReportsPage extends StatefulWidget {
  const AcademicReportsPage({super.key, this.userRole = 'estudiante'});

  final String userRole;

  @override
  State<AcademicReportsPage> createState() => _AcademicReportsPageState();
}

class _AcademicReportsPageState extends State<AcademicReportsPage> {
  ReportPeriod _selectedPeriod = ReportPeriod.month;
  final List<_ReportActivityEntry> _recentActivity = <_ReportActivityEntry>[];
  bool _isExporting = false;

  bool get _isTeacher => widget.userRole == 'docente';
  bool get _isAdmin => widget.userRole == 'admin';

  String get _title {
    if (_isAdmin) {
      return 'Reportes Institucionales';
    }

    if (_isTeacher) {
      return 'Reportes Docentes';
    }

    return 'Reportes Academicos';
  }

  String get _summaryTag {
    if (_isAdmin) {
      return 'Vision institucional';
    }

    if (_isTeacher) {
      return 'Seguimiento docente';
    }

    return 'Seguimiento academico';
  }

  String get _summarySubtitle {
    switch (_selectedPeriod) {
      case ReportPeriod.week:
        return 'Corte semanal listo para revisar, compartir o exportar.';
      case ReportPeriod.month:
        return 'Consolida los indicadores mas importantes del mes actual.';
      case ReportPeriod.semester:
        return 'Agrupa avances clave para el cierre del semestre.';
    }
  }

  List<Widget> _buildOverviewCards() {
    if (_isAdmin) {
      return const [
        InstitutionalOverviewCard(),
        SizedBox(height: 16),
        FacultyCapacityCard(),
        SizedBox(height: 16),
        OperationsAlertsCard(),
      ];
    }

    if (_isTeacher) {
      return const [
        TeachingOverviewCard(),
        SizedBox(height: 16),
        SectionPerformanceCard(),
        SizedBox(height: 16),
        PendingReviewsCard(),
      ];
    }

    return const [
      PerformanceCard(),
      SizedBox(height: 16),
      EnrollmentCard(),
      SizedBox(height: 16),
      StudentPensumCard(),
    ];
  }

  List<_ReportTemplateData> get _templates =>
      _reportTemplatesForRole(widget.userRole, _selectedPeriod);

  void _showSnack(String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  String _formatTimestamp(DateTime value) {
    final localizations = MaterialLocalizations.of(context);
    return '${localizations.formatShortDate(value)} '
        '${localizations.formatTimeOfDay(
          TimeOfDay.fromDateTime(value),
          alwaysUse24HourFormat: true,
        )}';
  }

  String get _roleDisplayName {
    if (_isAdmin) {
      return 'Administrador';
    }

    if (_isTeacher) {
      return 'Docente';
    }

    return 'Estudiante';
  }

  String _slugify(String value) {
    return value
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
  }

  PdfColor _pdfColor(Color color) {
    return PdfColor(
      color.r,
      color.g,
      color.b,
    );
  }

  Future<List<int>> _buildPdfBytes({
    required String documentTitle,
    required List<_ReportTemplateData> templates,
    required DateTime generatedAt,
  }) async {
    final pdf = pw.Document();
    final generatedLabel = _formatTimestamp(generatedAt);
    final readyCount = templates.where((template) => template.status == 'Listo').length;
    final attentionCount = templates.length - readyCount;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(20),
            decoration: pw.BoxDecoration(
              color: PdfColor.fromHex('#1F63F2'),
              borderRadius: pw.BorderRadius.circular(18),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  documentTitle,
                  style: pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  'Rol: $_roleDisplayName  |  Periodo: ${_selectedPeriod.label}  |  Generado: $generatedLabel',
                  style: const pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 11,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  _summarySubtitle,
                  style: pw.TextStyle(
                    color: PdfColor(1, 1, 1, 0.92),
                    fontSize: 12,
                    lineSpacing: 3,
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 18),
          pw.Row(
            children: [
              pw.Expanded(
                child: _buildPdfStatCard(
                  label: 'Reportes incluidos',
                  value: '${templates.length}',
                  tone: PdfColor.fromHex('#1F63F2'),
                ),
              ),
              pw.SizedBox(width: 12),
              pw.Expanded(
                child: _buildPdfStatCard(
                  label: 'Listos',
                  value: '$readyCount',
                  tone: PdfColor.fromHex('#10B981'),
                ),
              ),
              pw.SizedBox(width: 12),
              pw.Expanded(
                child: _buildPdfStatCard(
                  label: 'Con seguimiento',
                  value: '$attentionCount',
                  tone: PdfColor.fromHex('#F59E0B'),
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 22),
          pw.Text(
            'Resumen del corte',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          ...templates.map((template) => _buildPdfTemplateCard(template)),
        ],
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildPdfStatCard({
    required String label,
    required String value,
    required PdfColor tone,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(14),
      decoration: pw.BoxDecoration(
        color: PdfColor.fromHex('#F8FAFE'),
        border: pw.Border.all(color: tone, width: 1.2),
        borderRadius: pw.BorderRadius.circular(14),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              color: PdfColor.fromHex('#64748B'),
              fontSize: 10,
            ),
          ),
          pw.SizedBox(height: 6),
          pw.Text(
            value,
            style: pw.TextStyle(
              color: tone,
              fontSize: 22,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildPdfTemplateCard(_ReportTemplateData template) {
    final tone = _pdfColor(template.tone);

    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 12),
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        border: pw.Border.all(color: PdfColor.fromHex('#D9E2F1')),
        borderRadius: pw.BorderRadius.circular(16),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      template.title,
                      style: pw.TextStyle(
                        fontSize: 15,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text(
                      template.subtitle,
                      style: pw.TextStyle(
                        fontSize: 11,
                        color: PdfColor.fromHex('#64748B'),
                        lineSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(width: 12),
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: pw.BoxDecoration(
                  color: tone,
                  borderRadius: pw.BorderRadius.circular(10),
                ),
                child: pw.Text(
                  template.status,
                  style: pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 10),
          ...template.details.map(
            (detail) => pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 6),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Container(
                    width: 6,
                    height: 6,
                    margin: const pw.EdgeInsets.only(top: 5),
                    decoration: pw.BoxDecoration(
                      color: tone,
                      shape: pw.BoxShape.circle,
                    ),
                  ),
                  pw.SizedBox(width: 8),
                  pw.Expanded(
                    child: pw.Text(
                      detail,
                      style: const pw.TextStyle(fontSize: 11, lineSpacing: 2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<PdfExportResult> _savePdfFile({
    required String baseName,
    required String documentTitle,
    required List<_ReportTemplateData> templates,
  }) async {
    final generatedAt = DateTime.now();
    final safeName = _slugify(baseName).isEmpty ? 'reporte' : _slugify(baseName);
    final fileName =
        '${safeName}_${generatedAt.year.toString().padLeft(4, '0')}'
        '${generatedAt.month.toString().padLeft(2, '0')}'
        '${generatedAt.day.toString().padLeft(2, '0')}_'
        '${generatedAt.hour.toString().padLeft(2, '0')}'
        '${generatedAt.minute.toString().padLeft(2, '0')}'
        '${generatedAt.second.toString().padLeft(2, '0')}.pdf';

    final bytes = await _buildPdfBytes(
      documentTitle: documentTitle,
      templates: templates,
      generatedAt: generatedAt,
    );

    return savePdfBytes(bytes: bytes, fileName: fileName);
  }

  Future<void> _showExportDialog({
    required String title,
    required PdfExportResult result,
  }) async {
    if (!mounted) {
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(result.primaryMessage),
                const SizedBox(height: 10),
                if (result.path != null)
                  SelectableText(
                    result.path!,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
              ],
            ),
          ),
          actions: [
            if (result.path != null)
              TextButton(
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: result.path!));
                  if (dialogContext.mounted) {
                    Navigator.of(dialogContext).pop();
                  }
                  _showSnack('Ruta copiada al portapapeles.');
                },
                child: const Text('Copiar ruta'),
              ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleSuccessfulExport({
    required PdfExportResult result,
    required String dialogTitle,
    required String successMessage,
  }) async {
    _showSnack(successMessage);

    try {
      await _showExportDialog(title: dialogTitle, result: result);
    } catch (error, stackTrace) {
      debugPrint('No se pudo abrir el dialogo de exportacion: $error');
      debugPrintStack(stackTrace: stackTrace);
      _showSnack(result.fallbackMessage);
    }
  }

  void _registerActivity({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color tone,
  }) {
    final now = DateTime.now();
    final timestamp = _formatTimestamp(now);

    setState(() {
      _recentActivity.insert(
        0,
        _ReportActivityEntry(
          title: title,
          subtitle: subtitle,
          timestamp: timestamp,
          icon: icon,
          tone: tone,
        ),
      );

      if (_recentActivity.length > 4) {
        _recentActivity.removeLast();
      }
    });
  }

  Future<void> _generateSummary() async {
    if (_isExporting) {
      return;
    }

    setState(() {
      _isExporting = true;
    });

    try {
      final result = await _savePdfFile(
        baseName: 'resumen_${widget.userRole}_${_selectedPeriod.name}',
        documentTitle: 'Resumen de ${_title.toLowerCase()}',
        templates: _templates,
      );

      _registerActivity(
        title: 'Resumen ${_selectedPeriod.label.toLowerCase()} exportado',
        subtitle: 'Se genero un PDF real con el consolidado del modulo.',
        icon: Icons.picture_as_pdf_outlined,
        tone: const Color(0xFF10B981),
      );

      await _handleSuccessfulExport(
        result: result,
        dialogTitle: 'Resumen exportado',
        successMessage: result.successMessage('Resumen guardado en PDF correctamente.'),
      );
    } catch (error, stackTrace) {
      debugPrint('Error exportando resumen PDF: $error');
      debugPrintStack(stackTrace: stackTrace);
      _showSnack('No se pudo generar el resumen en PDF.');
    } finally {
      if (mounted) {
        setState(() {
          _isExporting = false;
        });
      }
    }
  }

  Future<void> _exportTemplate(_ReportTemplateData template) async {
    if (_isExporting) {
      return;
    }

    setState(() {
      _isExporting = true;
    });

    try {
      final result = await _savePdfFile(
        baseName: template.title,
        documentTitle: template.title,
        templates: [template],
      );

      _registerActivity(
        title: '${template.title} exportado',
        subtitle: 'Se guardo un PDF con el corte activo del reporte.',
        icon: Icons.picture_as_pdf_outlined,
        tone: const Color(0xFF10B981),
      );

      await _handleSuccessfulExport(
        result: result,
        dialogTitle: 'Reporte exportado',
        successMessage: result.successMessage(
          'PDF guardado para "${template.title}".',
        ),
      );
    } catch (error, stackTrace) {
      debugPrint('Error exportando "${template.title}" en PDF: $error');
      debugPrintStack(stackTrace: stackTrace);
      _showSnack('No se pudo exportar "${template.title}" en PDF.');
    } finally {
      if (mounted) {
        setState(() {
          _isExporting = false;
        });
      }
    }
  }

  void _showTemplateDetail(_ReportTemplateData template) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => _ReportDetailSheet(
        template: template,
        periodLabel: _selectedPeriod.label,
        onExport: () {
          Navigator.of(sheetContext).pop();
          _exportTemplate(template);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final history = <_ReportActivityEntry>[
      ..._recentActivity,
      ..._seedActivityForRole(widget.userRole),
    ].take(6).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2F4F7),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text(
          _title,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 2,
        userRole: widget.userRole,
        isRootDestination: false,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _ReportsControlCard(
              title: _title,
              roleLabel: _summaryTag,
              subtitle: _summarySubtitle,
              selectedPeriod: _selectedPeriod,
              isExporting: _isExporting,
              onPeriodChanged: (period) {
                setState(() {
                  _selectedPeriod = period;
                });
              },
              onGeneratePressed: _generateSummary,
            ),
            const SizedBox(height: 16),
            ..._buildOverviewCards(),
            const SizedBox(height: 20),
            const _ReportSectionHeading(
              title: 'Reportes disponibles',
              subtitle: 'Abrir detalle o exportar segun el corte seleccionado.',
            ),
            const SizedBox(height: 12),
            ..._templates.map(
              (template) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ReportActionCard(
                  template: template,
                  isExporting: _isExporting,
                  onDetails: () => _showTemplateDetail(template),
                  onExport: () => _exportTemplate(template),
                ),
              ),
            ),
            const SizedBox(height: 18),
            const _ReportSectionHeading(
              title: 'Actividad reciente',
              subtitle: 'Se guarda lo ultimo generado dentro del modulo.',
            ),
            const SizedBox(height: 12),
            ...history.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _ReportHistoryTile(entry: entry),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PerformanceCard extends StatelessWidget {
  const PerformanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: cardStyle(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rendimiento Estudiantil',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Tendencia de promedio general',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  '+2.4%',
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            '3.62',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const Text(
            'Promedio semestre actual',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BarItem(height: 60, label: 'SEM 1'),
              BarItem(height: 80, label: 'SEM 2'),
              BarItem(height: 50, label: 'SEM 3'),
              BarItem(height: 100, label: 'SEM 4', highlight: true),
            ],
          ),
        ],
      ),
    );
  }
}

class BarItem extends StatelessWidget {
  const BarItem({
    super.key,
    required this.height,
    required this.label,
    this.highlight = false,
  });

  final double height;
  final String label;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 30,
          height: height,
          decoration: BoxDecoration(
            color: highlight ? Colors.blue : Colors.blue.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontSize: 10)),
      ],
    );
  }
}

class EnrollmentCard extends StatelessWidget {
  const EnrollmentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: cardStyle(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Distribucion de Matriculas',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text('TOTAL', style: TextStyle(color: Colors.grey)),
              Text(
                '12.4k',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LegendItem('Pregrado (65%)', Colors.blue),
              LegendItem('Posgrado (20%)', Colors.blueAccent),
              LegendItem('Doctorado (15%)', Colors.lightBlue),
            ],
          ),
        ],
      ),
    );
  }
}

class LegendItem extends StatelessWidget {
  const LegendItem(this.text, this.color, {super.key});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          CircleAvatar(radius: 5, backgroundColor: color),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }
}

class FacultyCard extends StatelessWidget {
  const FacultyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: cardStyle(),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Distribucion Docente',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          FacultyItem('Facultad STEM', '142 miembros', 0.8),
          FacultyItem('Artes y Humanidades', '86 miembros', 0.5),
          FacultyItem('Escuela de Negocios', '64 miembros', 0.4),
        ],
      ),
    );
  }
}

class FacultyItem extends StatelessWidget {
  const FacultyItem(this.title, this.subtitle, this.progress, {super.key});

  final String title;
  final String subtitle;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          const Icon(Icons.school, color: Colors.blue),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(subtitle, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          SizedBox(
            width: 80,
            child: LinearProgressIndicator(
              value: progress,
              color: Colors.blue,
              backgroundColor: Colors.grey[300],
            ),
          ),
        ],
      ),
    );
  }
}

class StudentPensumCard extends StatelessWidget {
  const StudentPensumCard({super.key});

  @override
  Widget build(BuildContext context) {
    final courses = _studentPensumCourses();
    final completed = courses
        .where((course) => course.status == _PensumCourseStatus.completed)
        .length;
    final inProgress = courses
        .where((course) => course.status == _PensumCourseStatus.inProgress)
        .length;
    final pending = courses
        .where((course) => course.status == _PensumCourseStatus.pending)
        .length;
    final progress = completed / courses.length;

    final groupedCourses = <int, List<_PensumCourseData>>{};
    for (final course in courses) {
      groupedCourses.putIfAbsent(course.cycle, () => <_PensumCourseData>[]).add(course);
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: cardStyle(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pensum de Ingenieria en Software',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Consulta cuantas materias has completado y cuales te faltan.',
                      style: TextStyle(color: Color(0xFF6B7280), height: 1.35),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F0FF),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '$completed/${courses.length} dadas',
                  style: const TextStyle(
                    color: Color(0xFF1F63F2),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 11,
              color: const Color(0xFF1F63F2),
              backgroundColor: const Color(0xFFE5EDFF),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _PensumStatTile(
                  label: 'Dadas',
                  value: '$completed',
                  tone: const Color(0xFF10B981),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _PensumStatTile(
                  label: 'En curso',
                  value: '$inProgress',
                  tone: const Color(0xFF1F63F2),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _PensumStatTile(
                  label: 'Pendientes',
                  value: '$pending',
                  tone: const Color(0xFFF59E0B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ...groupedCourses.entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ciclo ${entry.key}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF172033),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...entry.value.map(
                    (course) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _PensumCourseTile(course: course),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PensumStatTile extends StatelessWidget {
  const _PensumStatTile({
    required this.label,
    required this.value,
    required this.tone,
  });

  final String label;
  final String value;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: tone.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: tone,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _PensumCourseTile extends StatelessWidget {
  const _PensumCourseTile({required this.course});

  final _PensumCourseData course;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFE),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: course.status.color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(course.status.icon, color: course.status.color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF172033),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${course.code} · ${course.credits} creditos',
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: course.status.color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              course.status.label,
              style: TextStyle(
                color: course.status.color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InstitutionalOverviewCard extends StatelessWidget {
  const InstitutionalOverviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: cardStyle(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vista Institucional',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Estado general de operacion academica y matricula',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F0FF),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'Estable',
                  style: TextStyle(
                    color: Color(0xFF1D4ED8),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ReportStatChip(
                icon: Icons.school_outlined,
                label: 'Programas activos',
                value: '18',
              ),
              ReportStatChip(
                icon: Icons.groups_2_outlined,
                label: 'Docentes asignados',
                value: '85',
              ),
              ReportStatChip(
                icon: Icons.how_to_reg_outlined,
                label: 'Matriculas confirmadas',
                value: '1,240',
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Text(
            '72%',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Avance del ciclo operativo del semestre',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: const LinearProgressIndicator(
              value: 0.72,
              minHeight: 12,
              color: Color(0xFF1F63F2),
              backgroundColor: Color(0xFFE5EDFF),
            ),
          ),
        ],
      ),
    );
  }
}

class FacultyCapacityCard extends StatelessWidget {
  const FacultyCapacityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: cardStyle(),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Capacidad por Facultad',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            'Demanda academica y asignacion de recursos',
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: 18),
          SectionProgressItem(
            title: 'Ingenieria',
            subtitle: 'Ocupacion actual 94%',
            progress: 0.94,
            color: Color(0xFF1F63F2),
          ),
          SectionProgressItem(
            title: 'Salud',
            subtitle: 'Ocupacion actual 81%',
            progress: 0.81,
            color: Color(0xFF10B981),
          ),
          SectionProgressItem(
            title: 'Humanidades',
            subtitle: 'Ocupacion actual 68%',
            progress: 0.68,
            color: Color(0xFFF59E0B),
          ),
        ],
      ),
    );
  }
}

class OperationsAlertsCard extends StatelessWidget {
  const OperationsAlertsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: cardStyle(),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Alertas Operativas',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            'Puntos que requieren seguimiento administrativo',
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: 18),
          PendingReviewTile(
            icon: Icons.warning_amber_rounded,
            title: '3 secciones superan la capacidad sugerida',
            subtitle: 'Requieren apertura adicional antes del cierre',
            tone: Color(0xFFF59E0B),
          ),
          PendingReviewTile(
            icon: Icons.receipt_long_outlined,
            title: '12 cargos de matricula en validacion',
            subtitle: 'Pendientes de conciliacion financiera',
            tone: Color(0xFF1F63F2),
          ),
          PendingReviewTile(
            icon: Icons.approval_outlined,
            title: '4 planes de estudio esperan aprobacion',
            subtitle: 'Comite curricular de esta semana',
            tone: Color(0xFF7C3AED),
          ),
        ],
      ),
    );
  }
}

class TeachingOverviewCard extends StatelessWidget {
  const TeachingOverviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: cardStyle(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Seguimiento Docente',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Resumen semanal de clases, asistencia y notas',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F0FF),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  '92% cumplimiento',
                  style: TextStyle(
                    color: Color(0xFF1D4ED8),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            '24',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Evaluaciones registradas esta semana',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 18),
          const Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ReportStatChip(
                icon: Icons.calendar_today_outlined,
                label: 'Clases hoy',
                value: '4',
              ),
              ReportStatChip(
                icon: Icons.groups_2_outlined,
                label: 'Estudiantes activos',
                value: '114',
              ),
              ReportStatChip(
                icon: Icons.fact_check_outlined,
                label: 'Notas pendientes',
                value: '18',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SectionPerformanceCard extends StatelessWidget {
  const SectionPerformanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: cardStyle(),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rendimiento por Seccion',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            'Promedio actual y progreso de cada grupo',
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: 18),
          SectionProgressItem(
            title: 'CS204 · SEC-02',
            subtitle: 'Promedio general 91%',
            progress: 0.91,
            color: Color(0xFF1F63F2),
          ),
          SectionProgressItem(
            title: 'MAT210 · SEC-01',
            subtitle: 'Promedio general 86%',
            progress: 0.86,
            color: Color(0xFF10B981),
          ),
          SectionProgressItem(
            title: 'FIS110 · LAB-03',
            subtitle: 'Promedio general 78%',
            progress: 0.78,
            color: Color(0xFFF59E0B),
          ),
        ],
      ),
    );
  }
}

class PendingReviewsCard extends StatelessWidget {
  const PendingReviewsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: cardStyle(),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pendientes de Revision',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            'Tareas y acciones que necesitan seguimiento',
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: 18),
          PendingReviewTile(
            icon: Icons.edit_note_rounded,
            title: 'Ensayo final por retroalimentar',
            subtitle: 'HUM115 · 8 entregas sin comentario',
            tone: Color(0xFFF59E0B),
          ),
          PendingReviewTile(
            icon: Icons.assignment_turned_in_outlined,
            title: 'Registrar notas parciales',
            subtitle: 'CS204 · faltan 5 calificaciones',
            tone: Color(0xFF1F63F2),
          ),
          PendingReviewTile(
            icon: Icons.how_to_reg_outlined,
            title: 'Cerrar asistencia del laboratorio',
            subtitle: 'FIS110 · sesion de hoy 01:00 PM',
            tone: Color(0xFF10B981),
          ),
        ],
      ),
    );
  }
}

class ReportStatChip extends StatelessWidget {
  const ReportStatChip({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FB),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF64748B)),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SectionProgressItem extends StatelessWidget {
  const SectionProgressItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.color,
  });

  final String title;
  final String subtitle;
  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              color: color,
              backgroundColor: color.withValues(alpha: 0.16),
            ),
          ),
        ],
      ),
    );
  }
}

class PendingReviewTile extends StatelessWidget {
  const PendingReviewTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.tone,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: tone.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: tone),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum ReportPeriod { week, month, semester }

extension ReportPeriodExtension on ReportPeriod {
  String get label => switch (this) {
    ReportPeriod.week => 'Semana',
    ReportPeriod.month => 'Mes',
    ReportPeriod.semester => 'Semestre',
  };

  String get contextLabel => switch (this) {
    ReportPeriod.week => 'de la semana',
    ReportPeriod.month => 'del mes',
    ReportPeriod.semester => 'del semestre',
  };
}

class _ReportTemplateData {
  const _ReportTemplateData({
    required this.title,
    required this.subtitle,
    required this.status,
    required this.icon,
    required this.tone,
    required this.details,
  });

  final String title;
  final String subtitle;
  final String status;
  final IconData icon;
  final Color tone;
  final List<String> details;
}

class _ReportActivityEntry {
  const _ReportActivityEntry({
    required this.title,
    required this.subtitle,
    required this.timestamp,
    required this.icon,
    required this.tone,
  });

  final String title;
  final String subtitle;
  final String timestamp;
  final IconData icon;
  final Color tone;
}

enum _PensumCourseStatus { completed, inProgress, pending }

extension _PensumCourseStatusExtension on _PensumCourseStatus {
  String get label => switch (this) {
    _PensumCourseStatus.completed => 'Dada',
    _PensumCourseStatus.inProgress => 'Cursando',
    _PensumCourseStatus.pending => 'Pendiente',
  };

  String get reportTag => switch (this) {
    _PensumCourseStatus.completed => 'DADA',
    _PensumCourseStatus.inProgress => 'CURSANDO',
    _PensumCourseStatus.pending => 'PENDIENTE',
  };

  Color get color => switch (this) {
    _PensumCourseStatus.completed => const Color(0xFF10B981),
    _PensumCourseStatus.inProgress => const Color(0xFF1F63F2),
    _PensumCourseStatus.pending => const Color(0xFFF59E0B),
  };

  IconData get icon => switch (this) {
    _PensumCourseStatus.completed => Icons.check_circle_outline_rounded,
    _PensumCourseStatus.inProgress => Icons.schedule_outlined,
    _PensumCourseStatus.pending => Icons.radio_button_unchecked_rounded,
  };
}

class _PensumCourseData {
  const _PensumCourseData({
    required this.code,
    required this.name,
    required this.credits,
    required this.cycle,
    required this.status,
  });

  final String code;
  final String name;
  final int credits;
  final int cycle;
  final _PensumCourseStatus status;
}

class _ReportSectionHeading extends StatelessWidget {
  const _ReportSectionHeading({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF172033),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(color: Color(0xFF6B7280), height: 1.35),
        ),
      ],
    );
  }
}

class _ReportsControlCard extends StatelessWidget {
  const _ReportsControlCard({
    required this.title,
    required this.roleLabel,
    required this.subtitle,
    required this.selectedPeriod,
    required this.isExporting,
    required this.onPeriodChanged,
    required this.onGeneratePressed,
  });

  final String title;
  final String roleLabel;
  final String subtitle;
  final ReportPeriod selectedPeriod;
  final bool isExporting;
  final ValueChanged<ReportPeriod> onPeriodChanged;
  final VoidCallback onGeneratePressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0D4FE0), Color(0xFF4BA2FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1F63F2).withValues(alpha: 0.18),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              roleLabel,
              style: const TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Color.fromARGB(255, 236, 236, 236),
              height: 1.1,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.92),
              height: 1.45,
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: ReportPeriod.values
                .map(
                  (period) => ChoiceChip(
                    label: Text(period.label),
                    selected: period == selectedPeriod,
                    onSelected: isExporting ? null : (_) => onPeriodChanged(period),
                    selectedColor: Colors.white,
                    backgroundColor: Colors.white.withValues(alpha: 0.16),
                    side: BorderSide(
                      color: Colors.white.withValues(alpha: 0.22),
                    ),
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF1F63F2),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            ),
            onPressed: isExporting ? null : onGeneratePressed,
            icon: Icon(
              isExporting
                  ? Icons.hourglass_top_rounded
                  : Icons.download_for_offline_outlined,
            ),
            label: Text(isExporting ? 'Generando PDF...' : 'Generar resumen'),
          ),
        ],
      ),
    );
  }
}

class _ReportActionCard extends StatelessWidget {
  const _ReportActionCard({
    required this.template,
    required this.isExporting,
    required this.onDetails,
    required this.onExport,
  });

  final _ReportTemplateData template;
  final bool isExporting;
  final VoidCallback onDetails;
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: cardStyle(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: template.tone.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(template.icon, color: template.tone),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      template.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF172033),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      template.subtitle,
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _ReportStatusPill(status: template.status, tone: template.tone),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: template.details
                .take(2)
                .map(
                  (detail) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F7FB),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      detail,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF475569),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              TextButton.icon(
                onPressed: isExporting ? null : onDetails,
                icon: const Icon(Icons.visibility_outlined),
                label: const Text('Detalle'),
              ),
              FilledButton.icon(
                onPressed: isExporting ? null : onExport,
                icon: Icon(
                  isExporting ? Icons.hourglass_top_rounded : Icons.download_outlined,
                ),
                label: Text(isExporting ? 'Generando...' : 'Exportar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReportStatusPill extends StatelessWidget {
  const _ReportStatusPill({required this.status, required this.tone});

  final String status;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: tone.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: tone,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ReportHistoryTile extends StatelessWidget {
  const _ReportHistoryTile({required this.entry});

  final _ReportActivityEntry entry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: cardStyle(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: entry.tone.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(entry.icon, color: entry.tone),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF172033),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  entry.subtitle,
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            entry.timestamp,
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportDetailSheet extends StatelessWidget {
  const _ReportDetailSheet({
    required this.template,
    required this.periodLabel,
    required this.onExport,
  });

  final _ReportTemplateData template;
  final String periodLabel;
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.82,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 48,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9E1F2),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: template.tone.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(template.icon, color: template.tone),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            template.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF172033),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            template.subtitle,
                            style: const TextStyle(
                              color: Color(0xFF6B7280),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    _ReportStatusPill(status: template.status, tone: template.tone),
                  ],
                ),
                const SizedBox(height: 18),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFE),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Periodo activo: $periodLabel',
                    style: const TextStyle(
                      color: Color(0xFF172033),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Puntos clave',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF172033),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView(
                    children: template.details
                        .map(
                          (detail) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  margin: const EdgeInsets.only(top: 6),
                                  decoration: BoxDecoration(
                                    color: template.tone,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    detail,
                                    style: const TextStyle(
                                      color: Color(0xFF475569),
                                      height: 1.45,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: onExport,
                  icon: const Icon(Icons.download_outlined),
                  label: const Text('Exportar este reporte'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

List<_ReportTemplateData> _reportTemplatesForRole(
  String userRole,
  ReportPeriod period,
) {
  final periodLabel = period.label.toLowerCase();

  if (userRole == 'admin') {
    return [
      _ReportTemplateData(
        title: 'Panorama institucional',
        subtitle: 'Programas activos, matriculas y estado general de operacion.',
        status: 'Listo',
        icon: Icons.dashboard_outlined,
        tone: Color(0xFF1F63F2),
        details: [
          '18 programas activos sin interrupciones',
          'La matricula sigue creciendo en el corte actual',
          'La operacion academica se mantiene estable',
        ],
      ),
      _ReportTemplateData(
        title: 'Capacidad por facultad',
        subtitle: 'Demanda, ocupacion y tension operativa por area.',
        status: 'Atencion',
        icon: Icons.domain_verification_outlined,
        tone: Color(0xFFF59E0B),
        details: [
          'Ingenieria y Salud concentran la mayor demanda',
          'Humanidades conserva margen disponible',
          'Conviene revisar redistribucion de carga docente',
        ],
      ),
      _ReportTemplateData(
        title: 'Alertas operativas',
        subtitle: 'Sobrecupo, validaciones financieras y aprobaciones pendientes.',
        status: 'Atencion',
        icon: Icons.notification_important_outlined,
        tone: Color(0xFFEF4444),
        details: [
          'Persisten validaciones de matricula por cerrar',
          'Hay secciones por encima de la capacidad sugerida',
          'Este corte corresponde al $periodLabel activo',
        ],
      ),
    ];
  }

  if (userRole == 'docente') {
    return [
      _ReportTemplateData(
        title: 'Desempeno por seccion',
        subtitle: 'Promedio, participacion y avances por grupo activo.',
        status: 'Listo',
        icon: Icons.class_outlined,
        tone: Color(0xFF1F63F2),
        details: [
          'CS204 encabeza el rendimiento actual',
          'MAT210 mantiene una tendencia estable',
          'FIS110 necesita refuerzo en practicas',
        ],
      ),
      _ReportTemplateData(
        title: 'Seguimiento de evaluaciones',
        subtitle: 'Entregas calificadas, pendientes y retroalimentacion emitida.',
        status: 'Atencion',
        icon: Icons.rate_review_outlined,
        tone: Color(0xFFF59E0B),
        details: [
          'Todavia quedan entregas sin comentario final',
          'El mayor atraso esta en proyectos finales',
          'Se recomienda cerrar primero lo mas proximo a vencer',
        ],
      ),
      _ReportTemplateData(
        title: 'Asistencia por curso',
        subtitle: 'Cruce de asistencia del estudiantado con cada clase impartida.',
        status: 'Listo',
        icon: Icons.co_present_outlined,
        tone: Color(0xFF10B981),
        details: [
          'La mayoria de los grupos supera el 90% de asistencia',
          'Una seccion necesita seguimiento cercano',
          'Este corte corresponde al $periodLabel activo',
        ],
      ),
    ];
  }

  return [
    _ReportTemplateData(
      title: 'Rendimiento por asignatura',
      subtitle: 'Notas recientes y promedio por materia activa.',
      status: 'Listo',
      icon: Icons.bar_chart_outlined,
      tone: Color(0xFF1F63F2),
      details: [
        'Calculo Diferencial lidera el rendimiento',
        'Programacion Movil mantiene un buen promedio',
        'Hay una materia que necesita refuerzo en quices',
      ],
    ),
    _ReportTemplateData(
      title: 'Asistencia consolidada',
      subtitle: 'Presencia, tardanzas y ausencias por clase registrada.',
      status: 'Listo',
      icon: Icons.how_to_reg_outlined,
      tone: Color(0xFF10B981),
      details: [
        'La asistencia sigue en rango saludable',
        'Solo hay una tardanza relevante registrada',
        'No existen bloqueos por ausencias acumuladas',
      ],
    ),
    _ReportTemplateData(
      title: 'Avance del pensum',
      subtitle: 'Seguimiento de materias aprobadas, en curso y pendientes.',
      status: 'Listo',
      icon: Icons.menu_book_outlined,
      tone: Color(0xFF7C3AED),
      details: _studentPensumReportDetails(periodLabel),
    ),
    _ReportTemplateData(
      title: 'Estado de matricula',
      subtitle: 'Pagos, cargos pendientes y validaciones del periodo.',
      status: 'Atencion',
      icon: Icons.account_balance_wallet_outlined,
      tone: Color(0xFFF59E0B),
      details: [
        'El pago principal fue conciliado correctamente',
        'Todavia queda un cargo pendiente por revisar',
        'Este corte corresponde al $periodLabel activo',
      ],
    ),
  ];
}

List<_ReportActivityEntry> _seedActivityForRole(String userRole) {
  if (userRole == 'admin') {
    return const [
      _ReportActivityEntry(
        title: 'Nuevo corte institucional disponible',
        subtitle: 'Se actualizaron matriculas y carga academica.',
        timestamp: '15/04/2026 09:00',
        icon: Icons.public_outlined,
        tone: Color(0xFF1F63F2),
      ),
      _ReportActivityEntry(
        title: 'Demanda alta detectada en Ingenieria',
        subtitle: 'La ocupacion docente se acerco al limite definido.',
        timestamp: '14/04/2026 17:25',
        icon: Icons.trending_up_outlined,
        tone: Color(0xFFF59E0B),
      ),
    ];
  }

  if (userRole == 'docente') {
    return const [
      _ReportActivityEntry(
        title: 'Se sincronizaron las notas de la semana',
        subtitle: 'CS204 y MAT210 ya reflejan el nuevo corte.',
        timestamp: '15/04/2026 09:05',
        icon: Icons.sync_alt_outlined,
        tone: Color(0xFF1F63F2),
      ),
      _ReportActivityEntry(
        title: 'Quedo una revision docente pendiente',
        subtitle: 'HUM115 aun tiene entregas sin comentario final.',
        timestamp: '14/04/2026 17:40',
        icon: Icons.edit_note_outlined,
        tone: Color(0xFFF59E0B),
      ),
    ];
  }

  return const [
    _ReportActivityEntry(
      title: 'Nueva nota incorporada al promedio general',
      subtitle: 'Calculo Diferencial actualizo el ultimo corte.',
      timestamp: '15/04/2026 09:10',
      icon: Icons.grade_outlined,
      tone: Color(0xFF1F63F2),
    ),
    _ReportActivityEntry(
      title: 'Matricula marcada con seguimiento',
      subtitle: 'Se detecto un cargo pendiente en laboratorio.',
      timestamp: '14/04/2026 16:20',
      icon: Icons.priority_high_rounded,
      tone: Color(0xFFF59E0B),
    ),
  ];
}

List<_PensumCourseData> _studentPensumCourses() {
  return const [
    _PensumCourseData(
      code: 'INF101',
      name: 'Introduccion a la Programacion',
      credits: 4,
      cycle: 1,
      status: _PensumCourseStatus.completed,
    ),
    _PensumCourseData(
      code: 'MAT110',
      name: 'Matematica Basica',
      credits: 4,
      cycle: 1,
      status: _PensumCourseStatus.completed,
    ),
    _PensumCourseData(
      code: 'ING105',
      name: 'Comunicacion Tecnica',
      credits: 3,
      cycle: 1,
      status: _PensumCourseStatus.completed,
    ),
    _PensumCourseData(
      code: 'INF201',
      name: 'Programacion Orientada a Objetos',
      credits: 4,
      cycle: 2,
      status: _PensumCourseStatus.completed,
    ),
    _PensumCourseData(
      code: 'MAT220',
      name: 'Calculo para Software',
      credits: 4,
      cycle: 2,
      status: _PensumCourseStatus.completed,
    ),
    _PensumCourseData(
      code: 'BD210',
      name: 'Bases de Datos I',
      credits: 4,
      cycle: 2,
      status: _PensumCourseStatus.completed,
    ),
    _PensumCourseData(
      code: 'INF310',
      name: 'Estructura de Datos',
      credits: 4,
      cycle: 3,
      status: _PensumCourseStatus.completed,
    ),
    _PensumCourseData(
      code: 'RED320',
      name: 'Redes de Computadores',
      credits: 3,
      cycle: 3,
      status: _PensumCourseStatus.completed,
    ),
    _PensumCourseData(
      code: 'MOV330',
      name: 'Desarrollo de Aplicaciones Moviles',
      credits: 4,
      cycle: 3,
      status: _PensumCourseStatus.inProgress,
    ),
    _PensumCourseData(
      code: 'WEB340',
      name: 'Desarrollo Web Avanzado',
      credits: 4,
      cycle: 4,
      status: _PensumCourseStatus.inProgress,
    ),
    _PensumCourseData(
      code: 'SEG410',
      name: 'Seguridad de Software',
      credits: 3,
      cycle: 4,
      status: _PensumCourseStatus.pending,
    ),
    _PensumCourseData(
      code: 'PRY420',
      name: 'Proyecto Final de Grado',
      credits: 5,
      cycle: 4,
      status: _PensumCourseStatus.pending,
    ),
  ];
}

int _studentPensumCompletedCount() {
  return _studentPensumCourses()
      .where((course) => course.status == _PensumCourseStatus.completed)
      .length;
}

int _studentPensumInProgressCount() {
  return _studentPensumCourses()
      .where((course) => course.status == _PensumCourseStatus.inProgress)
      .length;
}

int _studentPensumPendingCount() {
  return _studentPensumCourses()
      .where((course) => course.status == _PensumCourseStatus.pending)
      .length;
}

List<String> _studentPensumReportDetails(String periodLabel) {
  final courses = _studentPensumCourses();

  return [
    'Ingenieria en Software: ${_studentPensumCompletedCount()} de ${courses.length} materias dadas',
    '${_studentPensumInProgressCount()} materias cursando y ${_studentPensumPendingCount()} pendientes en el $periodLabel actual',
    ...courses.map(
      (course) =>
          '[${course.status.reportTag}] '
          'Ciclo ${course.cycle} · ${course.code} · ${course.name}',
    ),
  ];
}

BoxDecoration cardStyle() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
  );
}
