import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_cook/data/local/app_database.dart';
import 'package:smart_cook/data/local/database_provider.dart';
import 'package:smart_cook/presentation/providers/pantry_provider.dart';
import 'package:smart_cook/presentation/screens/pantry_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase inMemoryDb;

  setUp(() {
    inMemoryDb = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await inMemoryDb.close();
  });

  group('PantryScreen Widget Tests', () {
    testWidgets('renders search field, quick suggestions, and category tabs', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(inMemoryDb),
            pantryDaoProvider.overrideWithValue(inMemoryDb.pantryDao),
          ],
          child: MaterialApp(
            home: Directionality(
              textDirection: TextDirection.rtl,
              child: PantryScreen(onViewRecipes: () {}),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Search input field exists
      expect(find.byType(TextField), findsOneWidget);
      // 'بصل' is added by default so chip text shows '✓ بصل'
      expect(find.text('✓ بصل'), findsOneWidget);
      // 'ثوم' is not in default pantry so chip text shows '+ ثوم'
      expect(find.text('+ ثوم'), findsOneWidget);

      // Verify header exists
      expect(find.text('مطبخي'), findsOneWidget);
    });

    testWidgets('tapping quick suggestion toggles ingredient state', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(inMemoryDb),
            pantryDaoProvider.overrideWithValue(inMemoryDb.pantryDao),
          ],
          child: MaterialApp(
            home: Directionality(
              textDirection: TextDirection.rtl,
              child: Consumer(
                builder: (context, ref, child) {
                  return Scaffold(
                    body: Column(
                      children: [
                        Text('COUNT: ${ref.watch(pantryProvider).length}'),
                        Expanded(child: PantryScreen(onViewRecipes: () {})),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap on '+ ثوم'
      final garlicChip = find.text('+ ثوم');
      expect(garlicChip, findsOneWidget);
      await tester.tap(garlicChip);
      await tester.pumpAndSettle();

      // Now garlic should be toggled to '✓ ثوم'
      expect(find.text('✓ ثوم'), findsOneWidget);
    });
  });
}
