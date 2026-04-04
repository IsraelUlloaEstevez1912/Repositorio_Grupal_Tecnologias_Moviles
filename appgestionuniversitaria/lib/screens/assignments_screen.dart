import 'package:flutter/material.dart';

class AssignmentsPage extends StatefulWidget {
  const AssignmentsPage({super.key});

  @override
  State<AssignmentsPage> createState() => _AssignmentsPageState();
}

class _AssignmentsPageState extends State<AssignmentsPage> {
  late List<Map<String, dynamic>> _allAssignments;
  List<Map<String, dynamic>> _filteredAssignments = [];
  String _selectedTab = 'todos';
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _initializeAssignments();
  }

  void _initializeAssignments() {
    _allAssignments = [
      {
        'code': 'MAT301',
        'name': 'Matemáticas Avanzadas II',
        'department': 'Ingeniería',
        'professor': 'Dra. Sarah Jenkins',
        'nextClass': 'Lunes, 09:00 AM',
        'status': 'activa',
        'color': const Color(0xFF2D5016),
        'image':
            'assets/images/math.jpg', // You can replace with actual images
      },
      {
        'code': 'CS204',
        'name': 'Estructuras de Datos y Algoritmos',
        'department': 'Ciencias de la Computación',
        'professor': 'Prof. Michael Chen',
        'nextClass': 'Mañana, 11:30 AM',
        'status': 'activa',
        'color': const Color(0xFF1B5E7A),
        'image': 'assets/images/data_structures.jpg',
      },
      {
        'code': 'FIS102',
        'name': 'Bases de Física Cuántica',
        'department': 'Departamento de Ciencias',
        'professor': 'Dra. Elena Rodríguez',
        'nextClass': 'Miércoles, 2:00 PM',
        'status': 'activa',
        'color': const Color(0xFF1A1A2E),
        'image': 'assets/images/physics.jpg',
      },
      {
        'code': 'ENG101',
        'name': 'English Literature',
        'department': 'Humanidades',
        'professor': 'Dr. James Smith',
        'nextClass': 'Jueves, 10:00 AM',
        'status': 'archivada',
        'color': const Color(0xFF6B4C3A),
        'image': 'assets/images/english.jpg',
      },
    ];
    _filterAssignments();
  }

  void _filterAssignments() {
    final query = _searchController.text.toLowerCase();
    List<Map<String, dynamic>> filtered = _allAssignments;

    // Filter by tab
    if (_selectedTab != 'todos') {
      if (_selectedTab == 'activas') {
        filtered = filtered.where((a) => a['status'] == 'activa').toList();
      } else if (_selectedTab == 'archivadas') {
        filtered = filtered.where((a) => a['status'] == 'archivada').toList();
      }
    }

    // Filter by search
    if (query.isNotEmpty) {
      filtered = filtered
          .where((a) =>
              a['code'].toString().toLowerCase().contains(query) ||
              a['name'].toString().toLowerCase().contains(query))
          .toList();
    }

    setState(() {
      _filteredAssignments = filtered;
    });
  }

  void _onTabChanged(String tab) {
    setState(() {
      _selectedTab = tab;
    });
    _filterAssignments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Gestión de Asignaturas',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => _filterAssignments(),
              decoration: InputDecoration(
                hintText: 'Buscar asignaturas, códigos...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Color(0xFFE0E0E0), width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Color(0xFFE0E0E0), width: 1),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),

          // Tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildTab('Todos', 'todos'),
                const SizedBox(width: 16),
                _buildTab('Activas', 'activas'),
                const SizedBox(width: 16),
                _buildTab('Archivadas', 'archivadas'),
                const SizedBox(width: 16),
                _buildTab('Facultad', 'facultad'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Assignments List
          Expanded(
            child: _filteredAssignments.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.assignment_outlined,
                            size: 64, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text(
                          'No hay asignaturas',
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 16),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredAssignments.length,
                    itemBuilder: (context, index) {
                      final assignment = _filteredAssignments[index];
                      return _buildAssignmentCard(assignment);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: const Color(0xFF1F63F2),
        label: const Text('Nueva Asignatura'),
        icon: const Icon(Icons.add),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildTab(String label, String value) {
    final isSelected = _selectedTab == value;
    return GestureDetector(
      onTap: () => _onTabChanged(value),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFF1F63F2) : Colors.grey[600],
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          if (isSelected)
            Container(
              height: 3,
              width: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF1F63F2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAssignmentCard(Map<String, dynamic> assignment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Color bar
          Container(
            width: 6,
            height: 140,
            decoration: BoxDecoration(
              color: assignment['color'],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
          ),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          assignment['code'],
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        assignment['department'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    assignment['name'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.grey[300],
                        child: Text(
                          assignment['professor'][0],
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              assignment['professor'],
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              'Próxima Clase: ${assignment['nextClass']}',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.edit,
                            size: 18, color: Color(0xFF1F63F2)),
                        label: const Text(
                          'Editar',
                          style: TextStyle(
                            color: Color(0xFF1F63F2),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Image placeholder
          Container(
            width: 100,
            height: 140,
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: assignment['color'].withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.book,
              color: assignment['color'],
              size: 48,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFF1F63F2),
      unselectedItemColor: Colors.grey[600],
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment),
          label: 'Asignaturas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Horario',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
