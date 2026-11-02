import '../models/match_filters.dart';
import '../models/recipe_match.dart';
import '../repositories/i_pantry_repository.dart';
import '../repositories/i_recipe_repository.dart';
import '../services/recipe_matcher.dart';

/// UseCase coordinating recipe matching between pantry ingredients and recipe catalog.
class MatchRecipesUseCase {
  final IPantryRepository _pantryRepository;
  final IRecipeRepository _recipeRepository;

  MatchRecipesUseCase({
    required IPantryRepository pantryRepository,
    required IRecipeRepository recipeRepository,
  })  : _pantryRepository = pantryRepository,
        _recipeRepository = recipeRepository;

  /// Executes matching against current pantry stock and given filters.
  Future<List<RecipeMatch>> execute({
    MatchFilters filters = MatchFilters.defaultFilters,
    bool useIsolate = true,
  }) async {
    final userPantryIds = await _pantryRepository.getAvailableIngredientIds();
    final recipes = await _recipeRepository.getAllRecipes();

    return RecipeMatcher.match(
      recipes: recipes,
      userPantryIds: userPantryIds,
      filters: filters,
      useIsolate: useIsolate,
    );
  }
}
