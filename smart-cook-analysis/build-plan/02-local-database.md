# 02 — قاعدة البيانات المحلية (Drift/SQLite)

> **المدة المُقدَّرة:** 4–6 أيام
> **يعتمد على:** الملف 01 (تأسيس المشروع)
> **الأولوية:** 🔴 عالية — أساس العمل دون اتصال (Offline-first)

---

## 1. لماذا Drift وليس SQLite مباشرة؟

| الميزة | SQLite مباشر | Drift |
|--------|:------------:|:-----:|
| Type-safety | ❌ | ✅ |
| توليد كود | ❌ | ✅ |
| الهجرات (Migrations) | يدوي | مُدار |
| DAOs | يدوي | مدمج |
| استعلامات Reactive (Stream) | يدوي | مدمج |
| FTS5 (بحث نصي) | يدوي | مدعوم |
| Isolate (خلفية) | يدوي | مدمج |

---

## 2. الجداول المحلية

### 2.1 جدول المكونات

```dart
// data/local/tables/ingredients_table.dart

class Ingredients extends Table {
  TextColumn get id => text()();                    // 'ing_tomato'
  TextColumn get category => text()();              // vegetable, meat, dairy...
  TextColumn get parentId => text().nullable()();
  BoolColumn get isStaple => boolean().withDefault(const Constant(false))();
  TextColumn get defaultUnit => text().nullable()();
  IntColumn get shelfLifeFridgeDays => integer().nullable()();
  IntColumn get shelfLifePantryDays => integer().nullable()();
  TextColumn get allergens => text().withDefault(const Constant('[]'))();    // JSON array
  TextColumn get dietFlags => text().withDefault(const Constant('{}'))();    // JSON object
  TextColumn get imageUrl => text().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
```

### 2.2 جدول أسماء المكونات (المرادفات واللهجات)

```dart
class IngredientNames extends Table {
  TextColumn get ingredientId => text().references(Ingredients, #id)();
  TextColumn get lang => text()();                  // 'ar', 'en'
  TextColumn get region => text().nullable()();     // 'gulf', 'levant', 'egypt'
  TextColumn get name => text()();
  TextColumn get normalized => text()();            // بعد إزالة التشكيل
  BoolColumn get isPrimary => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {ingredientId, lang, name};
}
```

### 2.3 جدول بدائل المكونات

```dart
class IngredientSubstitutes extends Table {
  TextColumn get ingredientId => text().references(Ingredients, #id)();
  TextColumn get substituteId => text().references(Ingredients, #id)();
  RealColumn get ratio => real().withDefault(const Constant(1.0))();
  TextColumn get quality => text()();               // ideal, acceptable, avoid
  TextColumn get contextTags => text().withDefault(const Constant('[]'))();
  TextColumn get noteAr => text().nullable()();

  @override
  Set<Column> get primaryKey => {ingredientId, substituteId};
}
```

### 2.4 جدول الوصفات

```dart
class Recipes extends Table {
  TextColumn get id => text()();
  TextColumn get slug => text().unique()();
  TextColumn get title => text()();                 // JSON: {"ar":"...", "en":"..."}
  TextColumn get description => text().nullable()();
  TextColumn get cuisine => text().nullable()();
  TextColumn get mealType => text().withDefault(const Constant('[]'))();
  IntColumn get difficulty => integer().withDefault(const Constant(1))();
  IntColumn get prepMinutes => integer().nullable()();
  IntColumn get cookMinutes => integer().nullable()();
  IntColumn get totalMinutes => integer().nullable()();
  IntColumn get baseServings => integer().withDefault(const Constant(4))();
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
```

### 2.5 جدول مكونات الوصفة (الربط)

```dart
class RecipeIngredients extends Table {
  TextColumn get recipeId => text().references(Recipes, #id)();
  TextColumn get ingredientId => text().references(Ingredients, #id)();
  TextColumn get role => text()();                  // core, important, optional, staple
  RealColumn get amount => real().nullable()();
  TextColumn get unit => text().nullable()();
  TextColumn get displayText => text().nullable()(); // JSON
  TextColumn get groupLabel => text().withDefault(const Constant(''))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {recipeId, ingredientId, groupLabel};
}
```

### 2.6 جدول خطوات الوصفة

```dart
class RecipeSteps extends Table {
  TextColumn get recipeId => text().references(Recipes, #id)();
  IntColumn get stepNo => integer()();
  TextColumn get text_ => text().named('text')();   // JSON: {"ar":"...", "en":"..."}
  TextColumn get imageUrl => text().nullable()();
  IntColumn get timerSeconds => integer().nullable()();
  TextColumn get tip => text().nullable()();         // JSON

  @override
  Set<Column> get primaryKey => {recipeId, stepNo};
}
```

