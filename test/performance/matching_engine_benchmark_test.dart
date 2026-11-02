import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_cook/domain/models/recipe.dart';
import 'package:smart_cook/domain/services/recipe_matcher.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Sprint 6 - Performance & Stress Benchmark', () {
    test('RecipeMatcher completes 1,000 recipes matching under 150ms', () async {
      final random = Random(42);
      final allIngredientPool = List.generate(200, (i) => 'ing_$i');

      // Generate 1,000 synthetic recipes
      final List<Recipe> recipes = List.generate(1000, (rIdx) {
        final ingredientCount = 4 + random.nextInt(6);
        final ingredients = List.generate(ingredientCount, (iIdx) {
          final ingId = allIngredientPool[random.nextInt(allIngredientPool.length)];
          return RecipeIngredient(
            ingredientId: ingId,
            name: 'مكون $ingId',
            role: iIdx == 0
                ? IngredientRole.core
                : (iIdx < 3 ? IngredientRole.important : IngredientRole.optional),
            amount: '1',
          );
        });

        return Recipe(
          id: 'bench_recipe_$rIdx',
          title: 'وصفة اختبار رقم $rIdx',
          description: 'وصف تجريبي للأداء',
          cuisine: 'شامي',
          difficulty: 'سهل',
          prepMinutes: 10,
          cookMinutes: 20,
          servings: 4,
          calories: 350,
          heroImageUrl: '',
          tags: const ['سريع', 'عشاء'],
          ingredients: ingredients,
          steps: const [
            RecipeStep(stepNo: 1, text: 'الخطوة 1'),
            RecipeStep(stepNo: 2, text: 'الخطوة 2'),
          ],

        );
      });

      // User has 40 pantry ingredients
      final userPantry = allIngredientPool.take(40).toSet();

      // Warm-up run
      await RecipeMatcher.match(
        recipes: recipes.take(50).toList(),
        userPantryIds: userPantry,
        useIsolate: false,
      );

      // Benchmark execution
      final stopwatch = Stopwatch()..start();
      final results = await RecipeMatcher.match(
        recipes: recipes,
        userPantryIds: userPantry,
        useIsolate: false, // Measure pure algorithmic latency without test runner isolate overhead
      );
      stopwatch.stop();

      final elapsedMs = stopwatch.elapsedMilliseconds;
      // ignore: avoid_print
      print('⚡ [Benchmark] Matched 1,000 recipes against 40 ingredients in: ${elapsedMs}ms (Results: ${results.length})');

      expect(results.isNotEmpty, isTrue);
      // Assert SLA performance threshold: must be sub-150ms
      expect(elapsedMs, lessThan(150), reason: 'Matching 1,000 recipes exceeded 150ms target!');
    });
  });
}
