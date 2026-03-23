import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/role_chip.dart';
import 'login_screen.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder<void>(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const LoginPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              ),
              child: child,
            );
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
              child: Column(
                children: [
                  const Spacer(flex: 7),
                  const _BrandShieldIcon(),
                  const SizedBox(height: 28),
                  Text(
                    'EduConnect',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1D2942),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'GESTION UNIVERSITARIA',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: const Color(0xFF2A63F3),
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2.2,
                    ),
                  ),
                  const Spacer(flex: 6),
                  SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      strokeWidth: 3.2,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF2A63F3),
                      ),
                      backgroundColor: const Color(0xFFE9EEF8),
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Cargando registros academicos...',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF74819A),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    runSpacing: 10,
                    children: const [
                      RoleChip(
                        icon: Icons.person_outline_rounded,
                        label: 'ESTUDIANTES',
                      ),
                      RoleChip(icon: Icons.school_outlined, label: 'DOCENTES'),
                      RoleChip(
                        icon: Icons.admin_panel_settings_outlined,
                        label: 'ADMIN',
                      ),
                    ],
                  ),
                  const Spacer(flex: 5),
                  Text(
                    '© 2026 SISTEMA DE GESTION UNIVERSITARIA',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: const Color(0xFFC6CFDE),
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 22),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BrandShieldIcon extends StatelessWidget {
  const _BrandShieldIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 116,
      height: 116,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2E73FF), Color(0xFF1F5BE8)],
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x25000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: const Center(
        child: Icon(Icons.shield_rounded, size: 56, color: Colors.white),
      ),
    );
  }
}