### 2.7 جداول المستخدم

```dart
// مخزون المستخدم
class PantryItems extends Table {
  TextColumn get id => text()();
  TextColumn get ingredientId => text().references(Ingredients, #id)();
  RealColumn get quantity => real().nullable()();
  TextColumn get unit => text().nullable()();
  TextColumn get location => text().nullable()();   // fridge, freezer, pantry
  DateTimeColumn get addedAt => dateTime()();
  DateTimeColumn get expiresOn => dateTime().nullable()();
  TextColumn get source => text().withDefault(const Constant('manual'))();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

// المفضلة
class Favorites extends Table {
  TextColumn get recipeId => text().references(Recipes, #id)();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {recipeId};
}

// قائمة التسوق
class ShoppingItems extends Table {
  TextColumn get id => text()();
  TextColumn get ingredientId => text().nullable()();
  TextColumn get customName => text().nullable()();
  RealColumn get quantity => real().nullable()();
  TextColumn get unit => text().nullable()();
  BoolColumn get checked => boolean().withDefault(const Constant(false))();
  TextColumn get sourceRecipeId => text().nullable()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

// جلسات الطهي
class CookSessions extends Table {
  TextColumn get id => text()();
  TextColumn get recipeId => text().references(Recipes, #id)();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  IntColumn get servings => integer().nullable()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

// تفضيلات المستخدم
class UserPreferencesTable extends Table {
  IntColumn get id => integer().autoIncrement()();  // دائمًا صف واحد
  TextColumn get locale => text().withDefault(const Constant('ar'))();
  TextColumn get region => text().nullable()();
  TextColumn get measurementSystem => text().withDefault(const Constant('metric'))();
  TextColumn get allergens => text().withDefault(const Constant('[]'))();
  TextColumn get diets => text().withDefault(const Constant('[]'))();
  TextColumn get excludedIngredients => text().withDefault(const Constant('[]'))();
  IntColumn get householdSize => integer().withDefault(const Constant(2))();
  BoolColumn get assumeStaples => boolean().withDefault(const Constant(true))();
  TextColumn get equipment => text().withDefault(const Constant('[]'))();
}

// طابور المزامنة
class SyncQueue extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get tableName => text()();
  TextColumn get recordId => text()();
  TextColumn get operation => text()();             // insert, update, delete
  TextColumn get payload => text()();               // JSON
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
}
```

---

## 3. ملف قاعدة البيانات الرئيسي

```dart
// data/local/database.dart

import 'package:drift/drift.dart';

part 'database.g.dart';

@DriftDatabase(tables: [
  Ingredients,
  IngredientNames,
  IngredientSubstitutes,
  Recipes,
  RecipeIngredients,
  RecipeSteps,
  PantryItems,
  Favorites,
  ShoppingItems,
  CookSessions,
  UserPreferencesTable,
  SyncQueue,
], daos: [
  IngredientDao,
  RecipeDao,
  PantryDao,
  ShoppingDao,
  UserPreferencesDao,
  SyncDao,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
      // إنشاء فهارس FTS5 للبحث
      await customStatement('''
        CREATE VIRTUAL TABLE IF NOT EXISTS ingredient_search
        USING fts5(name, normalized, content=ingredient_names);
      ''');
      await customStatement('''
        CREATE VIRTUAL TABLE IF NOT EXISTS recipe_search
        USING fts5(title, content=recipes);
      ''');
    },
    onUpgrade: (Migrator m, int from, int to) async {
      // هجرات مستقبلية
    },
  );
}
```

---

## 4. DAOs (Data Access Objects)

### 4.1 DAO المكونات

