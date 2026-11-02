import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/models/recipe.dart';
import '../../domain/repositories/i_recipe_repository.dart';
import '../local/daos/recipe_dao.dart';
import '../mock/recipes_data.dart';

/// Implementation of IRecipeRepository backed by Supabase and verified recipes catalog fallback.
class RecipeRepositoryImpl implements IRecipeRepository {
  final RecipeDao _recipeDao;
  List<Recipe>? _cachedRecipes;

  RecipeRepositoryImpl(this._recipeDao);

  @override
  Future<List<Recipe>> getAllRecipes() async {
    if (_cachedRecipes != null && _cachedRecipes!.isNotEmpty) {
      return _cachedRecipes!;
    }

    try {
      final client = Supabase.instance.client;
      final response = await client
          .from('recipes')
          .select()
          .order('created_at', ascending: false);

      if (response.isNotEmpty) {
        final serverRecipes = response
            .map((e) => Recipe.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();

        // Merge server recipes with local catalog (preventing duplicates)
        final serverIds = serverRecipes.map((r) => r.id).toSet();
        final combined = [
          ...serverRecipes,
          ...RecipesData.allRecipes.where((r) => !serverIds.contains(r.id)),
        ];
        _cachedRecipes = combined;
        return combined;
      }
    } catch (e) {
      debugPrint('Error fetching recipes from Supabase, using mock data fallback: $e');
    }

    _cachedRecipes = RecipesData.allRecipes;
    return RecipesData.allRecipes;
  }

  @override
  Future<Recipe?> getRecipeById(String id) async {
    final list = await getAllRecipes();
    try {
      return list.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Stream<List<String>> watchFavoriteRecipeIds() {
    return _recipeDao.watchFavoriteRecipeIds();
  }

  @override
  Future<bool> toggleFavorite(String recipeId) {
    return _recipeDao.toggleFavorite(recipeId);
  }

  @override
  Future<bool> isFavorite(String recipeId) {
    return _recipeDao.isFavorite(recipeId);
  }
}
