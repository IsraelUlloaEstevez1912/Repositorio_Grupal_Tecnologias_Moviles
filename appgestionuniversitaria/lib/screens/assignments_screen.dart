import 'package:flutter/material.dart';

import '../widgets/app_bottom_nav.dart';
import 'academic_reports_page.dart';
import 'grade_entry_screen.dart';
import 'home_page.dart';
import 'list.dart';
import 'matricula.dart';
import 'notifications.dart';
import 'profile_screen.dart';
import 'student_schedule_page.dart';

class AssignmentsPage extends StatefulWidget {
  const AssignmentsPage({
    super.key,
    this.userRole = 'estudiante',
    this.appBarTitle = 'Asignaturas',
    this.showBackButton = true,
  });

  final String userRole;
  final String appBarTitle;
  final bool showBackButton;

  @override
  State<AssignmentsPage> createState() => _AssignmentsPageState();
}

class _AssignmentsPageState extends State<AssignmentsPage> {
  late List<Map<String, dynamic>> _allAssignments;
  List<Map<String, dynamic>> _filteredAssignments = [];
  String _selectedTab = 'todos';
  late TextEditingController _searchController;

  bool get _isTeacher => widget.userRole == 'docente';
  bool get _isAdmin => widget.userRole == 'admin';

  List<_QuickShortcut> get _quickShortcuts {
    if (_isAdmin) {
      return [
        _QuickShortcut(
          label: 'Centro',
          icon: Icons.dashboard_customize_outlined,
          onTap: () => _openPage(MyHomePage(userRole: widget.userRole)),
        ),
        _QuickShortcut(
          label: 'Estudiantes',
          icon: Icons.people_alt_outlined,
          onTap: () => _openPage(StudentListScreen(userRole: widget.userRole)),
        ),
        _QuickShortcut(
          label: 'Finanzas',
          icon: Icons.account_balance_wallet_outlined,
          onTap: () => _openPage(MatriculaScreen(userRole: widget.userRole)),
        ),
        _QuickShortcut(
          label: 'Reportes',
          icon: Icons.bar_chart_outlined,
          onTap: () =>
              _openPage(AcademicReportsPage(userRole: widget.userRole)),
        ),
        _QuickShortcut(
          label: 'Perfil',
          icon: Icons.person_outline_rounded,
          onTap: () => _openPage(ProfileScreen(userRole: widget.userRole)),
        ),
        _QuickShortcut(
          label: 'Alertas',
          icon: Icons.notifications_none_rounded,
          onTap: () =>
              _openPage(NotificationsScreen(userRole: widget.userRole)),
        ),
      ];
    }

    if (_isTeacher) {
      return [
        _QuickShortcut(
          label: 'Centro',
          icon: Icons.dashboard_customize_outlined,
          onTap: () => _openPage(MyHomePage(userRole: widget.userRole)),
        ),
        _QuickShortcut(
          label: 'Calificaciones',
          icon: Icons.fact_check_outlined,
          onTap: () => _openPage(GradeEntryScreen(userRole: widget.userRole)),
        ),
        _QuickShortcut(
          label: 'Estudiantes',
          icon: Icons.people_alt_outlined,
          onTap: () => _openPage(StudentListScreen(userRole: widget.userRole)),
        ),
        _QuickShortcut(
          label: 'Reportes',
          icon: Icons.bar_chart_outlined,
          onTap: () =>
              _openPage(AcademicReportsPage(userRole: widget.userRole)),
        ),
        _QuickShortcut(
          label: 'Perfil',
          icon: Icons.person_outline_rounded,
          onTap: () => _openPage(ProfileScreen(userRole: widget.userRole)),
        ),
        _QuickShortcut(
          label: 'Alertas',
          icon: Icons.notifications_none_rounded,
          onTap: () =>
              _openPage(NotificationsScreen(userRole: widget.userRole)),
        ),
      ];
    }

    return [
      _QuickShortcut(
        label: 'Centro',
        icon: Icons.dashboard_customize_outlined,
        onTap: () => _openPage(MyHomePage(userRole: widget.userRole)),
      ),
      _QuickShortcut(
        label: 'Horario',
        icon: Icons.calendar_today_outlined,
        onTap: () => _openPage(StudentSchedulePage(userRole: widget.userRole)),
      ),
      _QuickShortcut(
        label: 'Matricula',
        icon: Icons.credit_card_outlined,
        onTap: () => _openPage(MatriculaScreen(userRole: widget.userRole)),
      ),
      _QuickShortcut(
        label: 'Reportes',
        icon: Icons.bar_chart_outlined,
        onTap: () => _openPage(AcademicReportsPage(userRole: widget.userRole)),
      ),
      _QuickShortcut(
        label: 'Perfil',
        icon: Icons.person_outline_rounded,
        onTap: () => _openPage(ProfileScreen(userRole: widget.userRole)),
      ),
      _QuickShortcut(
        label: 'Alertas',
        icon: Icons.notifications_none_rounded,
        onTap: () => _openPage(NotificationsScreen(userRole: widget.userRole)),
      ),
    ];
  }

