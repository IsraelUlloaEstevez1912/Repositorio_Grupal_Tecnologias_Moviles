// screens/grade_entry_screen.dart
import 'package:flutter/material.dart';

class GradeEntryScreen extends StatelessWidget {
  const GradeEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Registro de Calificaciones', style: TextStyle(color: Colors.black)),
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
                    onPressed: () {},
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 248, 255, 42),
                    ),
                    onPressed: () {},
                    child: const Text('Guardar Notas'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class StudentCard extends StatelessWidget {
  final String name;
  final String status;

  const StudentCard({super.key, required this.name, required this.status});

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
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6),
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
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isAlert ? Colors.orange.shade100 : Colors.green.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(status, style: TextStyle(color: isAlert ? Colors.orange : Colors.green, fontSize: 12)),
              )
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: const [
              Expanded(child: GradeInput(label: 'Parcial')),
              SizedBox(width: 8),
              Expanded(child: GradeInput(label: 'Final')),
              SizedBox(width: 8),
              Expanded(child: GradeInput(label: 'Proyecto')),
            ],
          )
        ],
      ),
    );
  }
}

class GradeInput extends StatelessWidget {
  final String label;

  const GradeInput({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return TextField(
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