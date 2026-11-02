import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_database.dart';
import 'daos/ingredient_dao.dart';
import 'daos/pantry_dao.dart';
import 'daos/recipe_dao.dart';
import 'daos/shopping_dao.dart';
import 'daos/sync_dao.dart';
import 'seeder/database_seeder.dart';

/// Provider for the single AppDatabase instance across the lifecycle
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  DatabaseSeeder(db).seedIfEmpty();
  ref.onDispose(() => db.close());
  return db;
});


/// DAOs Providers
final ingredientDaoProvider = Provider<IngredientDao>((ref) {
  return ref.watch(appDatabaseProvider).ingredientDao;
});

final recipeDaoProvider = Provider<RecipeDao>((ref) {
  return ref.watch(appDatabaseProvider).recipeDao;
});

final pantryDaoProvider = Provider<PantryDao>((ref) {
  return ref.watch(appDatabaseProvider).pantryDao;
});

final shoppingDaoProvider = Provider<ShoppingDao>((ref) {
  return ref.watch(appDatabaseProvider).shoppingDao;
});

final syncDaoProvider = Provider<SyncDao>((ref) {
  return ref.watch(appDatabaseProvider).syncDao;
});

/// Reactive Streams Providers
final pantryItemsStreamProvider = StreamProvider<List<PantryItem>>((ref) {
  return ref.watch(pantryDaoProvider).watchPantryItems();
});

final shoppingItemsStreamProvider = StreamProvider<List<ShoppingItem>>((ref) {
  return ref.watch(shoppingDaoProvider).watchShoppingItems();
});

final favoriteRecipeIdsStreamProvider = StreamProvider<List<String>>((ref) {
  return ref.watch(recipeDaoProvider).watchFavoriteRecipeIds();
});
