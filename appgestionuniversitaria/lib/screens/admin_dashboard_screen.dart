import 'package:flutter/material.dart';

import '../widgets/app_bottom_nav.dart';
import 'academic_reports_page.dart';
import 'assignments_screen.dart';
import 'grade_entry_screen.dart';
import 'home_page.dart';
import 'list.dart';
import 'matricula.dart';
import 'notifications.dart';
import 'profile_screen.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key, this.userRole = 'admin'});

  final String userRole;

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  void _openPage(Widget page) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required String change,
    required Color bgColor,
    required Color iconColor,
    bool isNegative = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: iconColor, size: 28),
              Text(
                change,
                style: TextStyle(
                  fontSize: 12,
                  color: isNegative ? Colors.red[600] : Colors.green[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[700],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1F63F2).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: const Color(0xFF1F63F2), size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required String title,
    required String time,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF1F63F2).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF1F63F2), size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                time,
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Panel de Control',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications_outlined, color: Colors.black),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF6B6B),
                      shape: BoxShape.circle,
                    ),
                    child: const Text(
                      '3',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () =>
                _openPage(NotificationsScreen(userRole: widget.userRole)),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.black),
            onPressed: () =>
                _openPage(ProfileScreen(userRole: widget.userRole)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resumen General',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  'Ultimos 30 dias',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const Spacer(),
                Text(
                  '+5%',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.green[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.people,
                    label: 'ESTUDIANTES',
                    value: '1,240',
                    change: '+5%',
                    bgColor: const Color(0xFFE3F2FD),
                    iconColor: const Color(0xFF1F63F2),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.person_outline,
                    label: 'DOCENTES',
                    value: '85',
                    change: '+2%',
                    bgColor: const Color(0xFFF3E5F5),
                    iconColor: const Color(0xFF9C27B0),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildStatCard(
              icon: Icons.class_,
              label: 'CURSOS ACTIVOS',
              value: '42',
              change: '-1%',
              bgColor: const Color(0xFFFCE4EC),
              iconColor: const Color(0xFFE91E63),
              isNegative: true,
            ),
            const SizedBox(height: 32),
            const Text(
              'Accesos Rapidos',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            _buildQuickAccessCard(
              icon: Icons.people_alt_outlined,
              title: 'Lista de Estudiantes',
              subtitle: 'Ver y registrar estudiantes',
              onTap: () =>
                  _openPage(StudentListScreen(userRole: widget.userRole)),
            ),
            const SizedBox(height: 12),
            _buildQuickAccessCard(
              icon: Icons.assignment_outlined,
              title: 'Gestionar Asignaturas',
              subtitle: 'Entrar al modulo academico',
              onTap: () =>
                  _openPage(AssignmentsPage(userRole: widget.userRole)),
            ),
            const SizedBox(height: 12),
            _buildQuickAccessCard(
              icon: Icons.fact_check_outlined,
              title: 'Registrar Calificaciones',
              subtitle: 'Abrir la captura de notas',
              onTap: () =>
                  _openPage(GradeEntryScreen(userRole: widget.userRole)),
            ),
            const SizedBox(height: 12),
            _buildQuickAccessCard(
              icon: Icons.dashboard_customize_outlined,
              title: 'Centro Academico',
              subtitle: 'Vista puente de reportes y horario',
              onTap: () => _openPage(MyHomePage(userRole: widget.userRole)),
            ),
            const SizedBox(height: 12),
            _buildQuickAccessCard(
              icon: Icons.bar_chart_outlined,
              title: 'Ver Reportes',
              subtitle: 'Analitica academica y de matricula',
              onTap: () =>
                  _openPage(AcademicReportsPage(userRole: widget.userRole)),
            ),
            const SizedBox(height: 12),
            _buildQuickAccessCard(
              icon: Icons.account_balance_wallet_outlined,
              title: 'Gestion de Matricula',
              subtitle: 'Revisar cargos y pagos',
              onTap: () =>
                  _openPage(MatriculaScreen(userRole: widget.userRole)),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Actividad Reciente',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      _openPage(NotificationsScreen(userRole: widget.userRole)),
                  child: const Text(
                    'Ver Todo',
                    style: TextStyle(
                      color: Color(0xFF1F63F2),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildActivityItem(
              icon: Icons.person_add_outlined,
              title: 'Registro de estudiante: Jane Cooper',
              time: 'hace 2 minutos',
            ),
            const SizedBox(height: 12),
            _buildActivityItem(
              icon: Icons.assignment_outlined,
              title: 'Asignatura "Fisica Avanzada" actualizada',
              time: 'hace 6 horas',
            ),
            const SizedBox(height: 12),
            _buildActivityItem(
              icon: Icons.grade_outlined,
              title: 'Calificaciones registradas: CS201',
              time: 'hace 1 dia',
            ),
            const SizedBox(height: 12),
            _buildActivityItem(
              icon: Icons.event_note_outlined,
              title: 'Nuevo evento academico creado',
              time: 'hace 2 dias',
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 0,
        userRole: widget.userRole,
      ),
    );
  }
}
