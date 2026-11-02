import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/ingredients_table.dart';

part 'ingredient_dao.g.dart';

@DriftAccessor(tables: [Ingredients, IngredientNames, IngredientSubstitutes])
class IngredientDao extends DatabaseAccessor<AppDatabase> with _$IngredientDaoMixin {
  IngredientDao(super.db);

  /// Fetch all registered ingredients
  Future<List<Ingredient>> getAllIngredients() => select(ingredients).get();

  /// Watch all ingredients as a stream
  Stream<List<Ingredient>> watchAllIngredients() => select(ingredients).watch();

  /// Get single ingredient by ID
  Future<Ingredient?> getIngredientById(String id) {
    return (select(ingredients)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  /// Get ingredients by category (vegetable, meat, dairy, etc.)
  Future<List<Ingredient>> getByCategory(String category) {
    return (select(ingredients)..where((tbl) => tbl.category.equals(category))).get();
  }

  /// Get kitchen staple ingredients
  Future<List<Ingredient>> getStaples() {
    return (select(ingredients)..where((tbl) => tbl.isStaple.equals(true))).get();
  }

  /// Search ingredients by name using normalized pattern match
  Future<List<Ingredient>> searchByName(String query) async {
    final cleanQuery = _normalizeArabic(query.trim());
    if (cleanQuery.isEmpty) return [];

    final matchedNames = await (select(ingredientNames)
          ..where((tbl) =>
              tbl.normalized.like('%$cleanQuery%') | tbl.name.like('%$cleanQuery%')))
        .get();

    final matchedIds = matchedNames.map((n) => n.ingredientId).toSet();
    if (matchedIds.isEmpty) return [];

    return (select(ingredients)..where((tbl) => tbl.id.isIn(matchedIds))).get();
  }

  /// Batch insert or update ingredients
  Future<void> upsertIngredients(List<IngredientsCompanion> items) async {
    await batch((b) {
      b.insertAllOnConflictUpdate(ingredients, items);
    });
  }

  /// Batch insert or update ingredient names
  Future<void> upsertNames(List<IngredientNamesCompanion> items) async {
    await batch((b) {
      b.insertAllOnConflictUpdate(ingredientNames, items);
    });
  }

  /// Normalize Arabic text (removes diacritics and unifies alef/yaa/taa marbouta)
  static String _normalizeArabic(String text) {
    return text
        .replaceAll(RegExp(r'[\u064B-\u065F\u0670]'), '')
        .replaceAll('إ', 'ا')
        .replaceAll('أ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ة', 'ه')
        .replaceAll('ى', 'ي');
  }
}
