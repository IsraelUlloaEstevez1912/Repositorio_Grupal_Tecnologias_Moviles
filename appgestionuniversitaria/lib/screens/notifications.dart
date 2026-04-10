import 'package:flutter/material.dart';

import '../widgets/app_bottom_nav.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key, this.userRole = 'estudiante'});

  final String userRole;

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _selectedTabIndex = 0;
  final List<String> _tabs = ['Todas', 'Academico', 'Campus'];

  // 1. Variables para el buscador ( controlan el estado de la búsqueda y la entrada del usuario)
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  // 2. Lista centralizada de notificaciones ( agrupa las notificaciones con su categoría para poder filtrarlas)
  late final List<Map<String, dynamic>> _allNotifications;

  @override
  void initState() {
    super.initState();
    // 3. Inicialización ( agregamos notificaciones originales y 5 nuevas, indicando su categoría y textos de búsqueda)
    _allNotifications = [
      {
        'category': 'Academico',
        'searchText': 'cierre de inscripciones 2024-ii',
        'isNew': true,
        'item': const _NotificationItem(
          icon: Icons.event_available,
          iconColor: Color(0xFF2563EB),
          iconBgColor: Color(0xFFEFF6FF),
          title: 'Cierre de Inscripciones',
          timeText: 'Ahora',
          isNew: true,
          subtitleRichText: TextSpan(
            style: TextStyle(
              color: Color(0xFF64748B),
              height: 1.4,
              fontSize: 13,
            ),
            children: [
              TextSpan(text: 'El periodo de inscripcion para el semestre '),
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
      },
      {
        'category': 'Academico',
        'searchText': 'nueva nota publicada calculo diferencial',
        'isNew': true,
        'item': const _NotificationItem(
          icon: Icons.star_border,
          iconColor: Color(0xFF10B981),
          iconBgColor: Color(0xFFECFDF5),
          title: 'Nueva Nota Publicada',
          timeText: '1h',
          isNew: true,
          subtitleRichText: TextSpan(
            style: TextStyle(
              color: Color(0xFF64748B),
              height: 1.4,
              fontSize: 13,
            ),
            children: [
              TextSpan(text: 'Se han publicado las calificaciones finales de '),
              TextSpan(
                text: 'Calculo Diferencial (SEC 01).',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
        ),
      },
      // -- 5 Nuevas Notificaciones Solicitadas --
      {
        'category': 'Campus',
        'searchText': 'torneo de futbol interfacultades inscripciones',
        'isNew': true,
        'item': const _NotificationItem(
          icon: Icons.sports_soccer,
          iconColor: Color(0xFFEC4899),
          iconBgColor: Color(0xFFFDF2F8),
          title: 'Torneo de Futbol',
          timeText: '10m',
          isNew: true,
          subtitleRichText: TextSpan(
            style: TextStyle(
              color: Color(0xFF64748B),
              height: 1.4,
              fontSize: 13,
            ),
            children: [
              TextSpan(text: 'Abiertas las inscripciones para el '),
              TextSpan(
                text: 'Torneo Interfacultades 2024',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              TextSpan(text: '. Arma tu equipo ya.'),
            ],
          ),
        ),
      },
      {
        'category': 'Campus',
        'searchText': 'menu especial cafeteria almuerzo',
        'isNew': true,
        'item': const _NotificationItem(
          icon: Icons.restaurant,
          iconColor: Color(0xFFF97316),
          iconBgColor: Color(0xFFFFF7ED),
          title: 'Menu Especial',
          timeText: '30m',
          isNew: true,
          subtitleRichText: TextSpan(
            style: TextStyle(
              color: Color(0xFF64748B),
              height: 1.4,
              fontSize: 13,
            ),
            children: [
              TextSpan(text: 'Hoy tendremos platillos tradicionales en la '),
              TextSpan(
                text: 'Cafeteria Central.',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
        ),
      },
      // -- Notificaciones Anteriores Originales y Nuevas --
      {
        'category': 'Campus',
        'searchText': 'feria de empleo campus auditorio central',
        'isNew': false,
        'item': const _NotificationItem(
          icon: Icons.campaign_outlined,
          iconColor: Color(0xFFF59E0B),
          iconBgColor: Color(0xFFFEF3C7),
          title: 'Feria de Empleo Campus',
          timeText: '4h',
          isNew: false,
          subtitleRichText: TextSpan(
            style: TextStyle(
              color: Color(0xFF64748B),
              height: 1.4,
              fontSize: 13,
            ),
            children: [
              TextSpan(
                text:
                    'No faltes manana a la Feria de Empleabilidad en el Auditorio Central. Mas de 30 empresas participantes.',
              ),
            ],
          ),
        ),
      },
      {
        'category': 'Academico',
        'searchText': 'validacion de matricula registro academico',
        'isNew': false,
        'item': const _NotificationItem(
          icon: Icons.edit_calendar,
          iconColor: Color(0xFF3B82F6),
          iconBgColor: Color(0xFFEFF6FF),
          title: 'Validacion de Matricula',
          timeText: '8h',
          isNew: false,
          subtitleRichText: TextSpan(
            style: TextStyle(
              color: Color(0xFF64748B),
              height: 1.4,
              fontSize: 13,
            ),
            children: [
              TextSpan(
                text:
                    'Tu solicitud de matricula ha sido validada correctamente por Registro Academico.',
              ),
            ],
          ),
        ),
      },
      {
        'category': 'Academico',
        'searchText': 'taller de redaccion biblioteca',
        'isNew': false,
        'item': const _NotificationItem(
          icon: Icons.menu_book,
          iconColor: Color(0xFF8B5CF6),
          iconBgColor: Color(0xFFF5F3FF),
          title: 'Taller de Redaccion',
          timeText: '1d',
          isNew: false,
          subtitleRichText: TextSpan(
            style: TextStyle(
              color: Color(0xFF64748B),
              height: 1.4,
              fontSize: 13,
            ),
            children: [
              TextSpan(
                text:
                    'Refuerza tus habilidades escribiendo ensayos en el taller de la biblioteca.',
              ),
            ],
          ),
        ),
      },
      {
        'category': 'Academico',
        'searchText': 'entrega de proyecto final programacion',
        'isNew': false,
        'item': const _NotificationItem(
          icon: Icons.code,
          iconColor: Color(0xFF06B6D4),
          iconBgColor: Color(0xFFECFEFF),
          title: 'Entrega de Proyecto',
          timeText: '2d',
          isNew: false,
          subtitleRichText: TextSpan(
            style: TextStyle(
              color: Color(0xFF64748B),
              height: 1.4,
              fontSize: 13,
            ),
            children: [
              TextSpan(
                text: 'Recuerda subir el repositorio final de la materia ',
              ),
              TextSpan(
                text: 'Programacion Movil',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              TextSpan(text: ' antes de medianoche.'),
            ],
          ),
        ),
      },
      {
        'category': 'Campus',
        'searchText': 'mantenimiento del sistema plataforma aulas virtuales',
        'isNew': false,
        'item': const _NotificationItem(
          icon: Icons.build,
          iconColor: Color(0xFF64748B),
          iconBgColor: Color(0xFFF1F5F9),
          title: 'Mantenimiento de Sistema',
          timeText: '3d',
          isNew: false,
          subtitleRichText: TextSpan(
            style: TextStyle(
              color: Color(0xFF64748B),
              height: 1.4,
              fontSize: 13,
            ),
            children: [
              TextSpan(
                text:
                    'La plataforma de aulas virtuales estara en mantenimiento de 2AM a 4AM.',
              ),
            ],
          ),
        ),
      },
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 4. Lógica de Filtrado (Comentario explicativo: filtra las notificaciones combinando la categoría seleccionada en los tabs y la consulta del buscador)
    final searchQuery = _searchController.text.toLowerCase();
    final selectedCategory = _tabs[_selectedTabIndex];

    final filteredNotifications = _allNotifications.where((notif) {
      final itemWidget = notif['item'] as _NotificationItem;
      // Revisa si coincide con la pestaña actual
      final matchesCategory =
          selectedCategory == 'Todas' || notif['category'] == selectedCategory;
      // Revisa si el texto de búsqueda se encuentra en el título o el contenido guardado en searchText
      final matchesSearch =
          notif['searchText'].toString().toLowerCase().contains(searchQuery) ||
          itemWidget.title.toLowerCase().contains(searchQuery);
      return matchesCategory && matchesSearch;
    }).toList();

    // 5. Separación (Comentario explicativo: dividimos las notificaciones ya filtradas en Nuevas y Anteriores para organizarlas visualmente)
    final newNotifs = filteredNotifications
        .where((n) => n['isNew'] == true)
        .toList();
    final oldNotifs = filteredNotifications
        .where((n) => n['isNew'] == false)
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
          onPressed: () => Navigator.maybePop(context),
        ),
        // 6. Buscador Dinámico en el AppBar (Comentario explicativo: cambia el título por un TextField si _isSearching es verdadero)
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Buscar notificación...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Color(0xFF94A3B8)),
                ),
                style: const TextStyle(color: Color(0xFF1E293B), fontSize: 16),
                onChanged: (_) {
                  // Refresca la vista automáticamente cada vez que se escribe algo
                  setState(() {});
                },
              )
            : const Text(
                'Centro de Notificaciones',
                style: TextStyle(
                  color: Color(0xFF1E293B),
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
        centerTitle: true,
        actions: [
          // 7. Botón de Lupa (Comentario explicativo: este botón al presionarlo activa o desactiva la barra de búsqueda y limpia el texto cuando se cierra)
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: const Color(0xFF1D4ED8),
            ),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                }
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0).withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: List.generate(_tabs.length, (index) {
                  final isSelected = _selectedTabIndex == index;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // 8. Cambio de Categoría ( actualiza la categoría seleccionada Todas/Academico/Campus y repinta la pantalla)
                        setState(() {
                          _selectedTabIndex = index;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.04),
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

            // 9. Secciones Dinámicas ( Renderiza los encabezados y las listas de items "NUEVAS" o "ANTERIORES" solamente si la lista filtrada  contiene notificaciones de ese tipo)
            if (newNotifs.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 16,
                  bottom: 8,
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
              ...newNotifs.map((n) => n['item'] as Widget),
            ],

            if (oldNotifs.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 24,
                  bottom: 8,
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
              ...oldNotifs.map((n) => n['item'] as Widget),
            ],

            // 10. Vista Vacía ( si ninguna notificación coincide con la búsqueda o la categoría, se muestra un mensaje de "no encontradas")
            if (newNotifs.isEmpty && oldNotifs.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Text(
                    'No se encontraron notificaciones',
                    style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
                  ),
                ),
              ),

            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 3,
        userRole: widget.userRole,
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  const _NotificationItem({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.timeText,
    required this.isNew,
    required this.subtitleRichText,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String timeText;
  final bool isNew;
  final TextSpan subtitleRichText;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
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
                  borderRadius: BorderRadius.circular(12),
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
                          fontWeight: FontWeight.w800,
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
