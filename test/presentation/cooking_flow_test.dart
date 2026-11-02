import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:smart_cook/data/local/app_database.dart' hide RecipeIngredient;
import 'package:smart_cook/data/local/database_provider.dart';
import 'package:smart_cook/domain/models/recipe.dart';
import 'package:smart_cook/presentation/providers/favorites_provider.dart';
import 'package:smart_cook/presentation/providers/matching_provider.dart';
import 'package:smart_cook/presentation/providers/pantry_provider.dart';
import 'package:smart_cook/presentation/providers/shopping_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase inMemoryDb;
  late ProviderContainer container;


  setUp(() {
    inMemoryDb = AppDatabase(NativeDatabase.memory());
    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(inMemoryDb),
        pantryDaoProvider.overrideWithValue(inMemoryDb.pantryDao),
        recipeDaoProvider.overrideWithValue(inMemoryDb.recipeDao),
        shoppingDaoProvider.overrideWithValue(inMemoryDb.shoppingDao),
      ],
    );
  });

  tearDown(() async {
    container.dispose();
    await inMemoryDb.close();
  });

  group('Sprint 4 - Interactive Cooking Flow & UI Wiring Tests', () {
    test('PantryNotifier updates state and persists directly to Drift DB', () async {
      final pantryNotifier = container.read(pantryProvider.notifier);

      // Add chicken to pantry
      await pantryNotifier.toggleIngredient('ing_chicken_breast');
      expect(container.read(pantryProvider).contains('ing_chicken_breast'), isTrue);

      // Verify stored in Drift database
      final storedIds = await inMemoryDb.pantryDao.getAvailableIngredientIds();
      expect(storedIds.contains('ing_chicken_breast'), isTrue);

      // Remove chicken
      await pantryNotifier.toggleIngredient('ing_chicken_breast');
      expect(container.read(pantryProvider).contains('ing_chicken_breast'), isFalse);
    });

    test('MatchingProvider dynamically recalculates matches when pantry items change', () async {
      final pantryNotifier = container.read(pantryProvider.notifier);

      // Empty pantry
      await pantryNotifier.clearAll();
      var matchingState = container.read(matchingProvider);
      expect(matchingState.readyRecipes.isEmpty, isTrue);

      // Add 3 ingredients: eggs, tomato, onion (missing bell pepper)
      await pantryNotifier.addMultiple(['ing_eggs', 'ing_tomato', 'ing_onion']);
      matchingState = container.read(matchingProvider);
      expect(matchingState.missingOneRecipes.any((r) => r.recipe.id == 'rec_shakshuka'), isTrue);

      // Now add bell pepper
      await pantryNotifier.addMultiple(['ing_bell_pepper']);
      matchingState = container.read(matchingProvider);
      // Shakshuka should now be fully ready
      expect(matchingState.readyRecipes.any((r) => r.recipe.id == 'rec_shakshuka'), isTrue);
    });

    test('ShoppingNotifier adds missing recipe ingredients and transfers completed items to pantry', () async {
      final shoppingNotifier = container.read(shoppingProvider.notifier);
      final pantryNotifier = container.read(pantryProvider.notifier);

      await pantryNotifier.clearAll();

      // 1. Add missing ingredients for a recipe
      const missingIngredients = [
        RecipeIngredient(
          ingredientId: 'ing_tomato',
          name: 'طماطم',
          role: IngredientRole.core,
          amount: '2 حبة',
        ),
        RecipeIngredient(
          ingredientId: 'ing_eggs',
          name: 'بيض',
          role: IngredientRole.core,
          amount: '4 حبات',
        ),
      ];

      await shoppingNotifier.addMissingIngredients(missingIngredients, 'شكشوكة');
      var list = container.read(shoppingProvider);
      expect(list.length, 2);

      // 2. Mark tomato as purchased (completed)
      await shoppingNotifier.toggleCompleted(0);
      list = container.read(shoppingProvider);
      expect(list[0].isCompleted, isTrue);

      // 3. Transfer completed item to pantry
      final transferred = await shoppingNotifier.transferCompletedToPantry();
      expect(transferred.contains('ing_tomato'), isTrue);

      // 4. Verify tomato is now in pantry and removed from shopping
      expect(container.read(pantryProvider).contains('ing_tomato'), isTrue);
      expect(container.read(shoppingProvider).length, 1);
    });

    test('FavoritesNotifier toggles and watches favorites in Drift DB', () async {
      final favoritesNotifier = container.read(favoritesProvider.notifier);

      expect(container.read(favoritesProvider).contains('rec_kabsa'), isFalse);

      await favoritesNotifier.toggleFavorite('rec_kabsa');
      expect(container.read(favoritesProvider).contains('rec_kabsa'), isTrue);

      // Verify in DB
      final isFavInDb = await inMemoryDb.recipeDao.isFavorite('rec_kabsa');
      expect(isFavInDb, isTrue);

      // Toggle off
      await favoritesNotifier.toggleFavorite('rec_kabsa');
      expect(container.read(favoritesProvider).contains('rec_kabsa'), isFalse);
    });
  });
}