  List<_AssignmentsTab> get _tabs {
    if (_isAdmin) {
      return const [
        _AssignmentsTab(label: 'Todas', value: 'todos'),
        _AssignmentsTab(label: 'Revision', value: 'revision'),
        _AssignmentsTab(label: 'Coordinacion', value: 'coordinacion'),
        _AssignmentsTab(label: 'Archivadas', value: 'archivadas'),
      ];
    }

    if (_isTeacher) {
      return const [
        _AssignmentsTab(label: 'Todas', value: 'todos'),
        _AssignmentsTab(label: 'Hoy', value: 'hoy'),
        _AssignmentsTab(label: 'Pendientes', value: 'pendientes'),
        _AssignmentsTab(label: 'Archivadas', value: 'archivadas'),
      ];
    }

    return const [
      _AssignmentsTab(label: 'Todos', value: 'todos'),
      _AssignmentsTab(label: 'Activas', value: 'activas'),
      _AssignmentsTab(label: 'Archivadas', value: 'archivadas'),
      _AssignmentsTab(label: 'Proximas', value: 'proximas'),
    ];
  }

  String get _resolvedAppBarTitle {
    if (widget.appBarTitle != 'Asignaturas') {
      return widget.appBarTitle;
    }

    if (_isAdmin) {
      return 'Gestion Academica';
    }

    if (_isTeacher) {
      return 'Mis Secciones';
    }

    return 'Mis Asignaturas';
  }

  String get _searchHint {
    if (_isAdmin) {
      return 'Buscar procesos, facultades o codigos...';
    }

    if (_isTeacher) {
      return 'Buscar secciones, aulas o codigos...';
    }

    return 'Buscar asignaturas o codigos...';
  }

