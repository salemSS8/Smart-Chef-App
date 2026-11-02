import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/pantry_table.dart';
import '../tables/ingredients_table.dart';

part 'pantry_dao.g.dart';

@DriftAccessor(tables: [PantryItems, Ingredients])
class PantryDao extends DatabaseAccessor<AppDatabase> with _$PantryDaoMixin {
  PantryDao(super.db);

  /// Watch all current pantry items as an observable stream
  Stream<List<PantryItem>> watchPantryItems() {
    return select(pantryItems).watch();
  }

  /// Get list of all pantry items asynchronously
  Future<List<PantryItem>> getAllPantryItems() {
    return select(pantryItems).get();
  }

  /// Get set of currently available ingredient IDs in the pantry
  Future<Set<String>> getAvailableIngredientIds() async {
    final items = await select(pantryItems).get();
    return items.map((i) => i.ingredientId).toSet();
  }

  /// Add ingredient to pantry or update its quantity
  Future<void> addOrUpdateItem({
    required String ingredientId,
    double? quantity,
    String? unit,
    String? location,
    DateTime? expiresOn,
  }) async {
    final existing = await (select(pantryItems)
          ..where((tbl) => tbl.ingredientId.equals(ingredientId)))
        .getSingleOrNull();

    if (existing != null) {
      // Update existing item
      await (update(pantryItems)..where((tbl) => tbl.id.equals(existing.id))).write(
        PantryItemsCompanion(
          quantity: Value(quantity ?? existing.quantity),
          unit: Value(unit ?? existing.unit),
          location: Value(location ?? existing.location),
          expiresOn: Value(expiresOn ?? existing.expiresOn),
        ),
      );
    } else {
      // Insert new item
      await into(pantryItems).insert(
        PantryItemsCompanion.insert(
          id: 'pantry_${DateTime.now().millisecondsSinceEpoch}_$ingredientId',
          ingredientId: ingredientId,
          quantity: Value(quantity),
          unit: Value(unit),
          location: Value(location ?? 'fridge'),
          addedAt: DateTime.now(),
          expiresOn: Value(expiresOn),
        ),
      );
    }
  }

  /// Remove item from pantry by primary key ID
  Future<int> removeItem(String id) {
    return (delete(pantryItems)..where((tbl) => tbl.id.equals(id))).go();
  }

  /// Remove item from pantry by ingredient ID
  Future<int> removeByIngredientId(String ingredientId) {
    return (delete(pantryItems)..where((tbl) => tbl.ingredientId.equals(ingredientId))).go();
  }

  /// Clear all items in the pantry
  Future<int> clearPantry() {
    return delete(pantryItems).go();
  }
}
