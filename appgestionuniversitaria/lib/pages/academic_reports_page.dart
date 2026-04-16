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
          children: [
            const PerformanceCard(),
            const SizedBox(height: 16),
            const EnrollmentCard(),
            const SizedBox(height: 16),
            const FacultyCard(),
            const SizedBox(height: 16),
            const SubjectManagementCard(),
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
        ],
      ),
    );
  }
}

//////////////////////////////////////////////////
// 🎓 MATRÍCULAS
//////////////////////////////////////////////////

class EnrollmentCard extends StatelessWidget {
  const EnrollmentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: cardStyle(),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Distribución de Matrículas",
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text("TOTAL: 12.4k", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

//////////////////////////////////////////////////
// 👨‍🏫 DOCENTES
//////////////////////////////////////////////////

class FacultyCard extends StatelessWidget {
  const FacultyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: cardStyle(),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Distribución Docente",
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text("Facultad STEM - 142 miembros"),
          Text("Artes - 86 miembros"),
        ],
      ),
    );
  }
}

//////////////////////////////////////////////////
// 📚 GESTIÓN DE ASIGNATURAS PRO
//////////////////////////////////////////////////

class Subject {
  String name;
  String code;
  int credits;
  String teacher;

  Subject({
    required this.name,
    required this.code,
    required this.credits,
    required this.teacher,
  });
}

class SubjectManagementCard extends StatefulWidget {
  const SubjectManagementCard({super.key});

  @override
  State<SubjectManagementCard> createState() =>
      _SubjectManagementCardState();
}

class _SubjectManagementCardState extends State<SubjectManagementCard> {
  final List<Subject> subjects = [
    Subject(name: "Matemáticas", code: "MAT101", credits: 3, teacher: "Juan Pérez"),
    Subject(name: "Programación", code: "CS102", credits: 4, teacher: "Ana López"),
  ];

  final TextEditingController searchController = TextEditingController();

  List<Subject> get filtered {
    final query = searchController.text.toLowerCase();
    return subjects.where((s) {
      return s.name.toLowerCase().contains(query) ||
          s.code.toLowerCase().contains(query);
    }).toList();
  }

  void openForm({Subject? subject}) {
    final nameCtrl = TextEditingController(text: subject?.name ?? "");
    final codeCtrl = TextEditingController(text: subject?.code ?? "");
    final creditsCtrl =
        TextEditingController(text: subject?.credits.toString() ?? "");
    final teacherCtrl = TextEditingController(text: subject?.teacher ?? "");

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(subject == null ? "Nueva Asignatura" : "Editar Asignatura"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Nombre")),
              TextField(controller: codeCtrl, decoration: const InputDecoration(labelText: "Código")),
              TextField(
                controller: creditsCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Créditos"),
              ),
              TextField(controller: teacherCtrl, decoration: const InputDecoration(labelText: "Profesor")),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.isEmpty ||
                  codeCtrl.text.isEmpty ||
                  creditsCtrl.text.isEmpty ||
                  teacherCtrl.text.isEmpty) return;

              final credits = int.tryParse(creditsCtrl.text);
              if (credits == null) return;

              final exists = subjects.any((s) =>
                  s.code == codeCtrl.text && s != subject);

              if (exists) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Código ya existe")),
                );
                return;
              }

              setState(() {
                if (subject == null) {
                  subjects.add(Subject(
                    name: nameCtrl.text,
                    code: codeCtrl.text,
                    credits: credits,
                    teacher: teacherCtrl.text,
                  ));
                } else {
                  subject.name = nameCtrl.text;
                  subject.code = codeCtrl.text;
                  subject.credits = credits;
                  subject.teacher = teacherCtrl.text;
                }
              });

              Navigator.pop(context);
            },
            child: const Text("Guardar"),
          ),
        ],
      ),
    );
  }

  void deleteSubject(Subject subject) {
    setState(() {
      subjects.remove(subject);
    });
  }

  @override
  Widget build(BuildContext context) {
    final list = filtered;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: cardStyle(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  "Gestión de Asignaturas",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                onPressed: () => openForm(),
                icon: const Icon(Icons.add, color: Colors.blue),
              )
            ],
          ),

          TextField(
            controller: searchController,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              hintText: "Buscar asignatura...",
              prefixIcon: Icon(Icons.search),
            ),
          ),

          const SizedBox(height: 10),

          if (list.isEmpty)
            const Text("No hay asignaturas",
                style: TextStyle(color: Colors.grey)),

          ...list.map((subject) {
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.book, color: Colors.blue),
              title: Text(subject.name),
              subtitle: Text(
                  "${subject.code} • ${subject.credits} créditos • ${subject.teacher}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.orange),
                    onPressed: () => openForm(subject: subject),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteSubject(subject),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

//////////////////////////////////////////////////
// 🎨 ESTILO
//////////////////////////////////////////////////

BoxDecoration cardStyle() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: const [
      BoxShadow(color: Colors.black12, blurRadius: 5),
    ],
  );
}