```dart
// data/local/daos/ingredient_dao.dart

part 'ingredient_dao.g.dart';

@DriftAccessor(tables: [Ingredients, IngredientNames, IngredientSubstitutes])
class IngredientDao extends DatabaseAccessor<AppDatabase>
    with _$IngredientDaoMixin {
  IngredientDao(super.db);

  // جلب كل المكونات
  Future<List<Ingredient>> getAllIngredients() => select(ingredients).get();

  // بحث بالاسم (FTS5)
  Future<List<IngredientName>> searchByName(String query) {
    final normalized = _normalizeArabic(query);
    return customSelect(
      'SELECT * FROM ingredient_search WHERE ingredient_search MATCH ?',
      variables: [Variable.withString(normalized)],
      readsFrom: {ingredientNames},
    ).map((row) => ingredientNames.map(row.data)).get();
  }

  // جلب مكونات حسب التصنيف
  Future<List<Ingredient>> getByCategory(String category) {
    return (select(ingredients)..where((t) => t.category.equals(category)))
        .get();
  }

  // جلب الأساسيات
  Future<List<Ingredient>> getStaples() {
    return (select(ingredients)..where((t) => t.isStaple.equals(true))).get();
  }

  // جلب البدائل
  Future<List<IngredientSubstitute>> getSubstitutes(String ingredientId) {
    return (select(ingredientSubstitutes)
          ..where((t) => t.ingredientId.equals(ingredientId)))
        .get();
  }

  // إدراج/تحديث دُفعة
  Future<void> upsertBatch(List<IngredientsCompanion> items) async {
    await batch((b) {
      b.insertAllOnConflictUpdate(ingredients, items);
    });
  }

  String _normalizeArabic(String text) {
    // إزالة التشكيل وتوحيد الهمزات
    return text
        .replaceAll(RegExp(r'[\u064B-\u065F\u0670]'), '')
        .replaceAll('إ', 'ا')
        .replaceAll('أ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ة', 'ه');
  }
}
```

### 4.2 DAO الوصفات

```dart
// data/local/daos/recipe_dao.dart

part 'recipe_dao.g.dart';

@DriftAccessor(tables: [Recipes, RecipeIngredients, RecipeSteps])
class RecipeDao extends DatabaseAccessor<AppDatabase> with _$RecipeDaoMixin {
  RecipeDao(super.db);

  // جلب وصفة كاملة (مع المكونات والخطوات)
  Future<RecipeWithDetails?> getFullRecipe(String id) async {
    final recipe = await (select(recipes)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (recipe == null) return null;

    final ings = await (select(recipeIngredients)
          ..where((t) => t.recipeId.equals(id))
          ..orderBy([(t) => OrderingTerm(expression: t.sortOrder)]))
        .get();

    final steps = await (select(recipeSteps)
          ..where((t) => t.recipeId.equals(id))
          ..orderBy([(t) => OrderingTerm(expression: t.stepNo)]))
        .get();

    return RecipeWithDetails(recipe: recipe, ingredients: ings, steps: steps);
  }

  // جلب وصفات مُصفّاة
  Future<List<Recipe>> getFilteredRecipes({
    String? cuisine,
    int? maxMinutes,
    int? maxDifficulty,
    List<String>? mealTypes,
  }) {
    var query = select(recipes);

    if (cuisine != null) {
      query = query..where((t) => t.cuisine.equals(cuisine));
    }
    if (maxMinutes != null) {
      query = query
        ..where((t) => t.totalMinutes.isSmallerOrEqualValue(maxMinutes));
    }
    if (maxDifficulty != null) {
      query = query
        ..where((t) => t.difficulty.isSmallerOrEqualValue(maxDifficulty));
    }

    return query.get();
  }

  // بحث في الوصفات (FTS5)
  Future<List<Recipe>> searchRecipes(String query) {
    return customSelect(
      '''
      SELECT r.* FROM recipes r
      INNER JOIN recipe_search rs ON r.id = rs.rowid
      WHERE recipe_search MATCH ?
      ''',
      variables: [Variable.withString(query)],
      readsFrom: {recipes},
    ).map((row) => recipes.map(row.data)).get();
  }

  // عدد الوصفات
  Future<int> getRecipeCount() async {
    final count = countAll();
    final query = selectOnly(recipes)..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count)!;
  }
}
```

### 4.3 DAO المخزون

