import '../../core/utils/arabic_normalizer.dart';
import '../../data/local/app_database.dart';
import '../../data/local/daos/ingredient_dao.dart';

/// UseCase handling smart ingredient search with Arabic normalization
/// and query parsing.
class SearchIngredientsUseCase {
  final IngredientDao _ingredientDao;

  SearchIngredientsUseCase(this._ingredientDao);

  /// Search ingredients by name or synonym.
  Future<List<Ingredient>> execute(String query) async {
    final clean = query.trim();
    if (clean.isEmpty) return [];

    return _ingredientDao.searchByName(clean);
  }

  /// Parse natural voice sentence and extract known ingredients.
  /// Example: "عندي بيض وطماطم وبصل" -> returns matched ingredient entities
  Future<List<Ingredient>> extractFromSentence(String sentence) async {
    final tokens = ArabicNormalizer.extractIngredientNames(sentence);
    if (tokens.isEmpty) return [];

    final matched = <String, Ingredient>{};
    for (final token in tokens) {
      final results = await _ingredientDao.searchByName(token);
      for (final ing in results) {
        matched[ing.id] = ing;
      }
    }

    return matched.values.toList();
  }
}