  String get _emptyStateLabel {
    if (_isAdmin) {
      return 'No hay procesos academicos';
    }

    if (_isTeacher) {
      return 'No hay secciones disponibles';
    }

    return 'No hay asignaturas';
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _initializeAssignments();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _initializeAssignments() {
    if (_isAdmin) {
      _allAssignments = [
        {
          'code': 'PLAN-26',
          'category': 'OFERTA',
          'name': 'Revision de oferta academica 2026-II',
          'department': 'Vicerrectoria Academica',
          'nextWindow': 'Hoy, 09:00 AM',
          'status': 'revision',
          'statusLabel': 'REVISION',
          'scope': '12 carreras',
          'owner': 'Comite curricular',
          'pending': '4 planes por aprobar',
          'icon': Icons.rule_folder_outlined,
          'color': const Color(0xFF1F63F2),
        },
        {
          'code': 'CARGA-14',
          'category': 'DOCENCIA',
          'name': 'Asignacion de carga docente',
          'department': 'Facultad STEM',
          'nextWindow': 'Hoy, 11:30 AM',
          'status': 'coordinacion',
          'statusLabel': 'COORDINACION',
          'scope': '85 docentes',
          'owner': 'Direccion academica',
          'pending': '7 ajustes por validar',
          'icon': Icons.groups_3_outlined,
          'color': const Color(0xFF10B981),
        },
        {
          'code': 'MTR-08',
          'category': 'MATRICULA',
          'name': 'Seguimiento a apertura de secciones',
          'department': 'Registro Academico',
          'nextWindow': 'Manana, 08:00 AM',
          'status': 'revision',
          'statusLabel': 'PRIORIDAD',
          'scope': '26 secciones',
          'owner': 'Mesa operativa',
          'pending': 'Demanda alta en 3 materias',
          'icon': Icons.alt_route_outlined,
          'color': const Color(0xFFF59E0B),
        },
        {
          'code': 'CAL-21',
          'category': 'AUDITORIA',
          'name': 'Cierre de actas del semestre',
          'department': 'Control de Estudios',
          'nextWindow': 'Viernes, 04:00 PM',
          'status': 'coordinacion',
          'statusLabel': 'SEGUIMIENTO',
          'scope': '42 cursos',
          'owner': 'Secretaria general',
          'pending': '12 actas en proceso',
          'icon': Icons.fact_check_outlined,
          'color': const Color(0xFF7C3AED),
        },
        {
          'code': 'ARC-03',
          'category': 'HISTORICO',
          'name': 'Consolidado de cierre 2025-II',
          'department': 'Archivo Institucional',
          'nextWindow': 'Completado',
          'status': 'archivada',
          'statusLabel': 'ARCHIVO',
          'scope': 'Documentacion completa',
          'owner': 'Gestion documental',
          'pending': 'Sin tareas pendientes',
          'icon': Icons.inventory_2_outlined,
          'color': const Color(0xFF4B5563),
        },
      ];
    } else if (_isTeacher) {
      _allAssignments = [
        {
          'code': 'CS204',
          'section': 'SEC-02',
          'name': 'Estructuras de Datos y Algoritmos',
          'department': 'Ingenieria de Software',
          'nextClass': 'Hoy, 10:00 AM',
          'status': 'hoy',
          'statusLabel': 'HOY',
          'students': '32 estudiantes',
          'room': 'Aula 305',
          'pending': '5 notas pendientes',
          'icon': Icons.code_rounded,
          'color': const Color(0xFF1B5E7A),
        },
        {
          'code': 'MAT210',
          'section': 'SEC-01',
          'name': 'Calculo Multivariable',
          'department': 'Ciencias Basicas',
          'nextClass': 'Hoy, 01:00 PM',
          'status': 'hoy',
          'statusLabel': 'HOY',
          'students': '28 estudiantes',
          'room': 'Aula 402',
          'pending': 'Asistencia por cerrar',
          'icon': Icons.functions_rounded,
          'color': const Color(0xFF2D5016),
        },
        {
          'code': 'FIS110',
          'section': 'LAB-03',
          'name': 'Laboratorio de Fisica',
          'department': 'Departamento de Ciencias',
          'nextClass': 'Manana, 08:00 AM',
          'status': 'pendiente',
          'statusLabel': 'REVISION',
          'students': '18 estudiantes',
          'room': 'Pabellon B, Lab 2',
          'pending': '2 practicas por revisar',
          'icon': Icons.science_outlined,
          'color': const Color(0xFFF59E0B),
        },
        {
          'code': 'HUM115',
          'section': 'SEC-04',
          'name': 'Comunicacion Academica',
          'department': 'Humanidades',
          'nextClass': 'Viernes, 03:30 PM',
          'status': 'pendiente',
          'statusLabel': 'PENDIENTE',
          'students': '24 estudiantes',
          'room': 'Aula 112',
          'pending': 'Retroalimentacion de ensayo',
          'icon': Icons.menu_book_outlined,
          'color': const Color(0xFF6B4C3A),
        },
        {
          'code': 'ADM310',
          'section': 'SEC-07',
          'name': 'Seminario de Investigacion',
          'department': 'Facultad de Negocios',
          'nextClass': 'Sin clase esta semana',
          'status': 'archivada',
          'statusLabel': 'CERRADA',
          'students': '12 estudiantes',
          'room': 'Aula virtual',
          'pending': 'Curso finalizado',
          'icon': Icons.analytics_outlined,
          'color': const Color(0xFF4B5563),
        },
      ];
    } else {
      _allAssignments = [
        {
          'code': 'MAT301',
          'name': 'Matematicas Avanzadas II',
          'department': 'Ingenieria',
          'professor': 'Dra. Sarah Jenkins',
          'nextClass': 'Lunes, 09:00 AM',
          'status': 'activa',
          'color': const Color(0xFF2D5016),
        },
        {
          'code': 'CS204',
          'name': 'Estructuras de Datos y Algoritmos',
          'department': 'Ciencias de la Computacion',
          'professor': 'Prof. Michael Chen',
          'nextClass': 'Manana, 11:30 AM',
          'status': 'activa',
          'color': const Color(0xFF1B5E7A),
        },
        {
          'code': 'FIS102',
          'name': 'Bases de Fisica Cuantica',
          'department': 'Departamento de Ciencias',
          'professor': 'Dra. Elena Rodriguez',
          'nextClass': 'Miercoles, 2:00 PM',
          'status': 'proximas',
          'color': const Color(0xFF1A1A2E),
        },
        {
          'code': 'ENG101',
          'name': 'English Literature',
          'department': 'Humanidades',
          'professor': 'Dr. James Smith',
          'nextClass': 'Jueves, 10:00 AM',
          'status': 'archivada',
          'color': const Color(0xFF6B4C3A),
        },
      ];
    }

    _filterAssignments();
  }

  void _openPage(Widget page) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
  }