```dart
// data/local/daos/pantry_dao.dart

part 'pantry_dao.g.dart';

@DriftAccessor(tables: [PantryItems, Ingredients])
class PantryDao extends DatabaseAccessor<AppDatabase> with _$PantryDaoMixin {
  PantryDao(super.db);

  // مشاهدة المخزون (Stream)
  Stream<List<PantryItemWithIngredient>> watchPantryItems() {
    final query = select(pantryItems).join([
      innerJoin(ingredients, ingredients.id.equalsExp(pantryItems.ingredientId)),
    ]);
    return query.watch().map((rows) {
      return rows.map((row) {
        return PantryItemWithIngredient(
          pantryItem: row.readTable(pantryItems),
          ingredient: row.readTable(ingredients),
        );
      }).toList();
    });
  }

  // إضافة مكوّن للمخزون
  Future<void> addItem(PantryItemsCompanion item) {
    return into(pantryItems).insertOnConflictUpdate(item);
  }

  // حذف مكوّن
  Future<void> removeItem(String id) {
    return (delete(pantryItems)..where((t) => t.id.equals(id))).go();
  }

  // جلب معرّفات المكونات في المخزون (للمطابقة)
  Future<Set<String>> getPantryIngredientIds() async {
    final items = await select(pantryItems).get();
    return items.map((e) => e.ingredientId).toSet();
  }

  // مكونات قريبة من الفساد
  Future<List<PantryItem>> getExpiringSoon({int days = 3}) {
    final threshold = DateTime.now().add(Duration(days: days));
    return (select(pantryItems)
          ..where((t) => t.expiresOn.isSmallerOrEqualValue(threshold))
          ..orderBy([(t) => OrderingTerm(expression: t.expiresOn)]))
        .get();
  }

  // عناصر غير مُزامَنة
  Future<List<PantryItem>> getUnsynced() {
    return (select(pantryItems)..where((t) => t.isSynced.equals(false))).get();
  }
}
```

---

## 5. تهيئة قاعدة البيانات

### 5.1 إنشاء Provider

```dart
// data/local/database_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase(_openConnection());
});

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'smart_cook.db'));
    return NativeDatabase.createInBackground(file);
  });
}

// DAOs
final ingredientDaoProvider = Provider((ref) {
  return ref.watch(databaseProvider).ingredientDao;
});

final recipeDaoProvider = Provider((ref) {
  return ref.watch(databaseProvider).recipeDao;
});

final pantryDaoProvider = Provider((ref) {
  return ref.watch(databaseProvider).pantryDao;
});
```

---

## 6. ترحيل البيانات التجريبية

### 6.1 استراتيجية الترحيل

```
البيانات التجريبية الحالية (data/mock/)
    ↓
تحويلها لبذور (seeds) تُحمَّل في أول تشغيل
    ↓
في المستقبل: تُستبدل بمزامنة من الباك اند
```

### 6.2 ملف البذور

```dart
// data/local/seeds/seed_data.dart

class SeedData {
  static Future<void> seedIfNeeded(AppDatabase db) async {
    final count = await db.recipeDao.getRecipeCount();
    if (count > 0) return; // البذور مُحمَّلة بالفعل

    // تحويل البيانات التجريبية الحالية وإدراجها
    await db.batch((b) {
      b.insertAll(db.ingredients, _convertMockIngredients());
      b.insertAll(db.ingredientNames, _convertMockIngredientNames());
      b.insertAll(db.recipes, _convertMockRecipes());
      b.insertAll(db.recipeIngredients, _convertMockRecipeIngredients());
      b.insertAll(db.recipeSteps, _convertMockRecipeSteps());
    });
  }

  // ... دوال تحويل من Mock لـ Companions
}
```

---

## 7. فهارس الأداء

```sql
-- فهارس أساسية للمطابقة السريعة
CREATE INDEX idx_ri_ingredient ON recipe_ingredients(ingredient_id);
CREATE INDEX idx_ri_recipe ON recipe_ingredients(recipe_id);
CREATE INDEX idx_ri_role ON recipe_ingredients(role);

-- فهارس المخزون
CREATE INDEX idx_pantry_ingredient ON pantry_items(ingredient_id);
CREATE INDEX idx_pantry_expires ON pantry_items(expires_on);

-- فهارس البحث
CREATE INDEX idx_ing_names_normalized ON ingredient_names(normalized);
CREATE INDEX idx_recipes_cuisine ON recipes(cuisine);
CREATE INDEX idx_recipes_difficulty ON recipes(difficulty);
CREATE INDEX idx_recipes_total_minutes ON recipes(total_minutes);
```

---

## 8. قائمة تحقق المرحلة

- [ ] إنشاء مجلد `data/local/tables/` مع جميع ملفات الجداول
- [ ] إنشاء `database.dart` الرئيسي
- [ ] تشغيل `build_runner` وتوليد الكود
- [ ] إنشاء DAOs (ingredient, recipe, pantry, shopping, preferences, sync)
- [ ] إنشاء `database_provider.dart` مع Riverpod
- [ ] إنشاء FTS5 للبحث العربي
- [ ] ترحيل البيانات التجريبية لبذور
- [ ] اختبار: إدراج مكوّن → جلبه ← صحيح
- [ ] اختبار: بحث بالعربية مع تطبيع ← نتائج صحيحة
- [ ] اختبار: Stream المخزون يُحدَّث تلقائيًا
- [ ] اختبار: الأداء مع 10,000 وصفة و5,000 مكوّن
