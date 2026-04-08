import 'package:flutter/material.dart';

import '../widgets/app_bottom_nav.dart';

class MatriculaScreen extends StatefulWidget {
  const MatriculaScreen({super.key, this.userRole = 'estudiante'});

  final String userRole;

  @override
  State<MatriculaScreen> createState() => _MatriculaScreenState();
}

class _MatriculaScreenState extends State<MatriculaScreen> {
  bool _isPaid = false;

  void _showPaymentDialog() {
    final cardNumberController = TextEditingController();
    final expiryController = TextEditingController();
    final cvvController = TextEditingController();
    final nameController = TextEditingController();

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Completar Pago Seguro',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ingresa los datos de tu tarjeta para proceder con el pago '
                  'de \$4.455.000.',
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Nombre en la Tarjeta',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: cardNumberController,
                  keyboardType: TextInputType.number,
                  maxLength: 16,
                  decoration: InputDecoration(
                    labelText: 'Numero de Tarjeta',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.credit_card),
                    counterText: '',
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: expiryController,
                        keyboardType: TextInputType.datetime,
                        maxLength: 5,
                        decoration: InputDecoration(
                          labelText: 'MM/AA',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          counterText: '',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: cvvController,
                        keyboardType: TextInputType.number,
                        maxLength: 3,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'CVV',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          counterText: '',
                        ),
                      ),
                    ),
                  ],
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
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              onPressed: () async {
                if (cardNumberController.text.isEmpty ||
                    nameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Por favor llena los campos de la tarjeta.',
                      ),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                  return;
                }

                FocusScope.of(context).unfocus();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Procesando pago, por favor espera...'),
                    duration: Duration(seconds: 1),
                  ),
                );

                await Future.delayed(const Duration(seconds: 2));

                if (!mounted || !context.mounted || !dialogContext.mounted) {
                  return;
                }

                setState(() {
                  _isPaid = true;
                });

                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pago exitoso. Ya puedes ver tu recibo.'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text(
                'Procesar Pago',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showReceiptDialog() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.receipt_long, color: Color(0xFF2563EB)),
              SizedBox(width: 8),
              Text('Recibo de Matricula'),
            ],
          ),
          content: const SingleChildScrollView(
            child: SelectableText(
              'Referencia de Pago: MAT-20242-99831\n'
              'Fecha de Emision: 15 AGO, 2024\n'
              'Periodo Academico: 2024-II\n\n'
              'Valor Matricula (18 Creditos):  \$4.250.000\n'
              'Seguro Estudiantil:            \$85.000\n'
              'Bienestar Universitario:       \$120.000\n\n'
              'TOTAL PAGADO:                  \$4.455.000\n'
              'Estado: PAGADO\n'
              'Metodo de Pago: Tarjeta (****)\n\n'
              'Gracias por tu pago.',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1D4ED8)),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          'Gestion de Matricula',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.w900,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.account_balance_wallet_outlined,
              color: Color(0xFF1D4ED8),
            ),
            onPressed: _isPaid ? _showReceiptDialog : _showPaymentDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 120,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'PERIODO ACADEMICO',
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '2024-II',
                            style: TextStyle(
                              color: Color(0xFF1D4ED8),
                              fontWeight: FontWeight.w900,
                              fontSize: 26,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: _isPaid
                                      ? const Color(0xFF10B981)
                                      : const Color(0xFFF59E0B),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _isPaid ? 'Matriculado' : 'Pago pendiente',
                                style: TextStyle(
                                  color: _isPaid
                                      ? const Color(0xFF10B981)
                                      : const Color(0xFFF59E0B),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 120,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1D4ED8),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF1D4ED8,
                            ).withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'CREDITOS TOTALES',
                            style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                              fontSize: 9,
                              letterSpacing: 1,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            '18',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 30,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Maximo permitido: 21',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'ASIGNATURAS INSCRITAS',
                    style: TextStyle(
                      color: Color(0xFF0F172A),
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      '6 Materias',
                      style: TextStyle(
                        color: Color(0xFF1D4ED8),
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const _SubjectItem(
              icon: Icons.architecture,
              title: 'Estructuras de Datos Avanzadas',
              code: 'SIS-402',
              credits: '4 Creditos',
            ),
            const _SubjectItem(
              icon: Icons.language,
              title: 'Ingles Tecnico Academico',
              code: 'LIN-105',
              credits: '2 Creditos',
            ),
            const _SubjectItem(
              icon: Icons.functions,
              title: 'Calculo Multivariable',
              code: 'MAT-201',
              credits: '4 Creditos',
            ),
            const _SubjectItem(
              icon: Icons.developer_board,
              title: 'Arquitectura de Software',
              code: 'SIS-308',
              credits: '3 Creditos',
            ),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Color(0xFF0F172A),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'REFERENCIA DE PAGO',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'MAT-20242-99831',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'ESTADO',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _isPaid ? 'PAGADO' : 'PENDIENTE',
                              style: TextStyle(
                                color: _isPaid
                                    ? Colors.greenAccent
                                    : Colors.amberAccent,
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    child: Column(
                      children: [
                        const _InvoiceRow(
                          'Valor Matricula (18 Creditos)',
                          '\$4.250.000',
                        ),
                        const SizedBox(height: 12),
                        const _InvoiceRow('Seguro Estudiantil', '\$85.000'),
                        const SizedBox(height: 12),
                        const _InvoiceRow(
                          'Bienestar Universitario',
                          '\$120.000',
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Divider(color: Color(0xFFE2E8F0)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'TOTAL A PAGAR',
                              style: TextStyle(
                                color: Color(0xFF0F172A),
                                fontWeight: FontWeight.w900,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '\$4.455.000',
                              style: TextStyle(
                                color: _isPaid
                                    ? Colors.green
                                    : const Color(0xFF2563EB),
                                fontWeight: FontWeight.w900,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: _isPaid
                              ? OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: const Color(0xFF0F172A),
                                    side: const BorderSide(
                                      color: Color(0xFFE2E8F0),
                                      width: 2,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: _showReceiptDialog,
                                  icon: const Icon(Icons.receipt_long_outlined),
                                  label: const Text(
                                    'Ver Recibo',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 15,
                                    ),
                                  ),
                                )
                              : ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF2563EB),
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: _showPaymentDialog,
                                  icon: const Icon(Icons.payment),
                                  label: const Text(
                                    'Pagar en Linea',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 24, bottom: 12),
              child: Text(
                'METODOS DE PAGO DISPONIBLES',
                style: TextStyle(
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w800,
                  fontSize: 10,
                  letterSpacing: 1,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.credit_card, color: Colors.grey.shade400, size: 36),
                const SizedBox(width: 16),
                Icon(
                  Icons.account_balance,
                  color: Colors.grey.shade400,
                  size: 36,
                ),
                const SizedBox(width: 16),
                Text(
                  'PSE',
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
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

class _SubjectItem extends StatelessWidget {
  const _SubjectItem({
    required this.icon,
    required this.title,
    required this.code,
    required this.credits,
  });

  final IconData icon;
  final String title;
  final String code;
  final String credits;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF1D4ED8), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF0F172A),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        code,
                        style: const TextStyle(
                          color: Color(0xFF475569),
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.stars, color: Colors.grey, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      credits,
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InvoiceRow extends StatelessWidget {
  const _InvoiceRow(this.label, this.amount);

  final String label;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF64748B),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          amount,
          style: const TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
