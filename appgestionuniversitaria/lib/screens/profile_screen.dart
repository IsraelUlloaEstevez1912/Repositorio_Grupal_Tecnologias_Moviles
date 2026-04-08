import 'package:flutter/material.dart';

import '../widgets/app_bottom_nav.dart';
import '../widgets/person_avatar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, this.userRole = 'estudiante'});

  final String userRole;

  bool get _isTeacher => userRole == 'docente';
  bool get _isAdmin => userRole == 'admin';

  String get _title {
    if (_isAdmin) {
      return 'Perfil Administrativo';
    }

    if (_isTeacher) {
      return 'Perfil del Docente';
    }

    return 'Perfil del Estudiante';
  }

  String get _name {
    if (_isAdmin) {
      return 'Mariana Rodriguez';
    }

    if (_isTeacher) {
      return 'Carlos Hernandez';
    }

    return 'Alejandro Johnson';
  }

  String get _subtitle {
    if (_isAdmin) {
      return 'Direccion Academica';
    }

    if (_isTeacher) {
      return 'Facultad de Ingenieria';
    }

    return 'Ingenieria de Sistemas';
  }

  String get _roleBadge {
    if (_isAdmin) {
      return 'ADMIN | OPERACIONES';
    }

    if (_isTeacher) {
      return 'DOCENTE | TIEMPO COMPLETO';
    }

    return 'ESTUDIANTE | 2DO ANO';
  }

  List<_ProfileStat> get _stats {
    if (_isAdmin) {
      return const [
        _ProfileStat(title: 'FACULTADES', value: '6'),
        _ProfileStat(title: 'DOCENTES', value: '85'),
        _ProfileStat(title: 'ALERTAS', value: '4'),
      ];
    }

    if (_isTeacher) {
      return const [
        _ProfileStat(title: 'SECCIONES', value: '6'),
        _ProfileStat(title: 'ESTUDIANTES', value: '114'),
        _ProfileStat(title: 'PENDIENTES', value: '18'),
      ];
    }

    return const [
      _ProfileStat(title: 'PROMEDIO', value: '4.85'),
      _ProfileStat(title: 'CREDITOS', value: '24'),
      _ProfileStat(title: 'RANKING', value: '18'),
    ];
  }

  List<_ProfileInfo> get _contactInfo {
    if (_isAdmin) {
      return const [
        _ProfileInfo(icon: Icons.email, text: 'm.rodriguez@universidad.edu'),
        _ProfileInfo(icon: Icons.phone, text: '+1 (809) 555-0184'),
        _ProfileInfo(
          icon: Icons.location_on,
          text: 'Edificio Administrativo, Piso 3',
        ),
      ];
    }

    if (_isTeacher) {
      return const [
        _ProfileInfo(icon: Icons.email, text: 'c.hernandez@universidad.edu'),
        _ProfileInfo(icon: Icons.phone, text: '+1 (809) 555-0108'),
        _ProfileInfo(
          icon: Icons.location_on,
          text: 'Cubiculo D-14, Facultad de Ingenieria',
        ),
      ];
    }

    return const [
      _ProfileInfo(icon: Icons.email, text: 'a.johnson@universidad.edu'),
      _ProfileInfo(icon: Icons.phone, text: '+57 (300) 123-4567'),
      _ProfileInfo(
        icon: Icons.location_on,
        text: 'Calle 123 #45-67, Torre 2 Apt 402',
      ),
    ];
  }

  List<_ProfileInfo> get _detailInfo {
    if (_isAdmin) {
      return const [
        _ProfileInfo(
          icon: Icons.badge_outlined,
          text: 'Cargo: Coordinadora Academica',
        ),
        _ProfileInfo(
          icon: Icons.calendar_today,
          text: 'Ingreso institucional: 10 Ene, 2021',
        ),
        _ProfileInfo(
          icon: Icons.check_circle,
          text: 'Estado: Operaciones activas',
        ),
      ];
    }

    if (_isTeacher) {
      return const [
        _ProfileInfo(
          icon: Icons.menu_book_outlined,
          text: 'Area: Estructuras de Datos',
        ),
        _ProfileInfo(icon: Icons.calendar_today, text: 'Ingreso: 12 Ago, 2019'),
        _ProfileInfo(icon: Icons.check_circle, text: 'Estado: Docencia activa'),
      ];
    }

    return const [
      _ProfileInfo(icon: Icons.calendar_today, text: 'Ingreso: 15 Ago, 2023'),
      _ProfileInfo(icon: Icons.school, text: 'Graduacion: Jun 2027'),
      _ProfileInfo(icon: Icons.check_circle, text: 'Estado: Regular'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text(_title, style: const TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Stack(
              children: [
                PersonAvatar(name: _name, radius: 45),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFF4A6CF7),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _name,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(_subtitle, style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _roleBadge,
                style: TextStyle(fontSize: 12, color: Colors.blue),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _stats
                  .asMap()
                  .entries
                  .expand(
                    (entry) => [
                      Expanded(
                        child: StatCard(
                          title: entry.value.title,
                          value: entry.value.value,
                        ),
                      ),
                      if (entry.key != _stats.length - 1)
                        const SizedBox(width: 8),
                    ],
                  )
                  .toList(),
            ),
            const SizedBox(height: 20),
            InfoCard(
              title: 'Informacion de Contacto',
              children: _contactInfo
                  .map((item) => InfoRow(icon: item.icon, text: item.text))
                  .toList(),
            ),
            const SizedBox(height: 16),
            InfoCard(
              title: _isAdmin
                  ? 'Detalles Administrativos'
                  : 'Detalles Academicos',
              children: _detailInfo
                  .map((item) => InfoRow(icon: item.icon, text: item.text))
                  .toList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(currentIndex: 4, userRole: userRole),
    );
  }
}

class _ProfileStat {
  const _ProfileStat({required this.title, required this.value});

  final String title;
  final String value;
}

class _ProfileInfo {
  const _ProfileInfo({required this.icon, required this.text});

  final IconData icon;
  final String text;
}

class StatCard extends StatelessWidget {
  const StatCard({super.key, required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({super.key, required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  const InfoRow({super.key, required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.blue),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
