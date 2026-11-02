import 'package:drift/drift.dart';

/// Table representing items on the user's smart shopping list.
class ShoppingItems extends Table {
  TextColumn get id => text()(); // UUID or item key
  TextColumn get ingredientId => text().nullable()(); // Linked ingredient if known
  TextColumn get customName => text().nullable()(); // Fallback custom entered name
  RealColumn get quantity => real().nullable()();
  TextColumn get unit => text().nullable()();
  BoolColumn get checked => boolean().withDefault(const Constant(false))();
  TextColumn get sourceRecipeId => text().nullable()(); // If added from a recipe
  DateTimeColumn get addedAt => dateTime()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
