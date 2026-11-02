import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/local/database_provider.dart';
import '../../data/repositories/pantry_repository_impl.dart';
import '../../data/repositories/recipe_repository_impl.dart';
import '../../domain/models/match_filters.dart';
import '../../domain/models/recipe_match.dart';
import '../../domain/repositories/i_pantry_repository.dart';
import '../../domain/repositories/i_recipe_repository.dart';
import '../../domain/usecases/match_recipes_usecase.dart';
import '../../domain/usecases/search_ingredients_usecase.dart';

/// Repository Providers
final pantryRepositoryProvider = Provider<IPantryRepository>((ref) {
  final dao = ref.watch(pantryDaoProvider);
  return PantryRepositoryImpl(dao);
});

final recipeRepositoryProvider = Provider<IRecipeRepository>((ref) {
  final dao = ref.watch(recipeDaoProvider);
  return RecipeRepositoryImpl(dao);
});

/// UseCase Providers
final matchRecipesUseCaseProvider = Provider<MatchRecipesUseCase>((ref) {
  return MatchRecipesUseCase(
    pantryRepository: ref.watch(pantryRepositoryProvider),
    recipeRepository: ref.watch(recipeRepositoryProvider),
  );
});

final searchIngredientsUseCaseProvider = Provider<SearchIngredientsUseCase>((ref) {
  return SearchIngredientsUseCase(ref.watch(ingredientDaoProvider));
});

/// Active Match Filters State
final matchFiltersProvider = StateProvider<MatchFilters>((ref) {
  return MatchFilters.defaultFilters;
});

/// Main Reactive Matching Engine Provider
/// Automatically recomputes matches whenever pantry stock or filters change
final matchingEngineProvider = FutureProvider<List<RecipeMatch>>((ref) async {
  // Listen to pantry reactive changes to trigger automatic recalculation
  ref.watch(pantryItemsStreamProvider);

  final filters = ref.watch(matchFiltersProvider);
  final useCase = ref.watch(matchRecipesUseCaseProvider);

  return useCase.execute(filters: filters);
});

/// Computed category slices for easy UI consumption
final readyNowMatchesProvider = Provider<List<RecipeMatch>>((ref) {
  final matchesAsync = ref.watch(matchingEngineProvider);
  return matchesAsync.maybeWhen(
    data: (matches) => matches.where((m) => m.isReadyNow).toList(),
    orElse: () => [],
  );
});

final almostReadyMatchesProvider = Provider<List<RecipeMatch>>((ref) {
  final matchesAsync = ref.watch(matchingEngineProvider);
  return matchesAsync.maybeWhen(
    data: (matches) => matches.where((m) => m.isAlmostReady).toList(),
    orElse: () => [],
  );
});

final ideaMatchesProvider = Provider<List<RecipeMatch>>((ref) {
  final matchesAsync = ref.watch(matchingEngineProvider);
  return matchesAsync.maybeWhen(
    data: (matches) => matches.where((m) => m.matchType == MatchType.idea).toList(),
    orElse: () => [],
  );
});
