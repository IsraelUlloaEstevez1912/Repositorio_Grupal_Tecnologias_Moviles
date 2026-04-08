import 'package:flutter/material.dart';

import 'app_routes.dart';
import 'screens/home_page.dart';
import 'screens/home_screen.dart';
import 'screens/notifications.dart';
import 'screens/profile_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/student_schedule_page.dart';

void main() {
  runApp(const EduConnectApp());
}

class EduConnectApp extends StatelessWidget {
  const EduConnectApp({super.key});

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments is AppRouteArgs
        ? settings.arguments as AppRouteArgs
        : const AppRouteArgs();

    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute<void>(
          builder: (_) => HomeScreen(userRole: args.userRole),
          settings: settings,
        );
      case AppRoutes.schedule:
        return MaterialPageRoute<void>(
          builder: (_) => StudentSchedulePage(userRole: args.userRole),
          settings: settings,
        );
      case AppRoutes.center:
        return MaterialPageRoute<void>(
          builder: (_) => MyHomePage(userRole: args.userRole),
          settings: settings,
        );
      case AppRoutes.alerts:
        return MaterialPageRoute<void>(
          builder: (_) => NotificationsScreen(userRole: args.userRole),
          settings: settings,
        );
      case AppRoutes.profile:
        return MaterialPageRoute<void>(
          builder: (_) => ProfileScreen(userRole: args.userRole),
          settings: settings,
        );
      default:
        return MaterialPageRoute<void>(
          builder: (_) => const SplashPage(),
          settings: settings,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EduConnect',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8FAFE),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1F63F2),
          primary: const Color(0xFF1F63F2),
          surface: const Color(0xFFF8FAFE),
        ),
      ),
      onGenerateRoute: _onGenerateRoute,
      home: const SplashPage(),
    );
  }
}
