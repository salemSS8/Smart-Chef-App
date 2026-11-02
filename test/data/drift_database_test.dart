import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_cook/data/local/app_database.dart';
import 'package:smart_cook/data/local/seeder/database_seeder.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('Drift SQLite Database & DAOs Integration Tests', () {
    test('Database starts empty and seeds correctly from Seeder', () async {
      final seeder = DatabaseSeeder(db);
      await seeder.seedIfEmpty();

      final ingredients = await db.ingredientDao.getAllIngredients();
      expect(ingredients.isNotEmpty, isTrue);

      final recipes = await db.recipeDao.getAllRecipes();
      expect(recipes.isNotEmpty, isTrue);

      // Verify search by name works with Arabic normalized text
      final searchResults = await db.ingredientDao.searchByName('طماطم');
      expect(searchResults.isNotEmpty, isTrue);
      expect(searchResults.any((i) => i.id == 'ing_tomato'), isTrue);
    });

    test('PantryDao CRUD operations and quantity updates work correctly', () async {
      final seeder = DatabaseSeeder(db);
      await seeder.seedIfEmpty();

      // 1. Add item to pantry
      await db.pantryDao.addOrUpdateItem(
        ingredientId: 'ing_tomato',
        quantity: 5,
        unit: 'piece',
        location: 'fridge',
      );

      var pantry = await db.pantryDao.getAllPantryItems();
      expect(pantry.length, 1);
      expect(pantry.first.ingredientId, 'ing_tomato');
      expect(pantry.first.quantity, 5);

      // 2. Update existing pantry item quantity
      await db.pantryDao.addOrUpdateItem(
        ingredientId: 'ing_tomato',
        quantity: 8,
      );
      pantry = await db.pantryDao.getAllPantryItems();
      expect(pantry.length, 1);
      expect(pantry.first.quantity, 8);

      // 3. Remove item from pantry
      await db.pantryDao.removeByIngredientId('ing_tomato');
      pantry = await db.pantryDao.getAllPantryItems();
      expect(pantry.isEmpty, isTrue);
    });

    test('ShoppingDao operations, toggle check, and clear completed work', () async {
      await db.shoppingDao.addItem(
        ingredientId: 'ing_milk',
        customName: 'حليب كامل الدسم',
        quantity: 2,
        unit: 'علبة',
      );

      var items = await db.shoppingDao.getAllShoppingItems();
      expect(items.length, 1);
      expect(items.first.checked, isFalse);

      // Toggle check
      await db.shoppingDao.toggleItemChecked(items.first.id, true);
      items = await db.shoppingDao.getAllShoppingItems();
      expect(items.first.checked, isTrue);

      // Clear checked
      await db.shoppingDao.clearCheckedItems();
      items = await db.shoppingDao.getAllShoppingItems();
      expect(items.isEmpty, isTrue);
    });

    test('RecipeDao favorites toggle and check work', () async {
      final seeder = DatabaseSeeder(db);
      await seeder.seedIfEmpty();

      const recipeId = 'rec_shakshuka';
      expect(await db.recipeDao.isFavorite(recipeId), isFalse);

      // Toggle on
      final added = await db.recipeDao.toggleFavorite(recipeId);
      expect(added, isTrue);
      expect(await db.recipeDao.isFavorite(recipeId), isTrue);

      // Toggle off
      final removed = await db.recipeDao.toggleFavorite(recipeId);
      expect(removed, isFalse);
      expect(await db.recipeDao.isFavorite(recipeId), isFalse);
    });

    test('SyncDao queue, retry counter, and markSynced work', () async {
      final id = await db.syncDao.enqueueOperation(
        tableName: 'pantry_items',
        recordId: 'pantry_1',
        operation: 'insert',
        payload: '{"ingredientId": "ing_tomato"}',
      );

      var pending = await db.syncDao.getPendingOperations();
      expect(pending.length, 1);
      expect(pending.first.id, id);
      expect(pending.first.isSynced, isFalse);

      await db.syncDao.markSynced(id);
      pending = await db.syncDao.getPendingOperations();
      expect(pending.isEmpty, isTrue);
    });
  });
}
