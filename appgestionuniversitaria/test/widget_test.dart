import 'package:flutter_test/flutter_test.dart';

import 'package:appgestionuniversitaria/main.dart';

void main() {
  testWidgets('shows splash first and then navigates to login', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const EduConnectApp());

    expect(find.text('EduConnect'), findsOneWidget);
    expect(find.text('Bienvenido'), findsNothing);

    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.text('Bienvenido'), findsOneWidget);
    expect(find.text('Iniciar Sesion'), findsOneWidget);
  });
}
