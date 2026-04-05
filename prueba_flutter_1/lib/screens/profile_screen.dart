// screens/profile_screen.dart
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        title: const Text('Perfil del Estudiante', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Stack(
              children: [
                const CircleAvatar(
                  radius: 45,
                  backgroundImage: NetworkImage('https://i.pravatar.cc/150'),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFF4A6CF7),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.edit, color: Colors.white, size: 16),
                  ),
                )
              ],
            ),
            const SizedBox(height: 12),
            const Text('Alejandro Johnson', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text('Ingeniería de Sistemas', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text('ESTUDIANTE • 2DO AÑO', style: TextStyle(fontSize: 12, color: Colors.blue)),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Expanded(child: StatCard(title: 'PROMEDIO', value: '4.85')),
                SizedBox(width: 8),
                Expanded(child: StatCard(title: 'CRÉDITOS', value: '24')),
                SizedBox(width: 8),
                Expanded(child: StatCard(title: 'RANKING', value: '18')),
              ],
            ),

            const SizedBox(height: 20),

            const InfoCard(
              title: 'Información de Contacto',
              children: [
                InfoRow(icon: Icons.email, text: 'a.johnson@universidad.edu'),
                InfoRow(icon: Icons.phone, text: '+57 (300) 123-4567'),
                InfoRow(icon: Icons.location_on, text: 'Calle 123 #45-67, Torre 2 Apt 402'),
              ],
            ),

            const SizedBox(height: 16),

            const InfoCard(
              title: 'Detalles Académicos',
              children: [
                InfoRow(icon: Icons.calendar_today, text: 'Ingreso: 15 Ago, 2023'),
                InfoRow(icon: Icons.school, text: 'Graduación: Jun 2027'),
                InfoRow(icon: Icons.check_circle, text: 'Estado: Regular'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;

  const StatCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6),
        ],
      ),
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const InfoCard({super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6),
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
  final IconData icon;
  final String text;

  const InfoRow({super.key, required this.icon, required this.text});

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