  void _filterAssignments() {
    final query = _searchController.text.toLowerCase();
    List<Map<String, dynamic>> filtered = _allAssignments;

    if (_isAdmin) {
      if (_selectedTab == 'revision') {
        filtered = filtered.where((a) => a['status'] == 'revision').toList();
      } else if (_selectedTab == 'coordinacion') {
        filtered = filtered
            .where((a) => a['status'] == 'coordinacion')
            .toList();
      } else if (_selectedTab == 'archivadas') {
        filtered = filtered.where((a) => a['status'] == 'archivada').toList();
      }
    } else if (_isTeacher) {
      if (_selectedTab == 'hoy') {
        filtered = filtered.where((a) => a['status'] == 'hoy').toList();
      } else if (_selectedTab == 'pendientes') {
        filtered = filtered.where((a) => a['status'] == 'pendiente').toList();
      } else if (_selectedTab == 'archivadas') {
        filtered = filtered.where((a) => a['status'] == 'archivada').toList();
      }
    } else {
      if (_selectedTab == 'activas') {
        filtered = filtered.where((a) => a['status'] == 'activa').toList();
      } else if (_selectedTab == 'archivadas') {
        filtered = filtered.where((a) => a['status'] == 'archivada').toList();
      } else if (_selectedTab == 'proximas') {
        filtered = filtered.where((a) => a['status'] == 'proximas').toList();
      }
    }

    if (query.isNotEmpty) {
      filtered = filtered.where((a) {
        final candidates = [
          a['code'],
          a['name'],
          a['department'],
          a['professor'],
          a['section'],
          a['room'],
          a['pending'],
          a['category'],
          a['owner'],
          a['scope'],
          a['nextWindow'],
        ];

        return candidates.any(
          (value) =>
              value != null && value.toString().toLowerCase().contains(query),
        );
      }).toList();
    }

    setState(() {
      _filteredAssignments = filtered;
    });
  }

  void _onTabChanged(String tab) {
    setState(() {
      _selectedTab = tab;
    });
    _filterAssignments();
  }

  void _handlePrimaryAction() {
    if (_isTeacher) {
      _openPage(GradeEntryScreen(userRole: widget.userRole));
      return;
    }

    if (_isAdmin) {
      _openPage(MatriculaScreen(userRole: widget.userRole));
      return;
    }

    _openPage(MatriculaScreen(userRole: widget.userRole));
  }

  String get _primaryActionLabel {
    if (_isTeacher) {
      return 'Registrar notas';
    }

    if (_isAdmin) {
      return 'Ver finanzas';
    }

    return 'Ver matricula';
  }

  IconData get _primaryActionIcon {
    if (_isTeacher) {
      return Icons.fact_check_outlined;
    }

    if (_isAdmin) {
      return Icons.account_balance_wallet_outlined;
    }

    return Icons.credit_card_outlined;
  }

