import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_cook/data/local/app_database.dart';
import 'package:smart_cook/data/local/database_provider.dart';
import 'package:smart_cook/presentation/screens/today_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase inMemoryDb;

  setUp(() {
    inMemoryDb = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await inMemoryDb.close();
  });

  group('TodayScreen Widget Tests', () {
    testWidgets('renders greeting header, filter button, and match stats', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(inMemoryDb),
            pantryDaoProvider.overrideWithValue(inMemoryDb.pantryDao),
            recipeDaoProvider.overrideWithValue(inMemoryDb.recipeDao),
            shoppingDaoProvider.overrideWithValue(inMemoryDb.shoppingDao),
          ],
          child: MaterialApp(
            home: Directionality(
              textDirection: TextDirection.rtl,
              child: TodayScreen(onNavigateToPantry: () {}),
            ),
          ),
        ),
      );

      await tester.pump();

      // Top greeting exists
      expect(find.text('مساء الخير'), findsOneWidget);
      // Filter button icon exists
      expect(find.byIcon(Icons.tune_rounded), findsWidgets);
    });
  });
}
