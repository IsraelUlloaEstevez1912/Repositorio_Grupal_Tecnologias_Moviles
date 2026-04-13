import 'package:flutter/material.dart';

class NotificationModel {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String timeText;
  final bool isNew;
  final TextSpan subtitleRichText;
  final String category;

  NotificationModel({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.timeText,
    required this.isNew,
    required this.subtitleRichText,
    required this.category,
  });
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _selectedTabIndex = 0;
  final List<String> _tabs = ['Todas', 'Académico', 'Campus'];

  final List<NotificationModel> _allNotifications = [
    NotificationModel(
      icon: Icons.event_available,
      iconColor: const Color(0xFF2563EB),
      iconBgColor: const Color(0xFFEFF6FF),
      title: 'Cierre de Inscripciones',
      timeText: 'Ahora',
      isNew: true,
      category: 'Académico',
      subtitleRichText: const TextSpan(
        style: TextStyle(color: Color(0xFF64748B), height: 1.4, fontSize: 13),
        children: [
          TextSpan(text: 'El periodo de inscripción para el semestre '),
          TextSpan(
            text: '2024-II',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF475569),
            ),
          ),
          TextSpan(
            text: ' finaliza este viernes a las 18:00. Asegura tu cupo.',
          ),
        ],
      ),
    ),
    NotificationModel(
      icon: Icons.star_border,
      iconColor: const Color(0xFF10B981),
      iconBgColor: const Color(0xFFECFDF5),
      title: 'Nueva Nota Publicada',
      timeText: '1h',
      isNew: true,
      category: 'Académico',
      subtitleRichText: const TextSpan(
        style: TextStyle(color: Color(0xFF64748B), height: 1.4, fontSize: 13),
        children: [
          TextSpan(text: 'Se han publicado las calificaciones finales de '),
          TextSpan(
            text: 'Cálculo Diferencial (SEC 01).',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    ),
    NotificationModel(
      icon: Icons.assignment_late_outlined,
      iconColor: const Color(0xFFF43F5E),
      iconBgColor: const Color(0xFFFFF1F2),
      title: 'Encuesta Docente Pendiente',
      timeText: '2h',
      isNew: true,
      category: 'Académico',
      subtitleRichText: const TextSpan(
        style: TextStyle(color: Color(0xFF64748B), height: 1.4, fontSize: 13),
        children: [
          TextSpan(
            text:
                'No olvides completar la evaluación de tus profesores. Tienes hasta el domingo.',
          ),
        ],
      ),
    ),
    NotificationModel(
      icon: Icons.campaign_outlined,
      iconColor: const Color(0xFFF59E0B),
      iconBgColor: const Color(0xFFFEF3C7),
      title: 'Feria de Empleo Campus',
      timeText: '4h',
      isNew: false,
      category: 'Campus',
      subtitleRichText: const TextSpan(
        style: TextStyle(color: Color(0xFF64748B), height: 1.4, fontSize: 13),
        children: [
          TextSpan(
            text:
                'No faltes mañana a la Feria de Empleabilidad en el Auditorio Central. Más de 30 empresas participantes.',
          ),
        ],
      ),
    ),
    NotificationModel(
      icon: Icons.edit_calendar,
      iconColor: const Color(0xFF3B82F6),
      iconBgColor: const Color(0xFFEFF6FF),
      title: 'Validación de Matrícula',
      timeText: '8h',
      isNew: false,
      category: 'Académico',
      subtitleRichText: const TextSpan(
        style: TextStyle(color: Color(0xFF64748B), height: 1.4, fontSize: 13),
        children: [
          TextSpan(
            text:
                'Tu solicitud de matrícula ha sido validada correctamente por el departamento de Registro Académico.',
          ),
        ],
      ),
    ),
    NotificationModel(
      icon: Icons.meeting_room_outlined,
      iconColor: const Color(0xFF8B5CF6),
      iconBgColor: const Color(0xFFF5F3FF),
      title: 'Tutoría Programada',
      timeText: '1d',
      isNew: false,
      category: 'Académico',
      subtitleRichText: const TextSpan(
        style: TextStyle(color: Color(0xFF64748B), height: 1.4, fontSize: 13),
        children: [
          TextSpan(
            text:
                'Tienes una sesión de tutoría reservada para el martes a las 14:00 en el Cubículo 4.',
          ),
        ],
      ),
    ),
    NotificationModel(
      icon: Icons.local_library_outlined,
      iconColor: const Color(0xFF0F766E),
      iconBgColor: const Color(0xFFCCFBF1),
      title: 'Cierre de Biblioteca',
      timeText: '1d',
      isNew: false,
      category: 'Campus',
      subtitleRichText: const TextSpan(
        style: TextStyle(color: Color(0xFF64748B), height: 1.4, fontSize: 13),
        children: [
          TextSpan(
            text:
                'La biblioteca central cerrará temporalmente este fin de semana por labores de fumigación.',
          ),
        ],
      ),
    ),
    NotificationModel(
      icon: Icons.wifi_off_outlined,
      iconColor: const Color(0xFF64748B),
      iconBgColor: const Color(0xFFF1F5F9),
      title: 'Mantenimiento de Red',
      timeText: '2d',
      isNew: false,
      category: 'Campus',
      subtitleRichText: const TextSpan(
        style: TextStyle(color: Color(0xFF64748B), height: 1.4, fontSize: 13),
        children: [
          TextSpan(
            text:
                'El servicio de Wi-Fi en las facultades de ingeniería presentará intermitencias el sábado por la mañana.',
          ),
        ],
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    List<NotificationModel> visibleNotifications;
    if (_selectedTabIndex == 0) {
      visibleNotifications = _allNotifications;
    } else {
      final category = _tabs[_selectedTabIndex]; // Académico o Campus
      visibleNotifications = _allNotifications
          .where((n) => n.category == category)
          .toList();
    }

    final newNotifications = visibleNotifications
        .where((n) => n.isNew)
        .toList();
    final oldNotifications = visibleNotifications
        .where((n) => !n.isNew)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F6F9),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF1D4ED8),
            size: 20,
          ),
          onPressed: () {},
        ),
        title: const Text(
          'Centro de Notificaciones',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.w900,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Color(0xFF1D4ED8)),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Control Segmentado (Tabs)
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0).withOpacity(0.5),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Row(
                children: List.generate(_tabs.length, (index) {
                  final isSelected = _selectedTabIndex == index;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTabIndex = index;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : [],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          _tabs[index],
                          style: TextStyle(
                            color: isSelected
                                ? const Color(0xFF1D4ED8)
                                : const Color(0xFF64748B),
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            if (newNotifications.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  top: 16.0,
                  bottom: 8.0,
                ),
                child: Text(
                  'NUEVAS',
                  style: TextStyle(
                    color: Color(0xFF94A3B8),
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              ...newNotifications.map(
                (n) => _NotificationItem(
                  icon: n.icon,
                  iconColor: n.iconColor,
                  iconBgColor: n.iconBgColor,
                  title: n.title,
                  timeText: n.timeText,
                  isNew: n.isNew,
                  subtitleRichText: n.subtitleRichText,
                ),
              ),
            ],

            if (oldNotifications.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  top: 24.0,
                  bottom: 8.0,
                ),
                child: Text(
                  'ANTERIORES',
                  style: TextStyle(
                    color: Color(0xFF94A3B8),
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              ...oldNotifications.map(
                (n) => _NotificationItem(
                  icon: n.icon,
                  iconColor: n.iconColor,
                  iconBgColor: n.iconBgColor,
                  title: n.title,
                  timeText: n.timeText,
                  isNew: n.isNew,
                  subtitleRichText: n.subtitleRichText,
                ),
              ),
            ],

            if (visibleNotifications.isEmpty)
              const Padding(
                padding: EdgeInsets.all(40.0),
                child: Center(
                  child: Text(
                    'No hay notificaciones en esta categoría.',
                    style: TextStyle(color: Colors.black45),
                  ),
                ),
              ),

            const SizedBox(height: 24),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF2563EB),
          unselectedItemColor: const Color(0xFF94A3B8),
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 10,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 10,
          ),
          currentIndex: 3, // "ALERTAS" es el 4to ítem (índice 3)
          iconSize: 24,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 6.0),
                child: Icon(Icons.home_outlined),
              ),
              label: 'INICIO',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 6.0),
                child: Icon(Icons.calendar_today_outlined),
              ),
              label: 'HORARIO',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 6.0),
                child: Icon(Icons.school_outlined),
              ),
              label: 'NOTAS',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 6.0),
                child: Icon(
                  Icons.notifications,
                ), // Ícono de alertas seleccionado (sólido)
              ),
              label: 'ALERTAS',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 6.0),
                child: Icon(Icons.person_outline),
              ),
              label: 'PERFIL',
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String timeText;
  final bool isNew;
  final TextSpan subtitleRichText;

  const _NotificationItem({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.timeText,
    required this.isNew,
    required this.subtitleRichText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 7.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              if (isNew)
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2563EB),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Color(0xFF1E293B),
                          fontWeight: FontWeight.w800, // Extra bold
                          fontSize: 14.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      timeText,
                      style: TextStyle(
                        color: isNew
                            ? const Color(0xFF2563EB)
                            : const Color(0xFF94A3B8),
                        fontWeight: isNew ? FontWeight.w700 : FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                RichText(text: subtitleRichText),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
