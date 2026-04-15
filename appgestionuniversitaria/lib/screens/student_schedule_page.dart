import 'package:flutter/material.dart';

import '../widgets/app_bottom_nav.dart';

class StudentSchedulePage extends StatelessWidget {
  const StudentSchedulePage({super.key, this.userRole = 'estudiante'});

  final String userRole;
  static const List<String> _days = ['12', '13', '14', '15', '16'];

  bool get _isTeacher => userRole == 'docente';
  bool get _isAdmin => userRole == 'admin';

  Widget _dateItem(String day, bool selected, {double? width}) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: selected ? Colors.blue : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          day,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildDaySelector() {
    return LayoutBuilder(
      builder: (context, constraints) {
        const horizontalPadding = 16.0;
        const gap = 10.0;
        const minItemWidth = 48.0;
        const maxItemWidth = 72.0;

        final usableWidth = constraints.maxWidth - (horizontalPadding * 2);
        final rawItemWidth =
            (usableWidth - ((_days.length - 1) * gap)) / _days.length;
        final canSpreadEvenly = rawItemWidth >= minItemWidth;

        if (canSpreadEvenly) {
          final itemWidth = rawItemWidth.clamp(minItemWidth, maxItemWidth);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _days
                  .map((day) => _dateItem(day, day == '12', width: itemWidth))
                  .toList(growable: false),
            ),
          );
        }

        return ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
          itemCount: _days.length,
          separatorBuilder: (_, _) => const SizedBox(width: gap),
          itemBuilder: (context, index) {
            final day = _days[index];
            return _dateItem(day, day == '12');
          },
        );
      },
    );
  }

  List<_ScheduleEntry> get _entries {
    if (_isAdmin) {
      return const [
        _ScheduleEntry(
          time: '08:00',
          title: 'Comite de apertura academica',
          hour: '08:00 AM - 09:00 AM',
          location: 'Sala de Consejo',
          detail: 'Revision de 12 solicitudes de secciones nuevas',
          highlight: true,
        ),
        _ScheduleEntry(
          time: '10:00',
          title: 'Seguimiento de matricula',
          hour: '10:00 AM - 11:30 AM',
          location: 'Registro Academico',
          detail: 'Validacion de cupos y carga por facultad',
        ),
        _ScheduleEntry.breakLabel('GESTION OPERATIVA'),
        _ScheduleEntry(
          time: '13:00',
          title: 'Mesa financiera y becas',
          hour: '01:00 PM - 02:00 PM',
          location: 'Administracion Central',
          detail: 'Ajuste de cargos pendientes y renovaciones',
        ),
        _ScheduleEntry(
          time: '15:30',
          title: 'Cierre de actas institucionales',
          hour: '03:30 PM - 05:00 PM',
          location: 'Oficina de Control de Estudios',
          detail: 'Consolidado semanal de reportes y auditorias',
        ),
      ];
    }

    if (_isTeacher) {
      return const [
        _ScheduleEntry(
          time: '08:00',
          title: 'Estructuras de Datos · SEC-02',
          hour: '08:00 AM - 09:30 AM',
          location: 'Aula 305, Edificio Ingenieria',
          detail: '32 estudiantes inscritos',
          highlight: true,
        ),
        _ScheduleEntry(
          time: '10:00',
          title: 'Tutoria Academica',
          hour: '10:00 AM - 11:00 AM',
          location: 'Sala de Docentes B',
          detail: 'Seguimiento a estudiantes en alerta',
        ),
        _ScheduleEntry.breakLabel('REUNION DE FACULTAD'),
        _ScheduleEntry(
          time: '13:00',
          title: 'Calculo Multivariable · SEC-01',
          hour: '01:00 PM - 02:30 PM',
          location: 'Aula 402, Ala de Ciencias',
          detail: '18 evaluaciones pendientes de revision',
        ),
        _ScheduleEntry(
          time: '15:30',
          title: 'Horas de Oficina',
          hour: '03:30 PM - 05:00 PM',
          location: 'Cubiculo D-14',
          detail: 'Atencion a consultas y asesorias',
        ),
      ];
    }

    return const [
      _ScheduleEntry(
        time: '08:00',
        title: 'Matematicas Avanzadas',
        hour: '08:00 AM - 09:30 AM',
        location: 'Aula 402, Ala de Ciencias',
        detail: 'Docente: Dra. Sarah Jenkins',
        highlight: true,
      ),
      _ScheduleEntry(
        time: '10:00',
        title: 'Ciencias de la Computacion 101',
        hour: '10:00 AM - 11:30 AM',
        location: 'Aula 105, Biblioteca Central',
        detail: 'Docente: Prof. Michael Chen',
      ),
      _ScheduleEntry.breakLabel('ALMUERZO'),
      _ScheduleEntry(
        time: '13:00',
        title: 'Laboratorio de Fisica',
        hour: '01:00 PM - 03:00 PM',
        location: 'Pabellon B, Lab 2',
        detail: 'Practica experimental del modulo 4',
      ),
      _ScheduleEntry(
        time: '15:30',
        title: 'Historia del Arte',
        hour: '03:30 PM - 05:00 PM',
        location: 'Edificio de Artes, Galeria 1',
        detail: 'Exposicion y debate guiado',
      ),
    ];
  }

  List<Widget> _buildAgendaWidgets() {
    return _entries
        .map((entry) {
          if (entry.isBreak) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  entry.breakLabel!,
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
            );
          }

          return ScheduleItem(
            time: entry.time!,
            title: entry.title!,
            hour: entry.hour!,
            location: entry.location!,
            detail: entry.detail!,
            highlight: entry.highlight,
          );
        })
        .toList(growable: false);
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
          _isAdmin
              ? 'Agenda Administrativa'
              : _isTeacher
              ? 'Agenda Docente'
              : 'Horario del Estudiante',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blue,
        child: Icon(
          _isAdmin
              ? Icons.manage_accounts_outlined
              : _isTeacher
              ? Icons.add_task
              : Icons.add,
          color: Colors.white,
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(currentIndex: 1, userRole: userRole),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            SizedBox(height: 60, child: _buildDaySelector()),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: _buildAgendaWidgets(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScheduleEntry {
  const _ScheduleEntry({
    required this.time,
    required this.title,
    required this.hour,
    required this.location,
    required this.detail,
    this.highlight = false,
  }) : breakLabel = null,
       isBreak = false;

  const _ScheduleEntry.breakLabel(this.breakLabel)
    : time = null,
      title = null,
      hour = null,
      location = null,
      detail = null,
      highlight = false,
      isBreak = true;

  final String? time;
  final String? title;
  final String? hour;
  final String? location;
  final String? detail;
  final bool highlight;
  final bool isBreak;
  final String? breakLabel;
}

class ScheduleItem extends StatelessWidget {
  const ScheduleItem({
    super.key,
    required this.time,
    required this.title,
    required this.hour,
    required this.location,
    required this.detail,
    this.highlight = false,
  });

  final String time;
  final String title;
  final String hour;
  final String location;
  final String detail;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              time,
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(width: 2, height: 88, color: Colors.grey.shade300),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: highlight
                    ? const Border(
                        left: BorderSide(color: Colors.blue, width: 4),
                      )
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: highlight ? Colors.blue : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 5),
                      Text(hour),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 5),
                      Expanded(child: Text(location)),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 5),
                      Expanded(child: Text(detail)),
                    ],
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
