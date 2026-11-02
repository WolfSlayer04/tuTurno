import 'package:flutter_test/flutter_test.dart';
import 'package:tu_turno/main.dart';

void main() {
  testWidgets('Welcome screen shows brand', (tester) async {
    await tester.pumpWidget(const TuTurnoApp());
    expect(find.text('Tu Turno'), findsOneWidget);
    expect(find.text('Comenzar'), findsOneWidget);
  });
}
