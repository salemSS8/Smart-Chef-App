import 'package:drift/drift.dart';

/// Table representing all registered culinary ingredients.
class Ingredients extends Table {
  TextColumn get id => text()(); // e.g. 'ing_tomato'
  TextColumn get category => text()(); // vegetable, meat, dairy, spice, grain, oil, other
  TextColumn get parentId => text().nullable()();
  BoolColumn get isStaple => boolean().withDefault(const Constant(false))();
  TextColumn get defaultUnit => text().nullable()(); // g, ml, piece, cup, spoon
  IntColumn get shelfLifeFridgeDays => integer().nullable()();
  IntColumn get shelfLifePantryDays => integer().nullable()();
  TextColumn get allergens => text().withDefault(const Constant('[]'))(); // JSON array
  TextColumn get dietFlags => text().withDefault(const Constant('{}'))(); // JSON object
  TextColumn get imageUrl => text().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Table representing localized names and regional synonyms for ingredients.
class IngredientNames extends Table {
  TextColumn get ingredientId => text().references(Ingredients, #id)();
  TextColumn get lang => text()(); // 'ar', 'en'
  TextColumn get region => text().nullable()(); // 'gulf', 'levant', 'egypt', 'maghreb'
  TextColumn get name => text()();
  TextColumn get normalized => text()(); // Normalized without accents/diacritics for fast search
  BoolColumn get isPrimary => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {ingredientId, lang, name};
}

/// Table representing culinary substitutions when an ingredient is missing.
class IngredientSubstitutes extends Table {
  @ReferenceName('sourceSubstitutes')
  TextColumn get ingredientId => text().references(Ingredients, #id)();

  @ReferenceName('targetSubstitutes')
  TextColumn get substituteId => text().references(Ingredients, #id)();

  RealColumn get ratio => real().withDefault(const Constant(1.0))();
  TextColumn get quality => text()(); // ideal, acceptable, avoid
  TextColumn get contextTags => text().withDefault(const Constant('[]'))();
  TextColumn get noteAr => text().nullable()();

  @override
  Set<Column> get primaryKey => {ingredientId, substituteId};
}