  Widget _buildQuickShortcutCard(
    _QuickShortcut shortcut, {
    double width = 124,
  }) {
    return InkWell(
      onTap: shortcut.onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        width: width,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.08),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF1F63F2).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(shortcut.icon, color: const Color(0xFF1F63F2)),
            ),
            const SizedBox(height: 12),
            Text(
              shortcut.label,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickShortcutsSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideLayout = constraints.maxWidth >= 980;

        if (isWideLayout) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _quickShortcuts
                  .map((shortcut) => _buildQuickShortcutCard(shortcut))
                  .toList(growable: false),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
          scrollDirection: Axis.horizontal,
          itemCount: _quickShortcuts.length,
          separatorBuilder: (_, _) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            return _buildQuickShortcutCard(_quickShortcuts[index]);
          },
        );
      },
    );
  }

  Widget _buildTab(String label, String value) {
    final isSelected = _selectedTab == value;
    return GestureDetector(
      onTap: () => _onTabChanged(value),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFF1F63F2) : Colors.grey[600],
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          if (isSelected)
            Container(
              height: 3,
              width: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF1F63F2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAssignmentCard(Map<String, dynamic> assignment) {
    if (_isAdmin) {
      return _buildAdminAssignmentCard(assignment);
    }

    if (_isTeacher) {
      return _buildTeacherAssignmentCard(assignment);
    }

    return _buildStudentAssignmentCard(assignment);
  }

  Widget _buildStudentAssignmentCard(Map<String, dynamic> assignment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Row(
        children: [
          Container(
            width: 6,
            height: 140,
            decoration: BoxDecoration(
              color: assignment['color'] as Color,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          assignment['code'].toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          assignment['department'].toString(),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    assignment['name'].toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.grey[300],
                        child: Text(
                          assignment['professor'].toString()[0],
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              assignment['professor'].toString(),
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              'Proxima clase: ${assignment['nextClass']}',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.edit,
                          size: 18,
                          color: Color(0xFF1F63F2),
                        ),
                        label: const Text(
                          'Editar',
                          style: TextStyle(
                            color: Color(0xFF1F63F2),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 100,
            height: 140,
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: (assignment['color'] as Color).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.book,
              color: assignment['color'] as Color,
              size: 48,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeacherAssignmentCard(Map<String, dynamic> assignment) {
    final accentColor = assignment['color'] as Color;

    return LayoutBuilder(
      builder: (context, constraints) {
        final showSidePanel = constraints.maxWidth >= 640;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 6,
                constraints: const BoxConstraints(minHeight: 188),
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _AssignmentBadge(
                            label: assignment['code'].toString(),
                            backgroundColor: Colors.grey.shade100,
                            textColor: const Color(0xFF666666),
                          ),
                          _AssignmentBadge(
                            label: assignment['section'].toString(),
                            backgroundColor: accentColor.withValues(
                              alpha: 0.12,
                            ),
                            textColor: accentColor,
                          ),
                          _AssignmentBadge(
                            label: assignment['statusLabel'].toString(),
                            backgroundColor: _statusBackgroundForAssignment(
                              assignment['status'].toString(),
                            ),
                            textColor: _statusColorForAssignment(
                              assignment['status'].toString(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        assignment['name'].toString(),
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        assignment['department'].toString(),
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _AssignmentMetaChip(
                            icon: Icons.groups_2_outlined,
                            label: assignment['students'].toString(),
                          ),
                          _AssignmentMetaChip(
                            icon: Icons.meeting_room_outlined,
                            label: assignment['room'].toString(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Proxima sesion',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  assignment['nextClass'].toString(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF172033),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: _AssignmentBadge(
                                label: assignment['pending'].toString(),
                                backgroundColor: const Color(0xFFFFF7E6),
                                textColor: const Color(0xFFB45309),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (showSidePanel)
                Container(
                  width: 112,
                  constraints: const BoxConstraints(minHeight: 188),
                  margin: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    assignment['icon'] as IconData? ?? Icons.school_outlined,
                    color: accentColor,
                    size: 46,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAdminAssignmentCard(Map<String, dynamic> assignment) {
    final accentColor = assignment['color'] as Color;

    return LayoutBuilder(
      builder: (context, constraints) {
        final showSidePanel = constraints.maxWidth >= 640;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 6,
                constraints: const BoxConstraints(minHeight: 188),
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _AssignmentBadge(
                            label: assignment['code'].toString(),
                            backgroundColor: Colors.grey.shade100,
                            textColor: const Color(0xFF666666),
                          ),
                          _AssignmentBadge(
                            label: assignment['category'].toString(),
                            backgroundColor: accentColor.withValues(
                              alpha: 0.12,
                            ),
                            textColor: accentColor,
                          ),
                          _AssignmentBadge(
                            label: assignment['statusLabel'].toString(),
                            backgroundColor: _statusBackgroundForAssignment(
                              assignment['status'].toString(),
                            ),
                            textColor: _statusColorForAssignment(
                              assignment['status'].toString(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        assignment['name'].toString(),
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        assignment['department'].toString(),
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _AssignmentMetaChip(
                            icon: Icons.account_tree_outlined,
                            label: assignment['scope'].toString(),
                          ),
                          _AssignmentMetaChip(
                            icon: Icons.admin_panel_settings_outlined,
                            label: assignment['owner'].toString(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Proxima ventana',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  assignment['nextWindow'].toString(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF172033),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: _AssignmentBadge(
                                label: assignment['pending'].toString(),
                                backgroundColor: const Color(0xFFFFF7E6),
                                textColor: const Color(0xFFB45309),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (showSidePanel)
                Container(
                  width: 112,
                  constraints: const BoxConstraints(minHeight: 188),
                  margin: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    assignment['icon'] as IconData? ??
                        Icons.admin_panel_settings_outlined,
                    color: accentColor,
                    size: 46,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Color _statusColorForAssignment(String status) {
    switch (status) {
      case 'hoy':
        return const Color(0xFF1D4ED8);
      case 'revision':
        return const Color(0xFF1D4ED8);
      case 'coordinacion':
        return const Color(0xFF0F766E);
      case 'pendiente':
        return const Color(0xFFB45309);
      case 'archivada':
        return const Color(0xFF4B5563);
      default:
        return const Color(0xFF1F63F2);
    }
  }

  Color _statusBackgroundForAssignment(String status) {
    switch (status) {
      case 'hoy':
        return const Color(0xFFE8F0FF);
      case 'revision':
        return const Color(0xFFE8F0FF);
      case 'coordinacion':
        return const Color(0xFFE6FFFB);
      case 'pendiente':
        return const Color(0xFFFFF7E6);
      case 'archivada':
        return const Color(0xFFF3F4F6);
      default:
        return const Color(0xFFE8F0FF);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: widget.showBackButton,
        leading: widget.showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.maybePop(context);
                  }
                },
              )
            : null,
        title: Text(
          _resolvedAppBarTitle,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () =>
                _openPage(NotificationsScreen(userRole: widget.userRole)),
          ),
          IconButton(
            icon: Icon(_primaryActionIcon, color: Colors.black),
            onPressed: _handlePrimaryAction,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => _filterAssignments(),
              decoration: InputDecoration(
                hintText: _searchHint,
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFE0E0E0),
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFE0E0E0),
                    width: 1,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                for (var index = 0; index < _tabs.length; index++) ...[
                  _buildTab(_tabs[index].label, _tabs[index].value),
                  if (index != _tabs.length - 1) const SizedBox(width: 16),
                ],
              ],
            ),
          ),
          const SizedBox(height: 28),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
            child: Row(
              children: [
                const Text(
                  'Accesos rapidos',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F0FF),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    _isAdmin
                        ? 'Admin'
                        : _isTeacher
                        ? 'Docente'
                        : 'Estudiante',
                    style: const TextStyle(
                      color: Color(0xFF1F63F2),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(height: 124, child: _buildQuickShortcutsSection()),
          const SizedBox(height: 24),
          Expanded(
            child: _filteredAssignments.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.assignment_outlined,
                          size: 64,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _emptyStateLabel,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredAssignments.length,
                    itemBuilder: (context, index) {
                      return _buildAssignmentCard(_filteredAssignments[index]);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _handlePrimaryAction,
        backgroundColor: const Color(0xFF1F63F2),
        extendedTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        label: Text(
          _primaryActionLabel,
          style: const TextStyle(color: Colors.white),
        ),
        icon: Icon(_primaryActionIcon, color: Colors.white),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 0,
        userRole: widget.userRole,
      ),
    );
  }
}

class _QuickShortcut {
  const _QuickShortcut({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
}

class _AssignmentsTab {
  const _AssignmentsTab({required this.label, required this.value});

  final String label;
  final String value;
}

class _AssignmentBadge extends StatelessWidget {
  const _AssignmentBadge({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  final String label;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }
}

class _AssignmentMetaChip extends StatelessWidget {
  const _AssignmentMetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FB),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF64748B)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF475569),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
