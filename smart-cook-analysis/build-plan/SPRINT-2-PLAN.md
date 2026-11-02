# 📋 خطة تنفيذ المرحلة الثانية (Sprint 2 Plan)
## بناء قاعدة البيانات المحلية Drift SQLite ومحرك البيانات

> **المشروع:** تطبيق الطهي الذكي (Smart Cook)  
> **المرحلة:** Sprint 2 — قاعدة البيانات المحلية (Local Storage & Data Engine)  
> **المرجع التقني:** [02-local-database.md](file:///d:/My%20Work/Flutter%20Projects/food%20app/smart-cook-analysis/build-plan/02-local-database.md) و [EXECUTION-PLAN.md](file:///d:/My%20Work/Flutter%20Projects/food%20app/smart-cook-analysis/build-plan/EXECUTION-PLAN.md)  
> **الهدف التشغيلي:** بناء قاعدة بيانات محلية صلبة وفائقة السرعة عبر Drift/SQLite وتوليد الـ DAOs وتغذيتها ببذور البيانات الأولية (50+ وصفة و 150+ مكون) لدعم العمل بنمط Offline-First بالكامل.

---

## 🎯 1. أهداف المرحلة الثانية (Sprint Objectives)

1. **جداول البيانات المتكاملة:** إنشاء الجداول العشرة المترابطة (المكونات، المرادفات، الوصفات، خطوات التحضير، المخزن، المفضلة، قائمة التسوق، جلسات الطهي، التفضيلات، وطابور المزامنة).
2. **فهارس البحث النصي السريع (FTS5):** إنشاء جداول البحث الافتراضية مع دعم تطبيع الحروف العربية والهمزات.
3. **توليد الكود عبر `build_runner`:** إنتاج ملفات `app_database.g.dart` والـ DAOs بدون أي أخطاء.
4. **تضمين بذور البيانات الأولية (Database Seeding):** نقل البيانات الغنية الموجودة في `recipes_data.dart` و `ingredients_data.dart` إلى قاعدة البيانات تلقائياً عند أول تشغيل للتطبيق.
5. **توفير مزودات Riverpod:** ربط قاعدة البيانات والـ DAOs بمزودات Riverpod المعتمدة للحقن عبر الشاشات.
6. **الاختبارات والتأكد من الجودة:** كتابة اختبارات تكاملية شاملة لكافة عمليات الإدخال والقراءة والتحديث والحذف (CRUD) وتدفقات المزامنة.

---

## 🏗️ 2. خارطة الملفات المستهدفة (File Map)

```
lib/data/local/
├── tables/
│   ├── ingredients_table.dart     [جديد] جدول المكونات والأسماء والبدائل
│   ├── recipes_table.dart         [جديد] جدول الوصفات ومكوناتها وخطواتها
│   ├── pantry_table.dart          [جديد] جدول عناصر المخزن والمفضلة وجلسات الطهي
│   ├── shopping_table.dart        [جديد] جدول عناصر قائمة التسوق
│   ├── user_preferences_table.dart[جديد] جدول تفضيلات الحساب والمقاييس
│   └── sync_queue_table.dart      [جديد] جدول طابور المزامنة العكسية
├── daos/
│   ├── ingredient_dao.dart        [جديد] استعلامات وبحث وتصنيف المكونات
│   ├── recipe_dao.dart            [جديد] استعلامات وتصفية ومفضلة الوصفات
│   ├── pantry_dao.dart            [جديد] استعلامات المخزن وحساب النواقص
│   ├── shopping_dao.dart          [جديد] إدارة قائمة التسوق والشطب
│   └── sync_dao.dart              [جديد] إدارة طابور المزامنة وفض النزاعات
├── seeder/
│   └── database_seeder.dart       [جديد] خدمة تعبئة البيانات الأولية العربية
├── app_database.dart              [جديد] الفئة المركزية لقاعدة بيانات Drift
└── database_provider.dart         [جديد] مزودات Riverpod لقاعدة البيانات والـ DAOs
```

---

## 📝 3. تفصيل المهام التنفيذية خطوة بخطوة (Step-by-Step Tasks)

### 🔹 الخطوة 1: تعريف جداول Drift العشرة
**المسار:** `lib/data/local/tables/`  
**الإجراءات:**
1. إنشاء جدول `IngredientsTable` (المكونات الأساسية، التصنيف، الصلاحية، مسببات الحساسية).
2. إنشاء جدول `IngredientNamesTable` (الأسماء باللغات واللهجات المختلفة وتطبيع البحث).
3. إنشاء جدول `IngredientSubstitutesTable` (بدائل المكونات ومعامل الاستبدال).
4. إنشاء جدول `RecipesTable` (تفاصيل الوصفة، الوقت، الصعوبة، السعرات، التصنيفات).
5. إنشاء جدول `RecipeIngredientsTable` (مكونات الوصفة وكمياتها ودورها: أساسي/اختياري).
6. إنشاء جدول `RecipeStepsTable` (خطوات التحضير ومؤقت كل خطوة).
7. إنشاء جداول المستخدم: `PantryItemsTable` (المخزن)، `FavoritesTable` (المفضلة)، `ShoppingItemsTable` (التسوق)، `CookSessionsTable` (جلسات الطهي).
8. إنشاء جدول `SyncQueueTable` و `UserPreferencesTable`.

---

### 🔹 الخطوة 2: تكوين قاعدة البيانات `AppDatabase` والفهارس (FTS5)
**المسار:** `lib/data/local/app_database.dart`  
**الإجراءات:**
1. تعريف `AppDatabase` مع جميع الجداول والـ DAOs.
2. تهيئة الاتصال المحلي باستخدام `LazyDatabase` و `sqlite3_flutter_libs` مع حفظ الملف في مسار التطبيق الآمن `getApplicationDocumentsDirectory()`.
3. تكوين `MigrationStrategy`:
   - استدعاء `m.createAll()`.
   - إنشاء جداول البحث الافتراضية `fts5` للمكونات والوصفات.
   - تهيئة تشغيل Seeder تلقائياً بعد الإنشاء الأولي.

---

### 🔹 الخطوة 3: بناء كائنات الوصول للبيانات (DAOs)
**المسار:** `lib/data/local/daos/`  
**الإجراءات:**
1. `IngredientDao`:
   - `getAllIngredients()`, `searchByName(query)`, `getByCategory(category)`, `getStaples()`.
2. `RecipeDao`:
   - `getAllRecipes()`, `getRecipeById(id)`, `getFavoriteRecipes()`, `toggleFavorite(recipeId)`.
3. `PantryDao`:
   - `watchPantryItems()` (Reactive Stream), `addToPantry()`, `removeFromPantry()`, `updateQuantity()`.
4. `ShoppingDao`:
   - `watchShoppingList()`, `toggleItemChecked()`, `addFromRecipeIngredients()`, `clearChecked()`.
5. `SyncDao`:
   - `enqueueOperation()`, `getPendingSyncItems()`, `markSynced()`.

---

### 🔹 الخطوة 4: تشغيل التوليد بـ `build_runner`
**الإجراءات:**
1. تنفيذ الأمر في بيئة معزولة:
   ```powershell
   $env:TEMP = "D:\temp"; $env:TMP = "D:\temp"; & "C:\flutter\bin\dart.bat" run build_runner build --delete-conflicting-outputs
   ```
2. التأكد من إنشاء `app_database.g.dart` وكافة ملفات الـ DAOs المولدة بدون تحذيرات.

---

### 🔹 الخطوة 5: بناء محرك شحن البيانات الأولية (Database Seeder)
**المسار:** `lib/data/local/seeder/database_seeder.dart`  
**الإجراءات:**
1. استخراج المكونات والوصفات الموجودة حالياً في `recipes_data.dart` و `ingredients_data.dart`.
2. إدراجها بدُفعة واحدة (`batch.insertAllOnConflictUpdate`) عند تشغيل التطبيق للمرة الأولى.
3. التأكد من حفظ حالة `isSeeded` في التفضيلات لعدم تكرار الإدراج.

---

### 🔹 الخطوة 6: مزودات Riverpod واختبارات التكامل (Verification & Tests)
**المسار:** `test/data/drift_database_test.dart`  
**الإجراءات:**
1. إنشاء مزودات Riverpod في `database_provider.dart`:
   - `appDatabaseProvider`, `pantryDaoProvider`, `recipeDaoProvider`, `shoppingDaoProvider`.
2. كتابة اختبارات تكاملية بذاكرة مؤقتة (`NativeDatabase.memory()`):
   - اختبار إدخال واسترجاع مكونات المخزن عبر الـ Stream.
   - اختبار تفعيل وإلغاء المفضلة.
   - اختبار قائمة التسوق ونقل العناصر.
   - اختبار البحث السريع عبر FTS5.
3. تشغيل `flutter test` و `flutter analyze`.

---

## ⏱️ 4. خطة التوقيت وجدول التنفيذ (Timeline)

| المهمة | الوقت المتوقع | المخرجات الرئيسية |
|--------|:------------:|-------------------|
| **الخطوة 1: الجداول الـ 10** | 45 دقيقة | 6 ملفات جداول Drift في `lib/data/local/tables/` |
| **الخطوة 2: AppDatabase** | 30 دقيقة | `app_database.dart` مع `LazyDatabase` و `FTS5` |
| **الخطوة 3: الـ DAOs الخمسة** | 45 دقيقة | 5 ملفات DAO متكاملة |
| **الخطوة 4: التوليد الآلي** | 20 دقيقة | توليد `app_database.g.dart` بدون أخطاء |
| **الخطوة 5: Seeder** | 30 دقيقة | تعبئة البيانات التلقائية بـ 50+ وصفة و 150+ مكون |
| **الخطوة 6: المزودات والاختبارات** | 40 دقيقة | `database_provider.dart` واختبارات شاملة مجتازة |
| **المجموع** | **~3.5 ساعات عمل مركزة** | **قاعدة بيانات محلية متكاملة وجاهزة للربط مع الشاشات** |

---

## ✅ 5. معايير اكتمال المرحلة (Sprint 2 Definition of Done)

- [ ] اكتمال بناء الجداول العشرة وفق متطلبات المخطط.
- [ ] نجاح أمر `dart run build_runner build` وتوليد ملفات الكود بالكامل.
- [ ] شحن قاعدة البيانات بنجاح بجميع الوصفات والمكونات الأساسية.
- [ ] جميع مزودات Riverpod الخاصة بالبيانات المحلية جاهزة ومحقونة.
- [ ] اجتياز كافة الاختبارات التكاملية لعمليات CRUD بنسبة 100%.
- [ ] خلو فحص `flutter analyze` من أي أخطاء أو تحذيرات.
