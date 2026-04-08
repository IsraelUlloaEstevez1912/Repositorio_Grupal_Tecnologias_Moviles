import 'package:flutter/material.dart';

import '../app_routes.dart';

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.userRole,
    this.isRootDestination = true,
  });

  final int currentIndex;
  final String userRole;
  final bool isRootDestination;

  static const List<String> _routes = [
    AppRoutes.home,
    AppRoutes.schedule,
    AppRoutes.center,
    AppRoutes.alerts,
    AppRoutes.profile,
  ];

  void _handleTap(BuildContext context, int index) {
    if (index == currentIndex && isRootDestination) {
      return;
    }

    Navigator.of(context).pushReplacementNamed(
      _routes[index],
      arguments: AppRouteArgs(userRole: userRole),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: const TextScaler.linear(0.95)),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          currentIndex: currentIndex,
          iconSize: 22,
          selectedFontSize: 10,
          unselectedFontSize: 10,
          selectedItemColor: const Color(0xFF2563EB),
          unselectedItemColor: const Color(0xFF8B95A7),
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 10,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 10,
          ),
          onTap: (index) => _handleTap(context, index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_outlined),
              activeIcon: Icon(Icons.calendar_month_rounded),
              label: 'Horario',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard_rounded),
              label: 'Centro',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_none_rounded),
              activeIcon: Icon(Icons.notifications_rounded),
              label: 'Alertas',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }
}
