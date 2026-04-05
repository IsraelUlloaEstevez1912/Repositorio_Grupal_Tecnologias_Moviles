import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _selectedTabIndex = 0;
  final List<String> _tabs = ['Todas', 'Académico', 'Campus'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9), 
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F6F9),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1D4ED8), size: 20),
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
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
                                  )
                                ]
                              : [],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          _tabs[index],
                          style: TextStyle(
                            color: isSelected ? const Color(0xFF1D4ED8) : const Color(0xFF64748B),
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            
            // Título "NUEVAS"
            const Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 16.0, bottom: 8.0),
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
            
            // Tarjetas de Notificaciones Nuevas
            const _NotificationItem(
              icon: Icons.event_available,
              iconColor: Color(0xFF2563EB),
              iconBgColor: Color(0xFFEFF6FF),
              title: 'Cierre de Inscripciones',
              timeText: 'Ahora',
              isNew: true,
              subtitleRichText: TextSpan(
                style: TextStyle(color: Color(0xFF64748B), height: 1.4, fontSize: 13),
                children: [
                  TextSpan(text: 'El periodo de inscripción para el semestre '),
                  TextSpan(text: '2024-II', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF475569))),
                  TextSpan(text: ' finaliza este viernes a las 18:00. Asegura tu cupo.'),
                ],
              ),
            ),
            
            const _NotificationItem(
              icon: Icons.star_border,
              iconColor: Color(0xFF10B981), // Verde
              iconBgColor: Color(0xFFECFDF5),
              title: 'Nueva Nota Publicada',
              timeText: '1h',
              isNew: true,
              subtitleRichText: TextSpan(
                style: TextStyle(color: Color(0xFF64748B), height: 1.4, fontSize: 13),
                children: [
                  TextSpan(text: 'Se han publicado las calificaciones finales de '),
                  TextSpan(text: 'Cálculo Diferencial (SEC 01).', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                ],
              ),
            ),
            
            // Título "ANTERIORES"
            const Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 24.0, bottom: 8.0),
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
            
            // Tarjetas de Notificaciones Anteriores
            const _NotificationItem(
              icon: Icons.campaign_outlined,
              iconColor: Color(0xFFF59E0B), // Naranja/Ambar
              iconBgColor: Color(0xFFFEF3C7),
              title: 'Feria de Empleo Campus',
              timeText: '4h',
              isNew: false,
              subtitleRichText: TextSpan(
                style: TextStyle(color: Color(0xFF64748B), height: 1.4, fontSize: 13),
                children: [
                  TextSpan(text: 'No faltes mañana a la Feria de Empleabilidad en el Auditorio Central. Más de 30 empresas participantes.'),
                ],
              ),
            ),
            
            const _NotificationItem(
              icon: Icons.edit_calendar,
              iconColor: Color(0xFF3B82F6), // Azul
              iconBgColor: Color(0xFFEFF6FF),
              title: 'Validación de Matrícula',
              timeText: '8h',
              isNew: false,
              subtitleRichText: TextSpan(
                style: TextStyle(color: Color(0xFF64748B), height: 1.4, fontSize: 13),
                children: [
                  TextSpan(text: 'Tu solicitud de matrícula ha sido validada correctamente por el departamento de Registro Académico.'),
                ],
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
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 10),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 10),
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
                child: Icon(Icons.notifications), // Ícono de alertas seleccionado (sólido)
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
                        color: isNew ? const Color(0xFF2563EB) : const Color(0xFF94A3B8),
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
