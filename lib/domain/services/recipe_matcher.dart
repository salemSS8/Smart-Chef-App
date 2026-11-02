import 'package:flutter/foundation.dart';
import '../models/match_filters.dart';
import '../models/recipe.dart';
import '../models/recipe_match.dart';

/// Input bundle passed across Isolate thread boundaries.
class _MatchInput {
  final List<Recipe> recipes;
  final Set<String> userPantryIds;
  final MatchFilters filters;

  const _MatchInput({
    required this.recipes,
    required this.userPantryIds,
    required this.filters,
  });
}

/// High-performance recipe matching service running inside background Isolate.
class RecipeMatcher {
  /// Matches a list of recipes against user pantry ingredients.
  /// Dispatches heavy mathematical set operations to background Isolate via [compute]
  /// when [useIsolate] is true.
  static Future<List<RecipeMatch>> match({
    required List<Recipe> recipes,
    required Set<String> userPantryIds,
    MatchFilters filters = MatchFilters.defaultFilters,
    bool useIsolate = true,
  }) async {
    final input = _MatchInput(
      recipes: recipes,
      userPantryIds: userPantryIds,
      filters: filters,
    );

    if (useIsolate && recipes.length > 20) {
      return compute(_matchRecipesWorker, input);
    } else {
      return _matchRecipesWorker(input);
    }
  }

  /// Top-level worker function executable inside Dart Isolate.
  static List<RecipeMatch> _matchRecipesWorker(_MatchInput input) {
    final results = <RecipeMatch>[];
    final filters = input.filters;
    final pantry = input.userPantryIds;

    for (final recipe in input.recipes) {
      // 1. Time filter
      if (filters.maxMinutes != null && recipe.totalMinutes > filters.maxMinutes!) {
        continue;
      }

      // 2. Difficulty filter
      if (filters.maxDifficulty != null) {
        final difficultyLevel = recipe.difficulty == 'سهل'
            ? 1
            : recipe.difficulty == 'متوسط'
                ? 2
                : 3;
        if (difficultyLevel > filters.maxDifficulty!) {
          continue;
        }
      }

      // 3. Cuisine filter
      if (filters.selectedCuisines.isNotEmpty &&
          !filters.selectedCuisines.contains(recipe.cuisine)) {
        continue;
      }

      // 4. Meal type / tags filter
      if (filters.mealTypes.isNotEmpty &&
          !recipe.tags.any((tag) => filters.mealTypes.contains(tag))) {
        continue;
      }

      // 5. Evaluate ingredients
      int totalCore = 0;
      int availableCore = 0;
      int totalImportant = 0;
      int availableImportant = 0;

      final List<RecipeIngredient> missingList = [];
      final List<RecipeIngredient> availableList = [];

      for (final item in recipe.ingredients) {
        final isAvailable = (filters.assumeStaples && item.role == IngredientRole.staple) ||
            pantry.contains(item.ingredientId);

        if (isAvailable) {
          availableList.add(item);
          if (item.role == IngredientRole.core) {
            totalCore++;
            availableCore++;
          } else if (item.role == IngredientRole.important) {
            totalImportant++;
            availableImportant++;
          }
        } else {
          missingList.add(item);
          if (item.role == IngredientRole.core) {
            totalCore++;
          } else if (item.role == IngredientRole.important) {
            totalImportant++;
          }
        }
      }

      final int totalRequired = totalCore + totalImportant;
      final int matchedRequired = availableCore + availableImportant;

      // Coverage ratio
      final double coreRatio = totalCore == 0 ? 1.0 : (availableCore / totalCore);
      final double importantRatio =
          totalImportant == 0 ? 1.0 : (availableImportant / totalImportant);

      // Weighted score: 65% Core, 35% Important
      final double coveragePercent = totalRequired == 0
          ? 100.0
          : ((coreRatio * 0.65) + (importantRatio * 0.35)) * 100.0;

      final int missingKeyCount = totalRequired - matchedRequired;

      // MatchType categorization
      final MatchType matchType;
      if (missingKeyCount == 0 && coreRatio == 1.0) {
        matchType = MatchType.readyNow;
      } else if (missingKeyCount <= filters.maxMissing && coveragePercent >= 50.0) {
        matchType = MatchType.almostReady;
      } else {
        matchType = MatchType.idea;
      }

      // Filter: onlyReadyNow
      if (filters.onlyReadyNow && matchType != MatchType.readyNow) {
        continue;
      }

      // Filter: maxMissing limit
      if (missingKeyCount > filters.maxMissing && matchType != MatchType.readyNow) {
        continue;
      }

      results.add(
        RecipeMatch(
          recipe: recipe,
          coveragePercent: coveragePercent,
          matchedCount: availableList.length,
          totalRequired: totalRequired,
          missingIngredients: missingList,
          availableIngredients: availableList,
          matchType: matchType,
        ),
      );
    }

    // Sort: 1) MatchType priority, 2) Coverage % desc, 3) Cook time asc
    results.sort((a, b) {
      final typeCompare = a.matchType.index.compareTo(b.matchType.index);
      if (typeCompare != 0) return typeCompare;

      final coverageCompare = b.coveragePercent.compareTo(a.coveragePercent);
      if (coverageCompare != 0) return coverageCompare;

      return a.recipe.totalMinutes.compareTo(b.recipe.totalMinutes);
    });

    return results;
  }
}
