import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

class Student {
  final String name;
  final String id;
  final String major;
  final String imageUrl;

  Student({
    required this.name,
    required this.id,
    required this.major,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'major': major,
        'imageUrl': imageUrl,
      };

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      name: json['name'],
      id: json['id'],
      major: json['major'],
      imageUrl: json['imageUrl'],
    );
  }
}

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  List<Student> _allStudents = [];
  List<Student> _filteredStudents = [];
  final TextEditingController _searchController = TextEditingController();

  // Ruta del archivo temporal
  File get _tempFile {
    final tempDir = Directory.systemTemp.path;
    return File('$tempDir/students.json');
  }

  @override
  void initState() {
    super.initState();
    _loadStudents();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadStudents() async {
    try {
      final file = _tempFile;
      if (await file.exists()) {
        final contents = await file.readAsString();
        final List<dynamic> jsonList = jsonDecode(contents);
        setState(() {
          _allStudents = jsonList.map((j) => Student.fromJson(j)).toList();
          _filteredStudents = List.from(_allStudents);
        });
      } else {
        // Datos por defecto si el archivo aún no existe
        setState(() {
          _allStudents = [
            Student(name: 'Alicia Johnson', id: '2023001', major: 'INGENIERÍA EN COMPUTACIÓN', imageUrl: 'https://i.pravatar.cc/150?u=1'),
            Student(name: 'Marcos Chen', id: '2023042', major: 'ARQUITECTURA', imageUrl: 'https://i.pravatar.cc/150?u=11'),
            Student(name: 'Sofía Rodríguez', id: '2022115', major: 'MARKETING DIGITAL', imageUrl: 'https://i.pravatar.cc/150?u=5'),
            Student(name: 'David Kim', id: '2023088', major: 'INGENIERÍA MECÁNICA', imageUrl: 'https://i.pravatar.cc/150?u=12'),
            Student(name: 'Elena Vance', id: '2021005', major: 'PSICOLOGÍA', imageUrl: 'https://i.pravatar.cc/150?u=9'),
            Student(name: 'Jordan Smith', id: '2023022', major: 'CIBERSEGURIDAD', imageUrl: 'https://i.pravatar.cc/150?u=13'),
          ];
          _filteredStudents = List.from(_allStudents);
        });
        await _saveStudents(); 
      }
    } catch (e) {
      debugPrint('Error loading students: $e');
    }
  }

  Future<void> _saveStudents() async {
    try {
      final file = _tempFile;
      final jsonList = _allStudents.map((s) => s.toJson()).toList();
      await file.writeAsString(jsonEncode(jsonList));
    } catch (e) {
      debugPrint('Error saving students: $e');
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredStudents = List.from(_allStudents);
      } else {
        _filteredStudents = _allStudents.where((student) {
          return student.name.toLowerCase().contains(query) ||
                 student.id.toLowerCase().contains(query) ||
                 student.major.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  void _showAddStudentDialog() {
    final nameController = TextEditingController();
    final idController = TextEditingController();
    final majorController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Agregar Estudiante', style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre Completo',
                    icon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: idController,
                  decoration: const InputDecoration(
                    labelText: 'ID / Matrícula',
                    icon: Icon(Icons.badge),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: majorController,
                  decoration: const InputDecoration(
                    labelText: 'Carrera',
                    icon: Icon(Icons.school),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1D4ED8),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () async {
                if (nameController.text.isNotEmpty && idController.text.isNotEmpty) {
                  final newStudent = Student(
                    name: nameController.text,
                    id: idController.text,
                    major: majorController.text.toUpperCase(),
                    // Generar un avatar usando el ID como seed
                    imageUrl: 'https://i.pravatar.cc/150?u=${idController.text}',
                  );
                  
                  setState(() {
                    _allStudents.add(newStudent);
                  });
                  
                  await _saveStudents(); // Guarda en el archivo JSON temporal
                  _onSearchChanged(); // Actualiza el filtro actual de búsqueda
                  
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Estudiante guardado en archivo temporal con éxito'))
                    );
                  }
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F6F9),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1E293B)),
          onPressed: () {},
        ),
        title: const Text(
          'Lista de Estudiantes',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Color(0xFF1E293B)),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Search Bar interactiva
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar por nombre, ID o carrera',
                  hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
                  prefixIcon: const Icon(Icons.search, color: Colors.black38),
                  suffixIcon: _searchController.text.isNotEmpty 
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.black38),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14.0),
                ),
              ),
            ),
          ),
          
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                _buildChip('Todas las Carreras', isSelected: true),
                const SizedBox(width: 8),
                _buildChip('Activos', hasDropdown: true),
                const SizedBox(width: 8),
                _buildChip('Graduados'),
              ],
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Student List
          Expanded(
            child: _filteredStudents.isEmpty
              ? const Center(
                  child: Text(
                    'No hay estudiantes registrados o no coinciden con la búsqueda.',
                    style: TextStyle(color: Colors.black45),
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: _filteredStudents.length,
                  itemBuilder: (context, index) {
                    final student = _filteredStudents[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                          leading: CircleAvatar(
                            radius: 26,
                            backgroundColor: Colors.grey.shade200,
                            backgroundImage: NetworkImage(student.imageUrl),
                          ),
                          title: Text(
                            student.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1E293B),
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 2),
                              Text(
                                'ID: ${student.id}',
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                student.major,
                                style: const TextStyle(
                                  color: Color(0xFF2563EB), 
                                  fontWeight: FontWeight.w800,
                                  fontSize: 11,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          trailing: const Icon(
                            Icons.chevron_right,
                            color: Colors.black26,
                          ),
                          onTap: () {},
                        ),
                      ),
                    );
                  },
                ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: SizedBox(
          height: 48,
          child: FloatingActionButton.extended(
            backgroundColor: const Color(0xFF1D4ED8), 
            elevation: 4,
            onPressed: () => _showAddStudentDialog(),
            icon: const Icon(Icons.person_add_alt_1, color: Colors.white, size: 20),
            label: const Text(
              'Agregar Estudiante',
              style: TextStyle(
                color: Colors.white, 
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF2563EB),
          unselectedItemColor: Colors.black45,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
          currentIndex: 1, 
          iconSize: 26,
          items: const [
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Icon(Icons.home_outlined),
              ),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Icon(Icons.people),
              ),
              label: 'Estudiantes',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Icon(Icons.menu_book_outlined),
              ),
              label: 'Cursos',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Icon(Icons.settings_outlined),
              ),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label, {bool isSelected = false, bool hasDropdown = false}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSelected ? 18.0 : 14.0, 
        vertical: 8.0
      ),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF2563EB) : Colors.white,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF1E293B),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              fontSize: 13,
            ),
          ),
          if (hasDropdown) ...[
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down,
              size: 20,
              color: isSelected ? Colors.white : const Color(0xFF1E293B),
            ),
          ]
        ],
      ),
    );
  }
}
