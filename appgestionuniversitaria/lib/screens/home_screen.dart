import 'package:flutter/material.dart';

import '../widgets/app_bottom_nav.dart';
import 'academic_reports_page.dart';
import 'admin_dashboard_screen.dart';
import 'assignments_screen.dart';
import 'grade_entry_screen.dart';
import 'list.dart';
import 'matricula.dart';
import 'notifications.dart';
import 'profile_screen.dart';
import 'student_schedule_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, this.userRole = 'estudiante'});

  final String userRole;

  bool get _isAdmin => userRole == 'admin';
  bool get _isTeacher => userRole == 'docente';

  @override
  Widget build(BuildContext context) {
    if (_isAdmin) {
      return AdminDashboardPage(userRole: userRole);
    }

    final metrics = _isTeacher
        ? const [
            _HomeMetric(
              label: 'Clases hoy',
              value: '4',
              accent: Color(0xFF1F63F2),
            ),
            _HomeMetric(
              label: 'Notas pendientes',
              value: '18',
              accent: Color(0xFFF59E0B),
            ),
            _HomeMetric(
              label: 'Secciones',
              value: '6',
              accent: Color(0xFF10B981),
            ),
          ]
        : const [
            _HomeMetric(
              label: 'Materias activas',
              value: '6',
              accent: Color(0xFF1F63F2),
            ),
            _HomeMetric(
              label: 'Promedio',
              value: '4.85',
              accent: Color(0xFF10B981),
            ),
            _HomeMetric(
              label: 'Alertas nuevas',
              value: '3',
              accent: Color(0xFFF59E0B),
            ),
          ];

    final actions = _isTeacher
        ? [
            _HomeAction(
              title: 'Asignaturas',
              subtitle: 'Gestiona tus secciones y materias',
              icon: Icons.assignment_outlined,
              onTap: () => _openPage(
                context,
                AssignmentsPage(userRole: userRole, appBarTitle: 'Asignaturas'),
              ),
            ),
            _HomeAction(
              title: 'Calificaciones',
              subtitle: 'Registra notas y revisa avances',
              icon: Icons.fact_check_outlined,
              onTap: () =>
                  _openPage(context, GradeEntryScreen(userRole: userRole)),
            ),
            _HomeAction(
              title: 'Horario',
              subtitle: 'Consulta tu jornada academica',
              icon: Icons.calendar_today_outlined,
              onTap: () =>
                  _openPage(context, StudentSchedulePage(userRole: userRole)),
            ),
            _HomeAction(
              title: 'Estudiantes',
              subtitle: 'Abre el listado del curso',
              icon: Icons.people_alt_outlined,
              onTap: () =>
                  _openPage(context, StudentListScreen(userRole: userRole)),
            ),
          ]
        : [
            _HomeAction(
              title: 'Asignaturas',
              subtitle: 'Revisa materias y proximas clases',
              icon: Icons.assignment_outlined,
              onTap: () => _openPage(
                context,
                AssignmentsPage(userRole: userRole, appBarTitle: 'Asignaturas'),
              ),
            ),
            _HomeAction(
              title: 'Horario',
              subtitle: 'Mira tu agenda del dia',
              icon: Icons.calendar_today_outlined,
              onTap: () =>
                  _openPage(context, StudentSchedulePage(userRole: userRole)),
            ),
            _HomeAction(
              title: 'Matricula',
              subtitle: 'Ver estado de pago e inscripcion',
              icon: Icons.credit_card_outlined,
              onTap: () =>
                  _openPage(context, MatriculaScreen(userRole: userRole)),
            ),
            _HomeAction(
              title: 'Reportes',
              subtitle: 'Consulta tu progreso academico',
              icon: Icons.bar_chart_outlined,
              onTap: () =>
                  _openPage(context, AcademicReportsPage(userRole: userRole)),
            ),
          ];

    final activity = _isTeacher
        ? const [
            _ActivityEntry(
              title: 'Tienes 5 evaluaciones por registrar',
              subtitle: 'Seccion CS204 · antes de las 6:00 PM',
              icon: Icons.fact_check_outlined,
            ),
            _ActivityEntry(
              title: 'Proxima clase en Aula 402',
              subtitle: 'Matematicas Avanzadas · 08:00 AM',
              icon: Icons.meeting_room_outlined,
            ),
            _ActivityEntry(
              title: 'Recordatorio de asistencia',
              subtitle: 'Laboratorio de Fisica · 01:00 PM',
              icon: Icons.how_to_reg_outlined,
            ),
          ]
        : const [
            _ActivityEntry(
              title: 'Tu proxima clase es Matematicas Avanzadas',
              subtitle: '08:00 AM · Aula 402, Ala de Ciencias',
              icon: Icons.school_outlined,
            ),
            _ActivityEntry(
              title: 'Hay una nota nueva publicada',
              subtitle: 'Calculo Diferencial · revisa el detalle',
              icon: Icons.star_outline_rounded,
            ),
            _ActivityEntry(
              title: 'Tu matricula sigue pendiente de pago',
              subtitle: 'Fecha limite sugerida: esta semana',
              icon: Icons.account_balance_wallet_outlined,
            ),
          ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Inicio',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () =>
                _openPage(context, NotificationsScreen(userRole: userRole)),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline_rounded, color: Colors.black),
            onPressed: () =>
                _openPage(context, ProfileScreen(userRole: userRole)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HomeHero(userRole: userRole),
            const SizedBox(height: 22),
            LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth >= 980 ? 3 : 1;

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: metrics.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: constraints.maxWidth >= 980 ? 2.5 : 3.6,
                  ),
                  itemBuilder: (context, index) {
                    return _MetricCard(metric: metrics[index]);
                  },
                );
              },
            ),
            const SizedBox(height: 26),
            const Text(
              'Accesos rapidos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF172033),
              ),
            ),
            const SizedBox(height: 14),
            LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth >= 1100
                    ? 4
                    : constraints.maxWidth >= 700
                    ? 2
                    : 1;

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: actions.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: constraints.maxWidth >= 700 ? 1.8 : 2.2,
                  ),
                  itemBuilder: (context, index) {
                    return _ActionCard(action: actions[index]);
                  },
                );
              },
            ),
            const SizedBox(height: 26),
            const Text(
              'Actividad reciente',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF172033),
              ),
            ),
            const SizedBox(height: 14),
            ...activity.map((entry) => _ActivityCard(entry: entry)),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(currentIndex: 0, userRole: userRole),
    );
  }

  void _openPage(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
  }
}

