import 'recipe.dart';

/// Categories of match readiness for UI sections.
enum MatchType {
  /// 100% of required ingredients are available in the pantry.
  readyNow('جاهزة الآن 100%'),

  /// 70%–99% available, missing only 1 or 2 ingredients.
  almostReady('ينقصك القليل'),

  /// Under 70%, inspiration or additional ideas.
  idea('أفكار إضافية');

  final String labelArabic;
  const MatchType(this.labelArabic);
}

/// Domain model representing a matched recipe scored against pantry ingredients.
class RecipeMatch {
  final Recipe recipe;
  final double coveragePercent;
  final int matchedCount;
  final int totalRequired;
  final List<RecipeIngredient> missingIngredients;
  final List<RecipeIngredient> availableIngredients;
  final MatchType matchType;

  const RecipeMatch({
    required this.recipe,
    required this.coveragePercent,
    required this.matchedCount,
    required this.totalRequired,
    required this.missingIngredients,
    required this.availableIngredients,
    required this.matchType,
  });

  bool get isReadyNow => matchType == MatchType.readyNow;
  bool get isAlmostReady => matchType == MatchType.almostReady;
  int get missingCount => missingIngredients.length;
}
