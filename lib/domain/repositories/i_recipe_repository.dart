import '../models/recipe.dart';

/// Contract interface for recipe and favorites operations.
abstract class IRecipeRepository {
  /// Fetch all available recipes
  Future<List<Recipe>> getAllRecipes();

  /// Get recipe by ID
  Future<Recipe?> getRecipeById(String id);

  /// Watch favorite recipe IDs as stream
  Stream<List<String>> watchFavoriteRecipeIds();

  /// Toggle favorite status of recipe
  Future<bool> toggleFavorite(String recipeId);

  /// Check if recipe is favorited
  Future<bool> isFavorite(String recipeId);
}
