import 'package:flutter/material.dart';

import '../widgets/app_bottom_nav.dart';

class AcademicReportsPage extends StatelessWidget {
  const AcademicReportsPage({super.key, this.userRole = 'estudiante'});

  final String userRole;

  bool get _isTeacher => userRole == 'docente';
  bool get _isAdmin => userRole == 'admin';

  String get _title {
    if (_isAdmin) {
      return 'Reportes Institucionales';
    }

    if (_isTeacher) {
      return 'Reportes Docentes';
    }

    return 'Reportes Academicos';
  }

  @override
  Widget build(BuildContext context) {
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
        userRole: userRole,
        isRootDestination: false,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: _isAdmin
              ? const [
                  InstitutionalOverviewCard(),
                  SizedBox(height: 16),
                  FacultyCapacityCard(),
                  SizedBox(height: 16),
                  OperationsAlertsCard(),
                ]
              : _isTeacher
              ? const [
                  TeachingOverviewCard(),
                  SizedBox(height: 16),
                  SectionPerformanceCard(),
                  SizedBox(height: 16),
                  PendingReviewsCard(),
                ]
              : const [
                  PerformanceCard(),
                  SizedBox(height: 16),
                  EnrollmentCard(),
                  SizedBox(height: 16),
                  FacultyCard(),
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

BoxDecoration cardStyle() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
  );
}
