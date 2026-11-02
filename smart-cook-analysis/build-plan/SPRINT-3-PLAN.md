# 📋 خطة تنفيذ المرحلة الثالثة (Sprint 3 Plan)
## محرك المطابقة والبحث الذكي بـ Isolate (Domain Engine & Arabic Search)

> **المشروع:** تطبيق الطهي الذكي (Smart Cook)  
> **المرحلة:** Sprint 3 — المنطق الأساسي ومحرك المطابقة (Domain Logic & Matching Engine)  
> **المرجع التقني:** [04-core-features.md](file:///d:/My%20Work/Flutter%20Projects/food%20app/smart-cook-analysis/build-plan/04-core-features.md) و [07-matching-and-ai.md](file:///d:/My%20Work/Flutter%20Projects/food%20app/smart-cook-analysis/07-matching-and-ai.md)  
> **الهدف التشغيلي:** بناء العقل الرياضي للتطبيق (خوارزمية المطابقة الموزونة) وتشغيلها في خلفية التطبيق عبر `Isolate` لمنع أي تقطيع بالواجهة (60fps)، مع دعم البحث العربي الذكي والفلاتر المتقدمة.

---

## 🎯 1. أهداف المرحلة الثالثة (Sprint Objectives)

1. **تطبيع النصوص العربية (Arabic Text Normalizer):** بناء محرك معالجة لغوية يزيل التشكيل ويوحد الهمزات ويستخرج المكونات من الجمل الحرة (مثل: "عندي بيض وطماطم وبصل").
2. **نماذج المطابقة والفلاتر (Domain Models):** بناء `RecipeMatch` و `MatchFilters` و `MatchType` (جاهز الآن 100%، ينقص مكون واحد، أفكار إضافية).
3. **خوارزمية المطابقة الموزونة داخل `Isolate`:** مقارنة محتويات المخزن مع متطلبات الوصفات بالاعتماد على أدوار المكونات (`core`, `important`, `optional`, `staple`) وتشغيلها عبر `compute` لضمان استجابة < 200ms.
4. **مستودعات Clean Architecture:** بناء واجهات وعقود `IPantryRepository` و `IRecipeRepository` وربطها بالـ DAOs المحلية في طبقة `data/`.
5. **حالات الاستخدام (UseCases):** كتابة `MatchRecipesUseCase` و `SearchIngredientsUseCase`.
6. **الاختبارات وقياس الأداء (Benchmark Tests):** التحقق الدقيق من حساب النسب الرياضية واختبار سرعة مطابقة آلاف الوصفات.

---

## 🏗️ 2. خارطة الملفات المستهدفة (File Map)

```
lib/
├── core/
│   └── utils/
│       └── arabic_normalizer.dart       [جديد] تطبيع الحروف واستخراج الكلمات
├── domain/
│   ├── models/
│   │   ├── recipe_match.dart            [جديد] نموذج نتيجة المطابقة والنسب
│   │   └── match_filters.dart           [جديد] نموذج فلاتر الوقت والحميات
│   ├── repositories/
│   │   ├── i_pantry_repository.dart     [جديد] عقد مستودع المخزن
│   │   └── i_recipe_repository.dart     [جديد] عقد مستودع الوصفات
│   ├── services/
│   │   └── recipe_matcher.dart          [جديد] خوارزمية المطابقة وعامل Isolate
│   └── usecases/
│       ├── match_recipes_usecase.dart   [جديد] UseCase حساب الوصفات المقترحة
│       └── search_ingredients_usecase.dart [جديد] UseCase البحث والتصفية
├── data/
│   └── repositories/
│       ├── pantry_repository_impl.dart  [جديد] تنفيذ مستودع المخزن عبر Drift
│       └── recipe_repository_impl.dart  [جديد] تنفيذ مستودع الوصفات عبر Drift
└── presentation/
    └── providers/
        └── matching_engine_provider.dart[جديد] مزود Riverpod لمحرك المطابقة
```

---

## 📝 3. تفصيل المهام التنفيذية خطوة بخطوة (Step-by-Step Tasks)

### 🔹 الخطوة 1: بناء محرك تطبيع النصوص العربية (Arabic Normalizer)
**المسار:** `lib/core/utils/arabic_normalizer.dart`  
**الإجراءات:**
1. إزالة كافة علامات التشكيل والتنوين (`\u064B-\u065F\u0670`) والتطويل (`ـ`).
2. توحيد الهمزات: (أ، إ، آ -> ا)، (ؤ -> و)، (ئ -> ي).
3. توحيد التاء المربوطة والهاء (ة -> ه)، والياء المقصورة (ى -> ي).
4. دالة `extractTokens(sentence)`: استخراج أسماء المكونات وتجاهل كلمات التوقف ("عندي", "في", "الثلاجة", "مع").

---

### 🔹 الخطوة 2: نماذج المطابقة والفلاتر (Domain Models)
**المسارات:**
- `lib/domain/models/match_filters.dart`
- `lib/domain/models/recipe_match.dart`

**الإجراءات:**
1. `MatchFilters`:
   - `maxCookingMinutes`, `maxDifficulty`, `selectedCuisines`, `mealTypes`, `allergensToExclude`, `dietFlags`, `assumeStaples: true`, `maxMissing: 3`.
2. `RecipeMatch`:
   - `recipeId`, `recipeTitle`, `heroImageUrl`, `coveragePercent`, `matchedCount`, `totalRequired`, `missingIngredientIds`, `matchType` (`readyNow`, `almostReady`, `idea`).

---

### 🔹 الخطوة 3: بناء خوارزمية المطابقة المعزولة (Recipe Matcher & Isolate Worker)
**المسار:** `lib/domain/services/recipe_matcher.dart`  
**الإجراءات:**
1. بناء مدخلات المعالجة المعزولة `_MatchInput`.
2. الدالة المستقلة `_matchRecipesWorker(_MatchInput input)` المجهزة للعمل داخل Isolate:
   - تصنيف المكونات المطلوبة حسب الأهمية:
     - `core` (أساسي للطبق): نقصه يمنع اعتبار الوصفة جاهزة.
     - `important` (مهم): يدخل في حساب النسبة.
     - `optional` (إضافي/تزيين): لا يؤثر سلباً عند غيابه.
     - `staple` (أساسيات مفترضة): ملح، ماء، زيت.
   - حساب المعادلة الرياضية:
     $$\text{Coverage} = \frac{|\text{Matched Core \& Important}|}{|\text{Total Core \& Important}|} \times 100$$
   - تصنيف النتائج:
     - **جاهزة للطهي (100%):** كل المكونات الأساسية والمهمة متوفرة في المخزن.
     - **ينقصك القليل (70% - 99%):** ينقص مكون أو اثنين كحد أقصى.
     - **أفكار إضافية (< 70%):** وصفات ملهمة ذات صلة.
3. تشغيل الحساب عبر `compute(_matchRecipesWorker, input)` لضمان بقاء الواجهة عند 60fps.

---

### 🔹 الخطوة 4: بناء المستودعات وربط طبقة البيانات (Repositories Implementation)
**المسارات:**
- `lib/domain/repositories/i_pantry_repository.dart`
- `lib/domain/repositories/i_recipe_repository.dart`
- `lib/data/repositories/pantry_repository_impl.dart`
- `lib/data/repositories/recipe_repository_impl.dart`

**الإجراءات:**
1. ربط `PantryRepositoryImpl` بـ `PantryDao` و `IngredientDao` لقراءة المخزن وتحديثه.
2. ربط `RecipeRepositoryImpl` بـ `RecipeDao` لتحميل الوصفات ومكوناتها وتطبيق الفلاتر الأساسية.

---

### 🔹 الخطوة 5: بناء UseCases ومزود Riverpod
**المسارات:**
- `lib/domain/usecases/match_recipes_usecase.dart`
- `lib/presentation/providers/matching_engine_provider.dart`

**الإجراءات:**
1. `MatchRecipesUseCase`: يجمع مكونات المخزن الحية، ويضيف الأساسيات، ويستدعي `RecipeMatcher.match()`.
2. `matchingEngineProvider`: مزود Riverpod يستمع لتغيرات مخزن المستخدم (`pantryItemsStreamProvider`) ويعيد حساب المطابقة فوراً في الخلفية.

---

### 🔹 الخطوة 6: الاختبارات وقياس الأداء (Benchmark & Verification)
**المسار:** `test/domain/recipe_matcher_test.dart`  
**الإجراءات:**
1. اختبارات دقة الحساب:
   - التأكد من أن وجود البيض والطماطم ينتج مطابقة 100% لـ "الشكشوكة".
   - التأكد من حساب المكون الناقص بدقة عند غياب البصل.
2. اختبار الفلاتر:
   - التحقق من استبعاد الوصفات المحتوية على مسببات حساسية أو غير المتوافقة مع الحميات.
3. اختبار السرعة (Performance Benchmark):
   - توليد 1000 وصفة ومطابقتها مع مخزن يحتوي 20 مكوناً والتأكد من إنجازها في < 150ms.
4. تشغيل `flutter test` و `flutter analyze`.

---

## ⏱️ 4. جدول التنفيذ الزمني (Timeline)

| المهمة | الوقت المتوقع | المخرجات الرئيسية |
|--------|:------------:|-------------------|
| **الخطوة 1: Arabic Normalizer** | 30 دقيقة | `arabic_normalizer.dart` ودوال التطهير |
| **الخطوة 2: نماذج المطابقة** | 30 دقيقة | `recipe_match.dart`, `match_filters.dart` |
| **الخطوة 3: RecipeMatcher بـ Isolate** | 60 دقيقة | `recipe_matcher.dart` مع دالة `compute` |
| **الخطوة 4: المستودعات والربط** | 45 دقيقة | Repositories لطبقتي Domain و Data |
| **الخطوة 5: UseCase والمزود** | 45 دقيقة | `match_recipes_usecase.dart`, `matching_engine_provider.dart` |
| **الخطوة 6: الاختبارات وقياس السرعة** | 45 دقيقة | `recipe_matcher_test.dart` بنجاح كامل |
| **المجموع** | **~4.2 ساعات عمل مركزة** | **محرك مطابقة ذكي وخارق السرعة يعمل دون إنترنت** |

---

## ✅ 5. معايير اكتمال المرحلة (Sprint 3 Definition of Done)

- [ ] خوارزمية المطابقة تعمل بدقة وتصنف الوصفات (100%، ينقص قليل، أفكار).
- [ ] العمليات الثقيلة تُعالج داخل Dart `Isolate` دون أي تجميد للواجهة.
- [ ] دعم كامل للفلاتر (الوقت، الصعوبة، الحميات، الحساسية، والأساسيات).
- [ ] تطبيع النصوص العربية يعمل بدقة مع كافة الهمزات والتشكيل.
- [ ] اجتياز كافة اختبارات المطابقة واختبارات قياس السرعة (`< 200ms`).
- [ ] خلو فحص `flutter analyze` من أي أخطاء أو تحذيرات.
