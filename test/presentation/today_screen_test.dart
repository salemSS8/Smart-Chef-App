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
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

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

      await tester.pumpAndSettle();

      // Top greeting exists
      expect(find.textContaining('أهلاً بك'), findsOneWidget);
      // Streak banner exists
      expect(find.textContaining('يوماً من الطهي المستمر'), findsOneWidget);
      // Filter button icon exists
      expect(find.byIcon(Icons.tune_rounded), findsWidgets);
      // Simmering Live Cook Card exists
      expect(find.text('متابعة الطهي'), findsOneWidget);
    });
  });
}
