import 'package:flutter/material.dart';

class AcademicReportsPage extends StatelessWidget {
  const AcademicReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Horario"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Notas"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
        ],
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            PerformanceCard(),
            SizedBox(height: 16),
            EnrollmentCard(),
            SizedBox(height: 16),
            FacultyCard(),
          ],
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////
// 📊 RENDIMIENTO
//////////////////////////////////////////////////

class PerformanceCard extends StatelessWidget {
  const PerformanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: cardStyle(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Rendimiento Estudiantil",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("Tendencia de Promedio General",
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text("+2.4%",
                    style: TextStyle(color: Colors.green)),
              )
            ],
          ),

          const SizedBox(height: 10),

          const Text("3.62",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),

          const Text("Promedio Semestre Actual",
              style: TextStyle(color: Colors.grey)),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              BarItem(height: 60, label: "SEM 1"),
              BarItem(height: 80, label: "SEM 2"),
              BarItem(height: 50, label: "SEM 3"),
              BarItem(height: 100, label: "SEM 4", highlight: true),
            ],
          )
        ],
      ),
    );
  }
}

class BarItem extends StatelessWidget {
  final double height;
  final String label;
  final bool highlight;

  const BarItem({
    super.key,
    required this.height,
    required this.label,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 30,
          height: height,
          decoration: BoxDecoration(
            color: highlight ? Colors.blue : Colors.blue.withOpacity(0.4),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontSize: 10))
      ],
    );
  }
}

//////////////////////////////////////////////////
// 🎓 DISTRIBUCIÓN MATRÍCULAS
//////////////////////////////////////////////////

class EnrollmentCard extends StatelessWidget {
  const EnrollmentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: cardStyle(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Distribución de Matrículas",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              Text("TOTAL", style: TextStyle(color: Colors.grey)),
              Text("12.4k",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              LegendItem("Pregrado (65%)", Colors.blue),
              LegendItem("Posgrado (20%)", Colors.blueAccent),
              LegendItem("Doctorado (15%)", Colors.lightBlue),
            ],
          )
        ],
      ),
    );
  }
}

class LegendItem extends StatelessWidget {
  final String text;
  final Color color;

  const LegendItem(this.text, this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          CircleAvatar(radius: 5, backgroundColor: color),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }
}

//////////////////////////////////////////////////
// 👨‍🏫 DISTRIBUCIÓN DOCENTE
//////////////////////////////////////////////////

class FacultyCard extends StatelessWidget {
  const FacultyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: cardStyle(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text("Distribución Docente",
              style: TextStyle(fontWeight: FontWeight.bold)),

          SizedBox(height: 20),

          FacultyItem("Facultad STEM", "142 Miembros", 0.8),
          FacultyItem("Artes y Humanidades", "86 Miembros", 0.5),
          FacultyItem("Escuela de Negocios", "64 Miembros", 0.4),
        ],
      ),
    );
  }
}

class FacultyItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final double progress;

  const FacultyItem(this.title, this.subtitle, this.progress, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          const Icon(Icons.school, color: Colors.blue),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(subtitle, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),

          SizedBox(
            width: 80,
            child: LinearProgressIndicator(
              value: progress,
              color: Colors.blue,
              backgroundColor: Colors.grey[300],
            ),
          )
        ],
      ),
    );
  }
}

//////////////////////////////////////////////////
// 🎨 ESTILO GENERAL
//////////////////////////////////////////////////

BoxDecoration cardStyle() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: const [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 5,
      )
    ],
  );
}

