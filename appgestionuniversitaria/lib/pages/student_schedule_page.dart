import 'package:flutter/material.dart';

class StudentSchedulePage extends StatelessWidget {
  const StudentSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Horario"),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: "Notas"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
        ],
      ),

      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),

            SizedBox(
              height: 60,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  dateItem("12", true),
                  dateItem("13", false),
                  dateItem("14", false),
                  dateItem("15", false),
                  dateItem("16", false),
                ],
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: const [
                  ScheduleItem(
                    time: "08:00",
                    title: "Matemáticas Avanzadas",
                    hour: "08:00 AM - 09:30 AM",
                    location: "Aula 402, Ala de Ciencias",
                    highlight: true,
                  ),
                  ScheduleItem(
                    time: "10:00",
                    title: "Ciencias de la Computación 101",
                    hour: "10:00 AM - 11:30 AM",
                    location: "Aula 105, Biblioteca Central",
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text("ALMUERZO",
                          style: TextStyle(color: Colors.grey)),
                    ),
                  ),
                  ScheduleItem(
                    time: "13:00",
                    title: "Laboratorio de Física",
                    hour: "01:00 PM - 03:00 PM",
                    location: "Pabellón B, Lab 2",
                  ),
                  ScheduleItem(
                    time: "15:30",
                    title: "Historia del Arte",
                    hour: "03:30 PM - 05:00 PM",
                    location: "Edificio de Artes, Galería 1",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dateItem(String day, bool selected) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
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
}

class ScheduleItem extends StatelessWidget {
  final String time;
  final String title;
  final String hour;
  final String location;
  final bool highlight;

  const ScheduleItem({
    super.key,
    required this.time,
    required this.title,
    required this.hour,
    required this.location,
    this.highlight = false,
  });

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
          Container(
            width: 2,
            height: 80,
            color: Colors.grey.shade300,
          ),
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
                      const Icon(Icons.access_time, size: 16, color: Colors.grey),
                      const SizedBox(width: 5),
                      Text(hour),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: Colors.grey),
                      const SizedBox(width: 5),
                      Expanded(child: Text(location)),
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

