import 'package:drift/drift.dart';
import 'ingredients_table.dart';

/// Table representing culinary recipes.
class Recipes extends Table {
  TextColumn get id => text()(); // e.g. 'rec_shakshuka'
  TextColumn get slug => text().unique()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  TextColumn get cuisine => text().nullable()(); // 'عربي مشترك', 'شامي', 'خليجي'
  TextColumn get mealType => text().withDefault(const Constant('[]'))(); // JSON array
  IntColumn get difficulty => integer().withDefault(const Constant(1))(); // 1=Easy, 2=Med, 3=Hard
  IntColumn get prepMinutes => integer().nullable()();
  IntColumn get cookMinutes => integer().nullable()();
  IntColumn get totalMinutes => integer().nullable()();
  IntColumn get baseServings => integer().withDefault(const Constant(2))();
  IntColumn get caloriesPerServing => integer().nullable()();
  TextColumn get equipment => text().withDefault(const Constant('[]'))();
  TextColumn get dietFlags => text().withDefault(const Constant('{}'))();
  TextColumn get allergens => text().withDefault(const Constant('[]'))();
  TextColumn get sourceType => text().withDefault(const Constant('editorial'))();
  BoolColumn get verified => boolean().withDefault(const Constant(false))();
  TextColumn get heroImageUrl => text().nullable()();
  TextColumn get blurhash => text().nullable()();
  RealColumn get ratingAvg => real().withDefault(const Constant(0.0))();
  IntColumn get ratingCount => integer().withDefault(const Constant(0))();
  TextColumn get status => text().withDefault(const Constant('published'))();
  DateTimeColumn get publishedAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Junction table linking recipes to required and optional ingredients.
class RecipeIngredients extends Table {
  TextColumn get recipeId => text().references(Recipes, #id)();
  TextColumn get ingredientId => text().references(Ingredients, #id)();
  TextColumn get role => text()(); // 'core', 'important', 'optional', 'staple'
  RealColumn get amount => real().nullable()();
  TextColumn get unit => text().nullable()();
  TextColumn get displayText => text().nullable()();
  TextColumn get groupLabel => text().withDefault(const Constant(''))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {recipeId, ingredientId, groupLabel};
}

/// Table representing step-by-step instructions for each recipe.
class RecipeSteps extends Table {
  TextColumn get recipeId => text().references(Recipes, #id)();
  IntColumn get stepNo => integer()();
  TextColumn get stepText => text().named('step_text')();
  TextColumn get imageUrl => text().nullable()();
  IntColumn get timerSeconds => integer().nullable()();
  TextColumn get tip => text().nullable()();

  @override
  Set<Column> get primaryKey => {recipeId, stepNo};
}
