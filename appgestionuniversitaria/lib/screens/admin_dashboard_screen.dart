import 'package:flutter/material.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
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
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Section
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
                  'Últimos 30 días',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
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

            // Stats Cards
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
              isWide: true,
              isNegative: true,
            ),

            const SizedBox(height: 32),

            // Quick Access Section
            const Text(
              'Accesos Rápidos',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),

            _buildQuickAccessCard(
              icon: Icons.person_add,
              title: 'Registrar Estudiante',
              subtitle: 'Agregar nuevo perfil al sistema',
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _buildQuickAccessCard(
              icon: Icons.assignment,
              title: 'Crear Asignatura',
              subtitle: 'Diseñar nuevo plan de estudios',
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _buildQuickAccessCard(
              icon: Icons.bar_chart,
              title: 'Ver Reportes',
              subtitle: 'Análisis académico y financiero',
              onTap: () {},
            ),

            const SizedBox(height: 32),

            // Recent Activity Section
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
                  onPressed: () {},
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
                time: 'hace 2 minutos'),
            const SizedBox(height: 12),
            _buildActivityItem(
                icon: Icons.assignment_outlined,
                title: 'Asignatura "Física Avanzada" actualizada',
                time: 'hace 6 horas'),
            const SizedBox(height: 12),
            _buildActivityItem(
                icon: Icons.grade_outlined,
                title: 'Calificaciones registradas: CS201',
                time: 'hace 1 día'),
            const SizedBox(height: 12),
            _buildActivityItem(
                icon: Icons.event_note_outlined,
                title: 'Nuevo evento académico creado',
                time: 'hace 2 días'),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required String change,
    required Color bgColor,
    required Color iconColor,
    bool isWide = false,
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
            color: Colors.grey.withOpacity(0.1),
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
                    color: const Color(0xFF1F63F2).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: const Color(0xFF1F63F2),
                    size: 24,
                  ),
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
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
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
            color: const Color(0xFF1F63F2).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF1F63F2),
            size: 20,
          ),
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
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFF1F63F2),
      unselectedItemColor: Colors.grey[600],
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school),
          label: 'Académico',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.attach_money),
          label: 'Finanzas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Ajustes',
        ),
      ],
    );
  }
}
