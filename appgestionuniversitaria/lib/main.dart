import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const EduConnectApp());
}

class EduConnectApp extends StatelessWidget {
  const EduConnectApp({super.key});

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
      home: const SplashPage(),
    );
  }
}