class _HomeHero extends StatelessWidget {
  const _HomeHero({required this.userRole});

  final String userRole;

  bool get _isTeacher => userRole == 'docente';

  @override
  Widget build(BuildContext context) {
    final title = _isTeacher
        ? 'Todo listo para tu jornada docente'
        : 'Bienvenido a tu campus digital';
    final subtitle = _isTeacher
        ? 'Accede rapido a tus clases, estudiantes y calificaciones desde un mismo lugar.'
        : 'Consulta tus materias, horario, matricula y progreso academico desde el inicio.';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0D4FE0), Color(0xFF4BA2FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1F63F2).withValues(alpha: 0.18),
            blurRadius: 22,
            offset: const Offset(0, 14),
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
              userRole.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.6,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeMetric {
  const _HomeMetric({
    required this.label,
    required this.value,
    required this.accent,
  });

  final String label;
  final String value;
  final Color accent;
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.metric});

  final _HomeMetric metric;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 48,
            decoration: BoxDecoration(
              color: metric.accent,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  metric.label,
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  metric.value,
                  style: const TextStyle(
                    color: Color(0xFF172033),
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeAction {
  const _HomeAction({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({required this.action});

  final _HomeAction action;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: action.onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F0FF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(action.icon, color: const Color(0xFF1F63F2)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      action.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF172033),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      action.subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivityEntry {
  const _ActivityEntry({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({required this.entry});

  final _ActivityEntry entry;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF4FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(entry.icon, color: const Color(0xFF1F63F2)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
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
        ],
      ),
    );
  }
}
