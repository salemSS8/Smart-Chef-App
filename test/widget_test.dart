import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_cook/main.dart';

void main() {
  testWidgets('SmartCookApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: SmartCookApp(),
      ),
    );

    // Pump a single frame without waiting for infinite network loading animation
    await tester.pump();

    // Verify app renders with Arabic bottom navigation
    expect(find.text('اليوم'), findsOneWidget);
    expect(find.text('مطبخي'), findsOneWidget);
  });
}
