import 'package:flutter/material.dart';
import '../widgets/role_chip.dart';
import 'home_screen.dart';

const _desktopLoginImageAsset = 'assets/images/login_students.jpg';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscurePassword = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 980;

        if (isDesktop) {
          return _DesktopLoginLayout(
            obscurePassword: _obscurePassword,
            onTogglePassword: _togglePasswordVisibility,
          );
        }

        return _MobileLoginLayout(
          obscurePassword: _obscurePassword,
          onTogglePassword: _togglePasswordVisibility,
          isTablet: constraints.maxWidth >= 680,
        );
      },
    );
  }
}

class _DesktopLoginLayout extends StatelessWidget {
  const _DesktopLoginLayout({
    required this.obscurePassword,
    required this.onTogglePassword,
  });

  final bool obscurePassword;
  final VoidCallback onTogglePassword;

  @override
  Widget build(BuildContext context) {
    final viewport = MediaQuery.sizeOf(context);
    final compactDesktop = viewport.height < 980 || viewport.width < 1400;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FC),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF7F9FE), Color(0xFFEEF3FB)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(compactDesktop ? 18 : 28),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: compactDesktop ? 1120 : 1220,
                ),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        flex: compactDesktop ? 10 : 11,
                        child: _DesktopShowcasePanel(compact: compactDesktop),
                      ),
                      SizedBox(width: compactDesktop ? 20 : 28),
                      SizedBox(
                        width: compactDesktop ? 430 : 470,
                        child: _DesktopLoginCard(
                          obscurePassword: obscurePassword,
                          onTogglePassword: onTogglePassword,
                          compact: compactDesktop,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MobileLoginLayout extends StatelessWidget {
  const _MobileLoginLayout({
    required this.obscurePassword,
    required this.onTogglePassword,
    required this.isTablet,
  });

  final bool obscurePassword;
  final VoidCallback onTogglePassword;
  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    final borderRadius = isTablet ? 30.0 : 0.0;
    final pagePadding = isTablet
        ? const EdgeInsets.symmetric(horizontal: 24, vertical: 24)
        : EdgeInsets.zero;

    return Scaffold(
      backgroundColor: isTablet
          ? const Color(0xFFF3F6FC)
          : const Color(0xFFF8FAFE),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: pagePadding,
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isTablet ? 620 : double.infinity,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(borderRadius),
                  boxShadow: isTablet
                      ? const [
                          BoxShadow(
                            color: Color(0x1417263D),
                            blurRadius: 24,
                            offset: Offset(0, 14),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  children: [
                    _LoginTopBar(
                      horizontalPadding: isTablet
                          ? const EdgeInsets.fromLTRB(18, 18, 22, 18)
                          : const EdgeInsets.fromLTRB(8, 10, 18, 18),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 26 : 0,
                        vertical: isTablet ? 10 : 0,
                      ),
                      child: _LoginHeroBanner(
                        height: isTablet ? 180 : 142,
                        borderRadius: isTablet ? 24 : 0,
                        iconBoxWidth: isTablet ? 82 : 66,
                        iconBoxHeight: isTablet ? 74 : 58,
                        iconSize: isTablet ? 40 : 34,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        isTablet ? 34 : 24,
                        30,
                        isTablet ? 34 : 24,
                        30,
                      ),
                      child: Column(
                        children: [
                          const _LoginWelcomeText(),
                          const SizedBox(height: 30),
                          _LoginFormFields(
                            obscurePassword: obscurePassword,
                            onTogglePassword: onTogglePassword,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DesktopShowcasePanel extends StatelessWidget {
  const _DesktopShowcasePanel({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(compact ? 26 : 36),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(compact ? 30 : 36),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D4FE0), Color(0xFF4BA2FF)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A0D4FE0),
            blurRadius: 28,
            offset: Offset(0, 18),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: -40,
            top: -20,
            child: Container(
              width: compact ? 140 : 180,
              height: compact ? 140 : 180,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x14FFFFFF),
              ),
            ),
          ),
          Positioned(
            right: -60,
            bottom: -60,
            child: Container(
              width: compact ? 180 : 260,
              height: compact ? 180 : 260,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x12FFFFFF),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: compact ? 50 : 56,
                    height: compact ? 50 : 56,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.school_outlined,
                      color: const Color(0xFF1F63F2),
                      size: compact ? 26 : 30,
                    ),
                  ),
                  SizedBox(width: compact ? 12 : 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'EduConnect',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: compact ? 22 : 24,
                            ),
                      ),
                      Text(
                        'Campus digital universitario',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xD9FFFFFF),
                          fontWeight: FontWeight.w500,
                          fontSize: compact ? 13 : 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: compact ? 18 : 30),
              Expanded(
                child: Center(
                  child: _DesktopStudentPhotoCard(compact: compact),
                ),
              ),
              SizedBox(height: compact ? 20 : 28),
              Text(
                'Todo tu acceso academico en una sola plataforma',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                  fontSize: compact ? 32 : 38,
                ),
              ),
              SizedBox(height: compact ? 14 : 18),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: compact ? 460 : 500),
                child: Text(
                  'Consulta horarios, historial, perfiles y servicios '
                  'institucionales desde una experiencia pensada para estudiantes, '
                  'docentes y administradores.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: const Color(0xD9FFFFFF),
                    height: 1.5,
                    fontSize: compact ? 15 : 16,
                  ),
                ),
              ),
              SizedBox(height: compact ? 20 : 28),
              Wrap(
                spacing: compact ? 10 : 12,
                runSpacing: compact ? 10 : 12,
                children: const [
                  _DesktopFeaturePill(
                    icon: Icons.verified_user_outlined,
                    label: 'Acceso seguro',
                  ),
                  _DesktopFeaturePill(
                    icon: Icons.schedule_outlined,
                    label: 'Horarios y clases',
                  ),
                  _DesktopFeaturePill(
                    icon: Icons.assessment_outlined,
                    label: 'Registros academicos',
                  ),
                ],
              ),
              if (!compact) ...[
                const SizedBox(height: 34),
                Row(
                  children: const [
                    Expanded(
                      child: _DesktopStatCard(
                        value: '24/7',
                        label: 'Disponibilidad de plataforma',
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: _DesktopStatCard(
                        value: '3',
                        label: 'Perfiles integrados',
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _DesktopStudentPhotoCard extends StatelessWidget {
  const _DesktopStudentPhotoCard({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: compact ? 500 : 620,
        maxHeight: compact ? 250 : 340,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(compact ? 24 : 30),
        boxShadow: const [
          BoxShadow(
            color: Color(0x240B3BA8),
            blurRadius: 28,
            offset: Offset(0, 18),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(compact ? 24 : 30),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              _desktopLoginImageAsset,
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x0805143A), Color(0x4005143A)],
                ),
              ),
            ),
            Positioned(
              left: compact ? 16 : 20,
              top: compact ? 16 : 20,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: compact ? 12 : 14,
                  vertical: compact ? 8 : 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xCCFFFFFF),
                  borderRadius: BorderRadius.circular(compact ? 16 : 18),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.menu_book_outlined,
                      size: compact ? 16 : 18,
                      color: const Color(0xFF1F63F2),
                    ),
                    SizedBox(width: compact ? 6 : 8),
                    Text(
                      'Acceso universitario',
                      style: TextStyle(
                        color: const Color(0xFF172033),
                        fontWeight: FontWeight.w700,
                        fontSize: compact ? 13 : 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DesktopLoginCard extends StatelessWidget {
  const _DesktopLoginCard({
    required this.obscurePassword,
    required this.onTogglePassword,
    required this.compact,
  });

  final bool obscurePassword;
  final VoidCallback onTogglePassword;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(compact ? 22 : 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(compact ? 28 : 32),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1417263D),
            blurRadius: 24,
            offset: Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _LoginTopBar(
            horizontalPadding: EdgeInsets.fromLTRB(0, 0, 0, compact ? 4 : 10),
            titleFontSize: compact ? 18 : null,
          ),
          SizedBox(height: compact ? 6 : 10),
          _LoginHeroBanner(
            height: compact ? 170 : 210,
            borderRadius: compact ? 24 : 28,
            iconBoxWidth: compact ? 76 : 90,
            iconBoxHeight: compact ? 70 : 82,
            iconSize: compact ? 38 : 44,
          ),
          SizedBox(height: compact ? 22 : 28),
          _LoginWelcomeText(compact: compact),
          SizedBox(height: compact ? 22 : 28),
          _LoginFormFields(
            obscurePassword: obscurePassword,
            onTogglePassword: onTogglePassword,
            compact: compact,
          ),
        ],
      ),
    );
  }
}

class _LoginTopBar extends StatelessWidget {
  const _LoginTopBar({required this.horizontalPadding, this.titleFontSize});

  final EdgeInsets horizontalPadding;
  final double? titleFontSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: horizontalPadding,
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            color: const Color(0xFF172033),
          ),
          Expanded(
            child: Text(
              'Gestion Universitaria',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: const Color(0xFF172033),
                fontSize: titleFontSize,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _LoginWelcomeText extends StatelessWidget {
  const _LoginWelcomeText({this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Bienvenido',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: const Color(0xFF172033),
            fontSize: compact ? 28 : null,
          ),
        ),
        SizedBox(height: compact ? 8 : 10),
        Text(
          'Ingresa tus credenciales para continuar',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: const Color(0xFF6D7A96),
            fontWeight: FontWeight.w500,
            fontSize: compact ? 16 : null,
          ),
        ),
      ],
    );
  }
}

class _LoginFormFields extends StatefulWidget {
  const _LoginFormFields({
    required this.obscurePassword,
    required this.onTogglePassword,
    this.compact = false,
  });

  final bool obscurePassword;
  final VoidCallback onTogglePassword;
  final bool compact;

  @override
  State<_LoginFormFields> createState() => _LoginFormFieldsState();
}

class _LoginFormFieldsState extends State<_LoginFormFields> {
  String _selectedRole = 'estudiante';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _InputLabel('ID o Correo'),
        const SizedBox(height: 8),
        _CustomTextField(
          hintText: 'Ej. 2024001 o correo@edu.com',
          prefixIcon: Icons.account_circle_outlined,
          dense: widget.compact,
        ),
        SizedBox(height: widget.compact ? 14 : 18),
        const _InputLabel('Contrasena'),
        const SizedBox(height: 8),
        _CustomTextField(
          hintText: 'Ingresa tu contrasena',
          prefixIcon: Icons.lock_outline,
          obscureText: widget.obscurePassword,
          dense: widget.compact,
          suffix: IconButton(
            onPressed: widget.onTogglePassword,
            icon: Icon(
              widget.obscurePassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: const Color(0xFF94A3BE),
            ),
          ),
        ),
        SizedBox(height: widget.compact ? 10 : 14),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF1F63F2),
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Olvidaste tu contrasena?',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ),
        SizedBox(height: widget.compact ? 14 : 18),
        SizedBox(
          width: double.infinity,
          height: widget.compact ? 52 : 56,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                PageRouteBuilder<void>(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      HomeScreen(userRole: _selectedRole),
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
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1F63F2),
              foregroundColor: Colors.white,
              elevation: 8,
              shadowColor: const Color(0x331F63F2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'Iniciar Sesion',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
            ),
          ),
        ),
        SizedBox(height: widget.compact ? 28 : 38),
        const _ProfileDivider(),
        SizedBox(height: widget.compact ? 18 : 22),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 10,
          runSpacing: 10,
          children: [
            _SelectableRoleChip(
              icon: Icons.person_outline_rounded,
              label: 'ESTUDIANTES',
              value: 'estudiante',
              isSelected: _selectedRole == 'estudiante',
              onTap: () {
                setState(() => _selectedRole = 'estudiante');
              },
            ),
            _SelectableRoleChip(
              icon: Icons.school_outlined,
              label: 'DOCENTES',
              value: 'docente',
              isSelected: _selectedRole == 'docente',
              onTap: () {
                setState(() => _selectedRole = 'docente');
              },
            ),
            _SelectableRoleChip(
              icon: Icons.admin_panel_settings_outlined,
              label: 'ADMIN',
              value: 'admin',
              isSelected: _selectedRole == 'admin',
              onTap: () {
                setState(() => _selectedRole = 'admin');
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _DesktopFeaturePill extends StatelessWidget {
  const _DesktopFeaturePill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0x16FFFFFF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0x26FFFFFF)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _DesktopStatCard extends StatelessWidget {
  const _DesktopStatCard({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0x18FFFFFF),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0x26FFFFFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xD9FFFFFF),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginHeroBanner extends StatelessWidget {
  const _LoginHeroBanner({
    this.height = 142,
    this.borderRadius = 0,
    this.iconBoxWidth = 66,
    this.iconBoxHeight = 58,
    this.iconSize = 34,
  });

  final double height;
  final double borderRadius;
  final double iconBoxWidth;
  final double iconBoxHeight;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1417263D),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.topRight,
                  colors: [
                    Color(0xFF7FC4FF),
                    Color(0xFF2790F4),
                    Color(0xFF1776E6),
                  ],
                ),
              ),
            ),
            Positioned(
              left: -16,
              top: -20,
              child: Container(
                width: 110,
                height: 110,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0x18FFFFFF),
                ),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: height * 0.42,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0x00192E5D), Color(0x66192E5D)],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: height * 0.12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(
                    8,
                    (index) => Container(
                      width: height * 0.14,
                      height: index.isEven ? height * 0.42 : height * 0.34,
                      decoration: BoxDecoration(
                        color: const Color(0x22FFFFFF),
                        borderRadius: BorderRadius.circular(2),
                        border: Border.all(color: const Color(0x30FFFFFF)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                width: iconBoxWidth,
                height: iconBoxHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x220A2A6B),
                      blurRadius: 18,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.school_outlined,
                  size: iconSize,
                  color: const Color(0xFF1F63F2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InputLabel extends StatelessWidget {
  const _InputLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w800,
          color: const Color(0xFF172033),
        ),
      ),
    );
  }
}

class _CustomTextField extends StatelessWidget {
  const _CustomTextField({
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
    this.suffix,
    this.dense = false,
  });

  final String hintText;
  final IconData prefixIcon;
  final bool obscureText;
  final Widget? suffix;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0xFF9AA8C0),
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Icon(prefixIcon, color: const Color(0xFF9AA8C0)),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 18,
          vertical: dense ? 15 : 18,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFDCE4F2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF1F63F2), width: 1.4),
        ),
      ),
    );
  }
}

class _ProfileDivider extends StatelessWidget {
  const _ProfileDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Color(0xFFDCE4F2))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'PERFILES',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              letterSpacing: 2.2,
              fontWeight: FontWeight.w800,
              color: const Color(0xFFA5B1C7),
            ),
          ),
        ),
        const Expanded(child: Divider(color: Color(0xFFDCE4F2))),
      ],
    );
  }
}

class _SelectableRoleChip extends StatelessWidget {
  const _SelectableRoleChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1F63F2) : Colors.white,
          border: Border.all(
            color: isSelected ? const Color(0xFF1F63F2) : const Color(0xFFDCE4F2),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : const Color(0xFF6D7A96),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : const Color(0xFF6D7A96),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
