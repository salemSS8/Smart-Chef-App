import 'package:flutter_test/flutter_test.dart';
import 'package:smart_cook/core/utils/arabic_normalizer.dart';
import 'package:smart_cook/data/mock/recipes_data.dart';
import 'package:smart_cook/domain/models/match_filters.dart';
import 'package:smart_cook/domain/models/recipe.dart';
import 'package:smart_cook/domain/models/recipe_match.dart';
import 'package:smart_cook/domain/services/recipe_matcher.dart';

void main() {
  group('ArabicNormalizer Unit Tests', () {
    test('Correctly strips Arabic diacritics and tatweel', () {
      expect(ArabicNormalizer.normalize('طَمَاطِمٌ'), 'طماطم');
      expect(ArabicNormalizer.normalize('بَـصَـل'), 'بصل');
    });

    test('Correctly unifies hamza, yaa, and taa marbouta variations', () {
      expect(ArabicNormalizer.normalize('إفطار'), 'افطار');
      expect(ArabicNormalizer.normalize('أرز'), 'ارز');
      expect(ArabicNormalizer.normalize('آيس'), 'ايس');
      expect(ArabicNormalizer.normalize('شوربة'), 'شوربه');
      expect(ArabicNormalizer.normalize('حلوى'), 'حلوي');
      expect(ArabicNormalizer.normalize('مسؤول'), 'مسوول');
    });

    test('Extracts ingredient names from conversational sentence', () {
      const sentence = 'عندي بيض وطماطم وبصل في الثلاجة';
      final tokens = ArabicNormalizer.extractIngredientNames(sentence);

      expect(tokens, contains('بيض'));
      expect(tokens, contains('طماطم'));
      expect(tokens, contains('بصل'));
      expect(tokens.contains('عندي'), isFalse);
      expect(tokens.contains('الثلاجة'), isFalse);
    });
  });

  group('RecipeMatcher Unit Tests', () {
    final allRecipes = RecipesData.allRecipes;

    test('Produces 100% readyNow match when all core & important ingredients are present', () async {
      // Pantry contains eggs and tomato (for Shakshuka)
      final pantryIds = {
        'ing_eggs',
        'ing_tomato',
        'ing_onion',
        'ing_bell_pepper',
      };

      final matches = await RecipeMatcher.match(
        recipes: allRecipes,
        userPantryIds: pantryIds,
        useIsolate: false,
      );

      expect(matches.isNotEmpty, isTrue);

      final shakshukaMatch = matches.firstWhere(
        (m) => m.recipe.id == 'rec_shakshuka',
      );

      expect(shakshukaMatch.matchType, MatchType.readyNow);
      expect(shakshukaMatch.coveragePercent, 100.0);
      expect(shakshukaMatch.missingIngredients.isEmpty, isTrue);
    });

    test('Categorizes as almostReady when missing 1 ingredient', () async {
      // Pantry has eggs, tomato, and onion, missing only bell pepper for Shakshuka
      final pantryIds = {'ing_eggs', 'ing_tomato', 'ing_onion'};

      final matches = await RecipeMatcher.match(
        recipes: allRecipes,
        userPantryIds: pantryIds,
        useIsolate: false,
      );

      final shakshukaMatch = matches.firstWhere(
        (m) => m.recipe.id == 'rec_shakshuka',
      );

      expect(shakshukaMatch.matchType, MatchType.almostReady);
      expect(shakshukaMatch.coveragePercent, lessThan(100.0));
      expect(shakshukaMatch.coveragePercent, greaterThanOrEqualTo(70.0));
      expect(shakshukaMatch.missingIngredients.any((i) => i.ingredientId == 'ing_bell_pepper'), isTrue);
    });

    test('Applies maxMinutes filter correctly', () async {
      final matches = await RecipeMatcher.match(
        recipes: allRecipes,
        userPantryIds: {'ing_eggs', 'ing_tomato'},
        filters: const MatchFilters(maxMinutes: 20),
        useIsolate: false,
      );

      for (final m in matches) {
        expect(m.recipe.totalMinutes, lessThanOrEqualTo(20));
      }
    });

    test('Applies selectedCuisines filter correctly', () async {
      const selectedCuisine = 'عربي مشترك';
      final matches = await RecipeMatcher.match(
        recipes: allRecipes,
        userPantryIds: {'ing_eggs', 'ing_tomato'},
        filters: const MatchFilters(selectedCuisines: [selectedCuisine]),
        useIsolate: false,
      );

      for (final m in matches) {
        expect(m.recipe.cuisine, selectedCuisine);
      }
    });
  });

  group('RecipeMatcher Performance Benchmark', () {
    test('Matches 1,000 synthetic recipes in under 150ms', () async {
      final baseRecipe = RecipesData.allRecipes.firstWhere((r) => r.id == 'rec_shakshuka');

      // Generate 1,000 recipes

      final syntheticRecipes = List.generate(1000, (index) {
        return Recipe(
          id: 'rec_synth_$index',
          title: 'الوصفة رقم $index',
          description: baseRecipe.description,
          cuisine: baseRecipe.cuisine,
          difficulty: baseRecipe.difficulty,
          prepMinutes: baseRecipe.prepMinutes,
          cookMinutes: baseRecipe.cookMinutes,
          servings: baseRecipe.servings,
          calories: baseRecipe.calories,
          heroImageUrl: baseRecipe.heroImageUrl,
          tags: baseRecipe.tags,
          verified: baseRecipe.verified,
          ingredients: baseRecipe.ingredients,
          steps: baseRecipe.steps,
        );
      });

      final userPantry = {
        'ing_eggs',
        'ing_tomato',
        'ing_onion',
        'ing_cheese_mozzarella',
        'ing_garlic',
        'ing_potato',
        'ing_chicken_breast',
      };

      final stopwatch = Stopwatch()..start();

      final results = await RecipeMatcher.match(
        recipes: syntheticRecipes,
        userPantryIds: userPantry,
        useIsolate: false,
      );

      stopwatch.stop();

      expect(results.length, 1000);
      expect(stopwatch.elapsedMilliseconds, lessThan(150),
          reason: 'Benchmark exceeded: took ${stopwatch.elapsedMilliseconds}ms');
    });
  });
}
