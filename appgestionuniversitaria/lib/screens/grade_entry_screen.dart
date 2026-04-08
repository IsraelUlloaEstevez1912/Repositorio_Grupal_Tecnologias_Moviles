import 'package:flutter/material.dart';

import '../widgets/app_bottom_nav.dart';

class GradeEntryScreen extends StatelessWidget {
  const GradeEntryScreen({super.key, this.userRole = 'estudiante'});

  final String userRole;

  void _showSavedMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Las calificaciones se guardaron correctamente.'),
      ),
    );
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
        title: const Text(
          'Registro de Calificaciones',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: const [
                  StudentCard(name: 'Alice Johnson', status: 'REGULAR'),
                  StudentCard(name: 'Bob Smith', status: 'REGULAR'),
                  StudentCard(name: 'Charlie Davis', status: 'ALERTA'),
                  StudentCard(name: 'Diana Prince', status: 'REGULAR'),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.maybePop(context),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF8FF2A),
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () => _showSavedMessage(context),
                    child: const Text('Guardar Notas'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 2,
        userRole: userRole,
        isRootDestination: false,
      ),
    );
  }
}

class StudentCard extends StatelessWidget {
  const StudentCard({super.key, required this.name, required this.status});

  final String name;
  final String status;

  @override
  Widget build(BuildContext context) {
    final isAlert = status == 'ALERTA';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isAlert
                      ? Colors.orange.shade100
                      : Colors.green.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: isAlert ? Colors.orange : Colors.green,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Row(
            children: [
              Expanded(child: GradeInput(label: 'Parcial')),
              SizedBox(width: 8),
              Expanded(child: GradeInput(label: 'Final')),
              SizedBox(width: 8),
              Expanded(child: GradeInput(label: 'Proyecto')),
            ],
          ),
        ],
      ),
    );
  }
}

class GradeInput extends StatelessWidget {
  const GradeInput({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: const Color(0xFFF1F3F6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
