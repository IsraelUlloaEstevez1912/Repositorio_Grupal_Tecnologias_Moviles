import 'dart:io';
import 'package:flutter/material.dart';

class MatriculaScreen extends StatefulWidget {
  const MatriculaScreen({super.key});

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

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Completar Pago Seguro', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Ingrese los datos de su tarjeta para proceder con el pago de \$4.455.000.'),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Nombre en la Tarjeta',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: cardNumberController,
                  keyboardType: TextInputType.number,
                  maxLength: 16,
                  decoration: InputDecoration(
                    labelText: 'Número de Tarjeta',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          counterText: '',
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1D4ED8), // Azul vibrante
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onPressed: () async {
                if (cardNumberController.text.isNotEmpty && nameController.text.isNotEmpty) {
                  // Simula estar procesando
                  FocusScope.of(context).unfocus();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Procesando pago, por favor espere...'), duration: Duration(seconds: 1)),
                  );
                  
                  await Future.delayed(const Duration(seconds: 2));
                  
                  setState(() {
                    _isPaid = true;
                  });
                  
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Pago exitoso. Ahora puedes descargar tu recibo.'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor llena los campos de la tarjeta'),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              },
              child: const Text('Procesar Pago', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _downloadReceipt() async {
    try {
      final tempDir = Directory.systemTemp.path;
      final file = File('$tempDir/factura_MAT-20242-99831.txt');
      
      final content = '''
=============================================
             RECIBO DE MATRÍCULA
=============================================
Referencia de Pago: MAT-20242-99831
Fecha de Emisión: 15 AGO, 2024
Periodo Académico: 2024-II

---------------------------------------------
DETALLE DE FACTURACIÓN
---------------------------------------------
Valor Matrícula (18 Créditos):  \$4.250.000
Seguro Estudiantil:                 \$85.000
Bienestar Universitario:           \$120.000

---------------------------------------------
TOTAL PAGADO:                    \$4.455.000
---------------------------------------------
Estado: PAGADO
Método de Pago: Tarjeta (terminada en ****)

¡Gracias por su pago! Universidad Gestión.
=============================================
''';

      await file.writeAsString(content);
      
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Text('Factura Generada'),
              ],
            ),
            content: Text('La factura se ha guardado exitosamente en tus archivos temporales:\n\n${file.path}'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Aceptar'),
              )
            ],
          )
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text('Error al generar factura: $e'), backgroundColor: Colors.red),
        );
      }
    }
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
          onPressed: () {},
        ),
        title: const Text(
          'Gestión de Matrícula',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.w900,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_balance_wallet_outlined, color: Color(0xFF1D4ED8)),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Periodo Académico y Créditos Cards
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 120,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.0),
                        boxShadow: [
                           BoxShadow(
                             color: Colors.black.withOpacity(0.03),
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
                            'PERIODO ACADÉMICO',
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '2023-II',
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
                                width: 8, height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF10B981), // verde
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _isPaid ? 'Matriculado' : 'Matrícula en Activa',
                                style: const TextStyle(
                                  color: Color(0xFF10B981),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 120,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1D4ED8), // Fondo azul oscuro
                        borderRadius: BorderRadius.circular(16.0),
                        boxShadow: [
                           BoxShadow(
                             color: const Color(0xFF1D4ED8).withOpacity(0.3),
                             blurRadius: 10,
                             offset: const Offset(0, 4),
                           ),
                        ],
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'CRÉDITOS TOTALES',
                            style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                              letterSpacing: 1.0,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '18',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 32,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Máximo permitido: 21',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Asignaturas Inscritas
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF), // Azul muy pálido
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: const Text(
                      '6 Materias',
                      style: TextStyle(
                        color: Color(0xFF1D4ED8),
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 12),
            
            // Lista Asignaturas
            _SubjectItem(
              icon: Icons.architecture,
              title: 'Estructuras de Datos Avanzadas',
              code: 'SIS-402',
              credits: '4 Créditos',
            ),
            _SubjectItem(
              icon: Icons.language,
              title: 'Inglés Técnico Académico',
              code: 'LIN-105',
              credits: '2 Créditos',
            ),
            _SubjectItem(
              icon: Icons.functions,
              title: 'Cálculo Multivariable',
              code: 'MAT-201',
              credits: '4 Créditos',
            ),
            _SubjectItem(
              icon: Icons.developer_board,
              title: 'Arquitectura de Software',
              code: 'SIS-308',
              credits: '3 Créditos',
            ),
            
            const SizedBox(height: 16),
            
            // Tarjeta de Pago
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5)),
                ],
              ),
              child: Column(
                children: [
                  // Cabecera oscura
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: const BoxDecoration(
                      color: Color(0xFF0F172A), // Slate 900
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('REFERENCIA DE PAGO', style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                            SizedBox(height: 6),
                            Text('MAT-20242-99831', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('VENCE', style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                            const SizedBox(height: 6),
                            Text(_isPaid ? 'PAGADO' : '15 AGO, 2024', style: TextStyle(color: _isPaid ? Colors.greenAccent : Colors.white, fontSize: 13, fontWeight: FontWeight.w900)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Detalles de factura blancos
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16.0), bottomRight: Radius.circular(16.0)),
                    ),
                    child: Column(
                      children: [
                        _InvoiceRow('Valor Matrícula (18 Créditos)', '\$4.250.000'),
                        const SizedBox(height: 12),
                        _InvoiceRow('Seguro Estudiantil', '\$85.000'),
                        const SizedBox(height: 12),
                        _InvoiceRow('Bienestar Universitario', '\$120.000'),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Divider(color: Color(0xFFE2E8F0)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'TOTAL A PAGAR',
                              style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w900, fontSize: 14),
                            ),
                            Text(
                              '\$4.455.000',
                              style: TextStyle(color: _isPaid ? Colors.green : const Color(0xFF2563EB), fontWeight: FontWeight.w900, fontSize: 20),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        
                        // Lógica de botones
                        if (!_isPaid) 
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2563EB),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                              ),
                              onPressed: _showPaymentDialog,
                              icon: const Icon(Icons.payment),
                              label: const Text('Pagar en Línea', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                            ),
                          )
                        else
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF0F172A),
                                side: const BorderSide(color: Color(0xFFE2E8F0), width: 2),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                              ),
                              onPressed: _downloadReceipt,
                              icon: const Icon(Icons.file_download_outlined),
                              label: const Text('Descargar Recibo', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                            ),
                          ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            
            // Subtexto de métodos de pago
            const Padding(
              padding: EdgeInsets.only(top: 24.0, bottom: 12.0),
              child: Text(
                'MÉTODOS DE PAGO DISPONIBLES',
                style: TextStyle(
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w800,
                  fontSize: 10,
                  letterSpacing: 1.0,
                ),
              ),
            ),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.credit_card, color: Colors.grey.shade400, size: 36),
                const SizedBox(width: 16),
                Icon(Icons.account_balance, color: Colors.grey.shade400, size: 36),
                const SizedBox(width: 16),
                Text('PSE', style: TextStyle(color: Colors.grey.shade400, fontSize: 24, fontWeight: FontWeight.w900)),
              ],
            ),
            
            const SizedBox(height: 40), // Spacing before bottom nav
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF2563EB),
          unselectedItemColor: const Color(0xFF94A3B8),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 10),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 10),
          currentIndex: 2, // "GRADES" / MATRÍCULA
          iconSize: 24,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Padding(padding: EdgeInsets.only(bottom: 4.0), child: Icon(Icons.home_outlined)),
              label: 'HOME',
            ),
            BottomNavigationBarItem(
              icon: Padding(padding: EdgeInsets.only(bottom: 4.0), child: Icon(Icons.calendar_today_outlined)),
              label: 'SCHEDULE',
            ),
            BottomNavigationBarItem(
              icon: Padding(padding: EdgeInsets.only(bottom: 4.0), child: Icon(Icons.school)), // Solid
              label: 'GRADES',
            ),
            BottomNavigationBarItem(
              icon: Padding(padding: EdgeInsets.only(bottom: 4.0), child: Icon(Icons.notifications_none)), 
              label: 'ALERTS',
            ),
            BottomNavigationBarItem(
              icon: Padding(padding: EdgeInsets.only(bottom: 4.0), child: Icon(Icons.person_outline)),
              label: 'PROFILE',
            ),
          ],
        ),
      ),
    );
  }
}

class _SubjectItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String code;
  final String credits;

  const _SubjectItem({required this.icon, required this.title, required this.code, required this.credits});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
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
              color: const Color(0xFFF8FAFC), // Gris casi blanco
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
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9), // Gris claro
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        code,
                        style: const TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.w600, fontSize: 11),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.stars, color: Colors.grey, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      credits,
                      style: const TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w600, fontSize: 11),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _InvoiceRow extends StatelessWidget {
  final String label;
  final String amount;

  const _InvoiceRow(this.label, this.amount);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Color(0xFF64748B), fontSize: 13, fontWeight: FontWeight.w500),
        ),
        Text(
          amount,
          style: const TextStyle(color: Color(0xFF0F172A), fontSize: 13, fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}
