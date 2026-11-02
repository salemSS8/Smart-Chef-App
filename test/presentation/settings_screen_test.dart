import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_cook/data/local/app_database.dart';
import 'package:smart_cook/data/local/database_provider.dart';
import 'package:smart_cook/presentation/screens/settings_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase inMemoryDb;

  setUp(() {
    inMemoryDb = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await inMemoryDb.close();
  });

  group('SettingsScreen Widget Tests', () {
    testWidgets('renders user profile card, sync status, and dark mode toggle', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(inMemoryDb),
            pantryDaoProvider.overrideWithValue(inMemoryDb.pantryDao),
            recipeDaoProvider.overrideWithValue(inMemoryDb.recipeDao),
          ],
          child: const MaterialApp(
            home: Directionality(
              textDirection: TextDirection.rtl,
              child: SettingsScreen(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // User card
      expect(find.text('ضيف طاهي ذكي'), findsOneWidget);
      // Theme tile
      expect(find.text('الوضع الليلي (Dark Mode)'), findsOneWidget);
      // App branding
      expect(find.text('طاهي ذكي — Smart Cook'), findsOneWidget);
      // Compliance delete button
      expect(find.text('حذف الحساب والبيانات نهائياً'), findsOneWidget);
    });

    testWidgets('tapping delete account button opens confirmation dialog', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(inMemoryDb),
            pantryDaoProvider.overrideWithValue(inMemoryDb.pantryDao),
            recipeDaoProvider.overrideWithValue(inMemoryDb.recipeDao),
          ],
          child: const MaterialApp(
            home: Directionality(
              textDirection: TextDirection.rtl,
              child: SettingsScreen(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final deleteTile = find.text('حذف الحساب والبيانات نهائياً');
      expect(deleteTile, findsOneWidget);

      await tester.tap(deleteTile);
      await tester.pumpAndSettle();

      // Confirmation dialog must appear
      expect(find.text('تأكيد حذف الحساب والبيانات'), findsOneWidget);
      expect(find.text('حذف نهائي'), findsOneWidget);
      expect(find.text('إلغاء'), findsOneWidget);
    });
  });
}
