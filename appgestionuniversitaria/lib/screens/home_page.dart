import 'package:flutter/material.dart';

import '../widgets/app_bottom_nav.dart';
import 'academic_reports_page.dart';
import 'assignments_screen.dart';
import 'grade_entry_screen.dart';
import 'list.dart';
import 'matricula.dart';
import 'notifications.dart';
import 'profile_screen.dart';
import 'student_schedule_page.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({
    super.key,
    this.title = 'Centro Academico',
    this.userRole = 'estudiante',
  });

  final String title;
  final String userRole;

  bool get _isTeacher => userRole == 'docente';
  bool get _isAdmin => userRole == 'admin';

  @override
  Widget build(BuildContext context) {
    final modules = _isAdmin
        ? <_CenterModule>[
            _CenterModule(
              title: 'Gestion Academica',
              subtitle: 'Supervisa oferta, carga y coordinacion',
              icon: Icons.assignment_outlined,
              onTap: () =>
                  _openPage(context, AssignmentsPage(userRole: userRole)),
            ),
            _CenterModule(
              title: 'Agenda',
              subtitle: 'Consulta la agenda institucional del dia',
              icon: Icons.calendar_today_outlined,
              onTap: () =>
                  _openPage(context, StudentSchedulePage(userRole: userRole)),
            ),
            _CenterModule(
              title: 'Reportes',
              subtitle: 'Indicadores globales y alertas operativas',
              icon: Icons.bar_chart_outlined,
              onTap: () =>
                  _openPage(context, AcademicReportsPage(userRole: userRole)),
            ),
            _CenterModule(
              title: 'Estudiantes',
              subtitle: 'Listado y administracion general',
              icon: Icons.people_alt_outlined,
              onTap: () =>
                  _openPage(context, StudentListScreen(userRole: userRole)),
            ),
            _CenterModule(
              title: 'Finanzas',
              subtitle: 'Revisa matriculas, cargos y pagos',
              icon: Icons.account_balance_wallet_outlined,
              onTap: () =>
                  _openPage(context, MatriculaScreen(userRole: userRole)),
            ),
            _CenterModule(
              title: 'Calificaciones',
              subtitle: 'Audita actas y registros cargados',
              icon: Icons.fact_check_outlined,
              onTap: () =>
                  _openPage(context, GradeEntryScreen(userRole: userRole)),
            ),
            _CenterModule(
              title: 'Alertas',
              subtitle: 'Avisos, incidencias y novedades',
              icon: Icons.notifications_none_rounded,
              onTap: () =>
                  _openPage(context, NotificationsScreen(userRole: userRole)),
            ),
            _CenterModule(
              title: 'Perfil',
              subtitle: 'Accede a tu informacion administrativa',
              icon: Icons.person_outline_rounded,
              onTap: () =>
                  _openPage(context, ProfileScreen(userRole: userRole)),
            ),
          ]
        : _isTeacher
        ? <_CenterModule>[
            _CenterModule(
              title: 'Asignaturas',
              subtitle: 'Gestiona materias y secciones activas',
              icon: Icons.assignment_outlined,
              onTap: () =>
                  _openPage(context, AssignmentsPage(userRole: userRole)),
            ),
            _CenterModule(
              title: 'Horario',
              subtitle: 'Consulta tu jornada academica',
              icon: Icons.calendar_today_outlined,
              onTap: () =>
                  _openPage(context, StudentSchedulePage(userRole: userRole)),
            ),
            _CenterModule(
              title: 'Reportes',
              subtitle: 'Visualiza indicadores de tus cursos',
              icon: Icons.bar_chart_outlined,
              onTap: () =>
                  _openPage(context, AcademicReportsPage(userRole: userRole)),
            ),
            _CenterModule(
              title: 'Calificaciones',
              subtitle: 'Registra y revisa notas',
              icon: Icons.fact_check_outlined,
              onTap: () =>
                  _openPage(context, GradeEntryScreen(userRole: userRole)),
            ),
            _CenterModule(
              title: 'Estudiantes',
              subtitle: 'Listado y administracion de alumnos',
              icon: Icons.people_alt_outlined,
              onTap: () =>
                  _openPage(context, StudentListScreen(userRole: userRole)),
            ),
            _CenterModule(
              title: 'Alertas',
              subtitle: 'Revisa avisos y novedades',
              icon: Icons.notifications_none_rounded,
              onTap: () =>
                  _openPage(context, NotificationsScreen(userRole: userRole)),
            ),
            _CenterModule(
              title: 'Perfil',
              subtitle: 'Accede a tu informacion personal',
              icon: Icons.person_outline_rounded,
              onTap: () =>
                  _openPage(context, ProfileScreen(userRole: userRole)),
            ),
          ]
        : <_CenterModule>[
            _CenterModule(
              title: 'Asignaturas',
              subtitle: 'Gestiona tus materias activas',
              icon: Icons.assignment_outlined,
              onTap: () =>
                  _openPage(context, AssignmentsPage(userRole: userRole)),
            ),
            _CenterModule(
              title: 'Horario',
              subtitle: 'Consulta tus clases del dia',
              icon: Icons.calendar_today_outlined,
              onTap: () =>
                  _openPage(context, StudentSchedulePage(userRole: userRole)),
            ),
            _CenterModule(
              title: 'Reportes',
              subtitle: 'Visualiza indicadores academicos',
              icon: Icons.bar_chart_outlined,
              onTap: () =>
                  _openPage(context, AcademicReportsPage(userRole: userRole)),
            ),
            _CenterModule(
              title: 'Alertas',
              subtitle: 'Revisa avisos y novedades',
              icon: Icons.notifications_none_rounded,
              onTap: () =>
                  _openPage(context, NotificationsScreen(userRole: userRole)),
            ),
            _CenterModule(
              title: 'Perfil',
              subtitle: 'Accede a tu informacion personal',
              icon: Icons.person_outline_rounded,
              onTap: () =>
                  _openPage(context, ProfileScreen(userRole: userRole)),
            ),
            _CenterModule(
              title: 'Matricula',
              subtitle: 'Estado de pago e inscripcion',
              icon: Icons.credit_card_outlined,
              onTap: () =>
                  _openPage(context, MatriculaScreen(userRole: userRole)),
            ),
          ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1F63F2), Color(0xFF4B9BFF)],
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
                  Text(
                    'Centro de modulos',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Desde aqui puedes moverte a todas las pantallas sin '
                    'cambiar de navbar.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.88),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      'Rol activo: ${userRole.toUpperCase()}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Modulos disponibles',
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
                    ? 3
                    : 2;

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: modules.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 1.08,
                  ),
                  itemBuilder: (context, index) {
                    final module = modules[index];
                    return _CenterModuleCard(module: module);
                  },
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(currentIndex: 2, userRole: userRole),
    );
  }

  void _openPage(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
  }
}

class _CenterModule {
  const _CenterModule({
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

class _CenterModuleCard extends StatelessWidget {
  const _CenterModuleCard({required this.module});

  final _CenterModule module;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: module.onTap,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F0FF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(module.icon, color: const Color(0xFF1F63F2)),
              ),
              const Spacer(),
              Text(
                module.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF172033),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                module.subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
