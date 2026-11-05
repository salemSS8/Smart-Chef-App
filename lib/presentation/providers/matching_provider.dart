import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/mock/recipes_data.dart';
import '../../domain/models/recipe.dart';
import 'pantry_provider.dart';

/// كائن يجمع نتائج المطابقة المصنفة
class MatchingState {
  final List<RecipeMatchResult> readyRecipes; // 100% جاهزة للطهي الآن
  final List<RecipeMatchResult> missingOneRecipes; // ينقصها مكوّن واحد فقط
  final List<RecipeMatchResult> partialRecipes; // ينقصها مكوّنان أو أكثر
  final int totalReadyCount;

  const MatchingState({
    required this.readyRecipes,
    required this.missingOneRecipes,
    required this.partialRecipes,
    required this.totalReadyCount,
  });
}

/// مزود نتائج المطابقة اللحظية المتجاوب مع أي تغيير في المطبخ
final matchingProvider = Provider<MatchingState>((ref) {
  final pantryIds = ref.watch(pantryProvider);
  final recipes = RecipesData.allRecipes;

  final List<RecipeMatchResult> allResults = recipes.map((recipe) {
    return recipe.evaluateMatch(pantryIds);
  }).toList();

  // ترتيب النتائج حسب النسبة الأعلى
  allResults.sort((a, b) => b.score.compareTo(a.score));

  final ready = allResults.where((r) => r.isFullyReady).toList();
  final missingOne = allResults.where((r) => r.isMissingOne).toList();
  final partial = allResults.where((r) => !r.isFullyReady && !r.isMissingOne && r.score >= 0.3).toList();

  return MatchingState(
    readyRecipes: ready,
    missingOneRecipes: missingOne,
    partialRecipes: partial,
    totalReadyCount: ready.length,
  );
});

/// مزود قائمة جميع الوصفات المعتمدة في الكتالوج
final recipesProvider = Provider<List<Recipe>>((ref) => RecipesData.allRecipes);
