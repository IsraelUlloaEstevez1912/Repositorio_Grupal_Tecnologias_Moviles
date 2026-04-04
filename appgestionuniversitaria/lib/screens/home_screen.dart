import 'package:flutter/material.dart';
import 'assignments_screen.dart';
import 'admin_dashboard_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, this.userRole = 'estudiante'});

  final String userRole;

  @override
  Widget build(BuildContext context) {
    // Si es admin, mostrar el dashboard
    if (userRole == 'admin') {
      return const AdminDashboardPage();
    }

    // Por defecto mostrar asignaturas (estudiantes y docentes)
    return const AssignmentsPage();
  }
}
