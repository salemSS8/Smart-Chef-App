import 'package:drift/drift.dart';
import 'ingredients_table.dart';
import 'recipes_table.dart';

/// Table representing user pantry / kitchen stock items.
class PantryItems extends Table {
  TextColumn get id => text()(); // UUID or unique item key
  TextColumn get ingredientId => text().references(Ingredients, #id)();
  RealColumn get quantity => real().nullable()();
  TextColumn get unit => text().nullable()(); // g, kg, piece, packet
  TextColumn get location => text().nullable()(); // 'fridge', 'freezer', 'pantry', 'spices'
  DateTimeColumn get addedAt => dateTime()();
  DateTimeColumn get expiresOn => dateTime().nullable()();
  TextColumn get source => text().withDefault(const Constant('manual'))(); // 'manual', 'scanner', 'shopping'
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Table representing user bookmarked / favorite recipes.
class Favorites extends Table {
  TextColumn get recipeId => text().references(Recipes, #id)();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {recipeId};
}

/// Table tracking active and completed interactive cooking sessions.
class CookSessions extends Table {
  TextColumn get id => text()();
  TextColumn get recipeId => text().references(Recipes, #id)();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  IntColumn get servings => integer().nullable()();
  IntColumn get rating => integer().nullable()(); // 1-5 stars
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
