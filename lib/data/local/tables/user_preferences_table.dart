import 'package:drift/drift.dart';

/// Table representing user settings, diet constraints, and household preferences.
class UserPreferencesTable extends Table {
  IntColumn get id => integer().autoIncrement()(); // Always 1 row
  TextColumn get locale => text().withDefault(const Constant('ar'))();
  TextColumn get region => text().nullable()(); // 'gulf', 'levant', 'egypt'
  TextColumn get measurementSystem => text().withDefault(const Constant('metric'))();
  TextColumn get allergens => text().withDefault(const Constant('[]'))(); // JSON array
  TextColumn get diets => text().withDefault(const Constant('[]'))(); // JSON array
  TextColumn get excludedIngredients => text().withDefault(const Constant('[]'))(); // JSON array
  IntColumn get householdSize => integer().withDefault(const Constant(2))();
  BoolColumn get assumeStaples => boolean().withDefault(const Constant(true))();
  TextColumn get equipment => text().withDefault(const Constant('[]'))();
  DateTimeColumn get updatedAt => dateTime()();
}
