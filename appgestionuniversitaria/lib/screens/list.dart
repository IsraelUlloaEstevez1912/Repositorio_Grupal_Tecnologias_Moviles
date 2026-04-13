import 'package:flutter/material.dart';

import '../widgets/app_bottom_nav.dart';
import '../widgets/person_avatar.dart';

class Student {
  Student({
    required this.name,
    required this.id,
    required this.major,
    required this.imageUrl,
    this.status = 'Activo',
  });

  final String name;
  final String id;
  final String major;
  final String imageUrl;
  final String status;
}

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key, this.userRole = 'estudiante'});

  final String userRole;

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  final TextEditingController _searchController = TextEditingController();

  late List<Student> _allStudents;
  late List<Student> _filteredStudents;
  String _selectedFilter = 'Todas';

  @override
  void initState() {
    super.initState();
    _allStudents = [
      Student(
        name: 'Alicia Johnson',
        id: '2023001',
        major: 'INGENIERIA EN COMPUTACION',
        imageUrl: 'https://i.pravatar.cc/150?u=1',
        status: 'Activo',
      ),
      Student(
        name: 'Marcos Chen',
        id: '2023042',
        major: 'ARQUITECTURA',
        imageUrl: 'https://i.pravatar.cc/150?u=11',
        status: 'Activo',
      ),
      Student(
        name: 'Sofia Rodriguez',
        id: '2022115',
        major: 'MARKETING DIGITAL',
        imageUrl: 'https://i.pravatar.cc/150?u=5',
        status: 'Graduado',
      ),
      Student(
        name: 'David Kim',
        id: '2023088',
        major: 'INGENIERIA MECANICA',
        imageUrl: 'https://i.pravatar.cc/150?u=12',
        status: 'Activo',
      ),
      Student(
        name: 'Elena Vance',
        id: '2021005',
        major: 'PSICOLOGIA',
        imageUrl: 'https://i.pravatar.cc/150?u=9',
        status: 'Graduado',
      ),
      Student(
        name: 'Jordan Smith',
        id: '2023022',
        major: 'CIBERSEGURIDAD',
        imageUrl: 'https://i.pravatar.cc/150?u=13',
        status: 'Activo',
      ),
    ];
    _filteredStudents = List<Student>.from(_allStudents);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      _filteredStudents = _allStudents.where((student) {
        final matchesQuery = student.name.toLowerCase().contains(query) ||
            student.id.toLowerCase().contains(query) ||
            student.major.toLowerCase().contains(query);

        bool matchesFilter = true;
        if (_selectedFilter == 'Activos') {
          matchesFilter = student.status == 'Activo';
        } else if (_selectedFilter == 'Graduados') {
          matchesFilter = student.status == 'Graduado';
        }

        return matchesQuery && matchesFilter;
      }).toList();
    });
  }

  void _setFilter(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
    _onSearchChanged();
  }

  void _showStudentDetails(Student student) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Perfil de Estudiante',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PersonAvatar(name: student.name, radius: 40),
              const SizedBox(height: 16),
              Text(
                student.name,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text('ID: ${student.id}', style: const TextStyle(fontSize: 14)),
              Text('Carrera: ${student.major}', style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 4),
              Text(
                'Estado: ${student.status}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: student.status == 'Activo' ? Colors.green : Colors.blueGrey,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  void _showAddStudentDialog() {
    final nameController = TextEditingController();
    final idController = TextEditingController();
    final majorController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Agregar Estudiante',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
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
                    labelText: 'ID / Matricula',
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
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1D4ED8),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                if (nameController.text.isEmpty || idController.text.isEmpty) {
                  return;
                }

                final newStudent = Student(
                  name: nameController.text,
                  id: idController.text,
                  major: majorController.text.toUpperCase(),
                  imageUrl: 'https://i.pravatar.cc/150?u=${idController.text}',
                );

                setState(() {
                  _allStudents.add(newStudent);
                });

                _onSearchChanged();
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Estudiante agregado correctamente.'),
                  ),
                );
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildChip(
    String label, {
    bool isSelected = false,
    bool hasDropdown = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 18 : 14,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2563EB) : Colors.white,
          borderRadius: BorderRadius.circular(20),
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
            ],
          ],
        ),
      ),
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
          onPressed: () => Navigator.maybePop(context),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar por nombre, ID o carrera',
                  hintStyle: const TextStyle(
                    color: Colors.black38,
                    fontSize: 14,
                  ),
                  prefixIcon: const Icon(Icons.search, color: Colors.black38),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.black38),
                          onPressed: _searchController.clear,
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildChip(
                  'Todas las Carreras',
                  isSelected: _selectedFilter == 'Todas',
                  onTap: () => _setFilter('Todas'),
                ),
                const SizedBox(width: 8),
                _buildChip(
                  'Activos',
                  isSelected: _selectedFilter == 'Activos',
                  hasDropdown: true,
                  onTap: () => _setFilter('Activos'),
                ),
                const SizedBox(width: 8),
                _buildChip(
                  'Graduados',
                  isSelected: _selectedFilter == 'Graduados',
                  onTap: () => _setFilter('Graduados'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _filteredStudents.isEmpty
                ? const Center(
                    child: Text(
                      'No hay estudiantes registrados o no coinciden con la busqueda.',
                      style: TextStyle(color: Colors.black45),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredStudents.length,
                    itemBuilder: (context, index) {
                      final student = _filteredStudents[index];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.02),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ListTile(
                            isThreeLine: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            leading: PersonAvatar(
                              name: student.name,
                              radius: 26,
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
                            onTap: () => _showStudentDetails(student),
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
        padding: const EdgeInsets.only(bottom: 8),
        child: SizedBox(
          height: 48,
          child: FloatingActionButton.extended(
            backgroundColor: const Color(0xFF1D4ED8),
            elevation: 4,
            onPressed: _showAddStudentDialog,
            icon: const Icon(
              Icons.person_add_alt_1,
              color: Colors.white,
              size: 20,
            ),
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
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 2,
        userRole: widget.userRole,
        isRootDestination: false,
      ),
    );
  }
}
