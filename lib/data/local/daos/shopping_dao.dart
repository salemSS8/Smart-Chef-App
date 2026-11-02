import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/shopping_table.dart';
import '../tables/ingredients_table.dart';

part 'shopping_dao.g.dart';

@DriftAccessor(tables: [ShoppingItems, Ingredients])
class ShoppingDao extends DatabaseAccessor<AppDatabase> with _$ShoppingDaoMixin {
  ShoppingDao(super.db);

  /// Watch all shopping items as an observable stream
  Stream<List<ShoppingItem>> watchShoppingItems() {
    return (select(shoppingItems)..orderBy([(tbl) => OrderingTerm(expression: tbl.addedAt)]))
        .watch();
  }

  /// Get all shopping items
  Future<List<ShoppingItem>> getAllShoppingItems() {
    return select(shoppingItems).get();
  }

  /// Add item to shopping list and return the created item id
  Future<String> addItem({
    String? id,
    String? ingredientId,
    String? customName,
    double? quantity,
    String? unit,
    String? sourceRecipeId,
  }) async {
    final itemId = id ?? 'shop_${DateTime.now().millisecondsSinceEpoch}_${(customName ?? ingredientId ?? "").hashCode}';
    await into(shoppingItems).insert(
      ShoppingItemsCompanion.insert(
        id: itemId,
        ingredientId: Value(ingredientId),
        customName: Value(customName),
        quantity: Value(quantity),
        unit: Value(unit),
        sourceRecipeId: Value(sourceRecipeId),
        addedAt: DateTime.now(),
      ),
    );
    return itemId;
  }


  /// Toggle item checked status
  Future<void> toggleItemChecked(String id, bool isChecked) {
    return (update(shoppingItems)..where((tbl) => tbl.id.equals(id))).write(
      ShoppingItemsCompanion(checked: Value(isChecked)),
    );
  }

  /// Remove item from list
  Future<int> removeItem(String id) {
    return (delete(shoppingItems)..where((tbl) => tbl.id.equals(id))).go();
  }

  /// Remove all checked/purchased items
  Future<int> clearCheckedItems() {
    return (delete(shoppingItems)..where((tbl) => tbl.checked.equals(true))).go();
  }

  /// Get all checked items (ready to move to pantry)
  Future<List<ShoppingItem>> getCheckedItems() {
    return (select(shoppingItems)..where((tbl) => tbl.checked.equals(true))).get();
  }
}
