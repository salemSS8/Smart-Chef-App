import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/recipes_table.dart';
import '../tables/pantry_table.dart';

part 'recipe_dao.g.dart';

@DriftAccessor(tables: [Recipes, RecipeIngredients, RecipeSteps, Favorites])
class RecipeDao extends DatabaseAccessor<AppDatabase> with _$RecipeDaoMixin {
  RecipeDao(super.db);

  /// Get all recipes
  Future<List<Recipe>> getAllRecipes() => select(recipes).get();

  /// Watch all recipes as stream
  Stream<List<Recipe>> watchAllRecipes() => select(recipes).watch();

  /// Get recipe by ID
  Future<Recipe?> getRecipeById(String id) {
    return (select(recipes)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  /// Get ingredients for a specific recipe
  Future<List<RecipeIngredient>> getIngredientsForRecipe(String recipeId) {
    return (select(recipeIngredients)
          ..where((tbl) => tbl.recipeId.equals(recipeId))
          ..orderBy([(tbl) => OrderingTerm(expression: tbl.sortOrder)]))
        .get();
  }

  /// Get steps for a specific recipe
  Future<List<RecipeStep>> getStepsForRecipe(String recipeId) {
    return (select(recipeSteps)
          ..where((tbl) => tbl.recipeId.equals(recipeId))
          ..orderBy([(tbl) => OrderingTerm(expression: tbl.stepNo)]))
        .get();
  }

  /// Check if recipe is favorited
  Future<bool> isFavorite(String recipeId) async {
    final fav = await (select(favorites)..where((tbl) => tbl.recipeId.equals(recipeId)))
        .getSingleOrNull();
    return fav != null;
  }

  /// Watch list of favorited recipe IDs
  Stream<List<String>> watchFavoriteRecipeIds() {
    return select(favorites).watch().map((favs) => favs.map((f) => f.recipeId).toList());
  }

  /// Toggle favorite status of a recipe
  Future<bool> toggleFavorite(String recipeId) async {
    final existing = await (select(favorites)..where((tbl) => tbl.recipeId.equals(recipeId)))
        .getSingleOrNull();

    if (existing != null) {
      await (delete(favorites)..where((tbl) => tbl.recipeId.equals(recipeId))).go();
      return false; // Removed from favorites
    } else {
      await into(favorites).insert(
        FavoritesCompanion.insert(
          recipeId: recipeId,
          createdAt: DateTime.now(),
        ),
      );
      return true; // Added to favorites
    }
  }

  /// Batch insert or update recipes
  Future<void> upsertRecipes(List<RecipesCompanion> items) async {
    await batch((b) {
      b.insertAllOnConflictUpdate(recipes, items);
    });
  }

  /// Batch insert or update recipe ingredients
  Future<void> upsertRecipeIngredients(List<RecipeIngredientsCompanion> items) async {
    await batch((b) {
      b.insertAllOnConflictUpdate(recipeIngredients, items);
    });
  }

  /// Batch insert or update recipe steps
  Future<void> upsertRecipeSteps(List<RecipeStepsCompanion> items) async {
    await batch((b) {
      b.insertAllOnConflictUpdate(recipeSteps, items);
    });
  }
}
