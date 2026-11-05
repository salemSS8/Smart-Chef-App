import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_cook/data/local/app_database.dart';
import 'package:smart_cook/data/local/database_provider.dart';
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
    testWidgets('renders search field, bento metrics, and category tabs', (tester) async {
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

      // Verify Bento metrics exist
      expect(find.text('إجمالي المؤونة'), findsOneWidget);
      expect(find.text('تنتهي قريباً'), findsOneWidget);
      expect(find.text('أوشكت تنفد'), findsOneWidget);

      // Verify AI Recipe Matcher Banner exists
      expect(find.textContaining('وصفة جاهزة للطهي الآن'), findsOneWidget);
      expect(find.text('طابق الوصفات من مؤونتي'), findsOneWidget);

      // Verify Category Filter Chips exist
      expect(find.text('الكل'), findsOneWidget);
      expect(find.text('خضار وفواكه'), findsOneWidget);
      expect(find.text('ألبان وبيض'), findsOneWidget);
    });

    testWidgets('tapping category filter selects the chip and updates state', (tester) async {
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

      // Tap on 'خضار وفواكه'
      final vegChip = find.text('خضار وفواكه');
      expect(vegChip, findsOneWidget);
      await tester.tap(vegChip);
      await tester.pumpAndSettle();

      // Verify header section
      expect(find.text('مؤونة المطبخ الحالية'), findsOneWidget);
    });
  });
}
