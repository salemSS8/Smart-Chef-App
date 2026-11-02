import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/ingredients_table.dart';
import 'tables/recipes_table.dart';
import 'tables/pantry_table.dart';
import 'tables/shopping_table.dart';
import 'tables/user_preferences_table.dart';
import 'tables/sync_queue_table.dart';

import 'daos/ingredient_dao.dart';
import 'daos/recipe_dao.dart';
import 'daos/pantry_dao.dart';
import 'daos/shopping_dao.dart';
import 'daos/sync_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Ingredients,
    IngredientNames,
    IngredientSubstitutes,
    Recipes,
    RecipeIngredients,
    RecipeSteps,
    PantryItems,
    Favorites,
    CookSessions,
    ShoppingItems,
    UserPreferencesTable,
    SyncQueue,
  ],
  daos: [
    IngredientDao,
    RecipeDao,
    PantryDao,
    ShoppingDao,
    SyncDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? _openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
  );

  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'smart_cook.sqlite'));
      return NativeDatabase.createInBackground(file);
    });
  }
}
