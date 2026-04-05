import 'package:flutter/material.dart';
import 'matricula.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AppGestiónUniversitaria',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB)),
        scaffoldBackgroundColor: const Color(0xFFF4F6F9),
        useMaterial3: true,
        fontFamily: 'Inter',
      ),
      home: const MatriculaScreen(), // Pantalla de Gestión de Matrícula
    );
  }
}
