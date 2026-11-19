import 'package:flutter_test/flutter_test.dart';
import 'package:mi_app_nueva/main.dart';

void main() {
  testWidgets('Muestra error al ingresar con correo vacío', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MiApp());

    await tester.tap(find.text('Ingresar'));
    await tester.pump();

    expect(find.text('Escriba su correo'), findsOneWidget);
  });
}
