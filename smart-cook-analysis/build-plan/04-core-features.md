# 04 — الميزات الأساسية: المخزون والمطابقة والفلاتر والبحث

> **المدة المُقدَّرة:** 7–10 أيام
> **يعتمد على:** الملفات 01 + 02 + 03
> **الأولوية:** 🔴 عالية — القلب النابض للتطبيق

---

## 1. نظرة عامة على الميزات

```
إدخال المكونات → المخزون المحلي → خوارزمية المطابقة → قائمة الاقتراحات
      ↑                                    ↓
  بحث + صوت                          فلاتر + ترتيب
```

---

## 2. شاشة المخزون (Pantry) — الترقية

### 2.1 الحالة الحالية
- الشاشة موجودة: `pantry_screen.dart` (21,814 bytes)
- المزوّد موجود: `pantry_provider.dart` (1,672 bytes)
- البيانات: تجريبية (Mock)

### 2.2 الترقية المطلوبة

#### Provider جديد (Riverpod + Drift)

```dart
// presentation/providers/pantry_provider.dart

@riverpod
class PantryNotifier extends _$PantryNotifier {
  @override
  Stream<List<PantryItemWithIngredient>> build() {
    final dao = ref.watch(pantryDaoProvider);
    return dao.watchPantryItems();
  }

  Future<void> addIngredient(String ingredientId, {
    double? quantity,
    String? unit,
    String? location,
    DateTime? expiresOn,
    String source = 'manual',
  }) async {
    final dao = ref.read(pantryDaoProvider);
    await dao.addItem(PantryItemsCompanion(
      id: Value(const Uuid().v4()),
      ingredientId: Value(ingredientId),
      quantity: Value(quantity),
      unit: Value(unit),
      location: Value(location),
      expiresOn: Value(expiresOn),
      source: Value(source),
      addedAt: Value(DateTime.now()),
    ));

    // إضافة لطابور المزامنة
    await ref.read(syncServiceProvider).queueOperation(
      table: 'pantry_items',
      operation: 'insert',
      recordId: ingredientId,
    );
  }

  Future<void> removeIngredient(String itemId) async {
    final dao = ref.read(pantryDaoProvider);
    await dao.removeItem(itemId);
  }

  Future<void> addMultiple(List<String> ingredientIds) async {
    for (final id in ingredientIds) {
      await addIngredient(id);
    }
  }
}
```

#### UseCase: إضافة مكونات

```dart
// domain/usecases/add_to_pantry.dart

class AddToPantryUseCase {
  final IPantryRepository _repository;
  final IIngredientRepository _ingredientRepo;

  AddToPantryUseCase(this._repository, this._ingredientRepo);

  /// يضيف مكوّنًا للمخزون بعد التحقق
  Future<Result<void>> execute({
    required String ingredientId,
    double? quantity,
    String? unit,
  }) async {
    // التحقق من وجود المكوّن في القاموس
    final ingredient = await _ingredientRepo.getById(ingredientId);
    if (ingredient == null) {
      return Result.failure('مكوّن غير معروف');
    }

    // التحقق من عدم التكرار
    final exists = await _repository.hasIngredient(ingredientId);
    if (exists) {
      return Result.failure('المكوّن موجود بالفعل');
    }

    await _repository.add(PantryItem(
      id: const Uuid().v4(),
      ingredientId: ingredientId,
      quantity: quantity,
      unit: unit ?? ingredient.defaultUnit,
      addedAt: DateTime.now(),
    ));

    return Result.success(null);
  }
}
```

---

## 3. البحث الذكي عن المكونات

### 3.1 مكوّنات البحث

```
1. بحث نصي فوري (Autocomplete)
2. دعم المرادفات واللهجات
3. تصنيفات سريعة (شبكة)
4. الأساسيات المفترضة
```

### 3.2 Provider البحث

```dart
// presentation/providers/ingredient_search_provider.dart

@riverpod
class IngredientSearch extends _$IngredientSearch {
  Timer? _debounce;

  @override
  AsyncValue<List<IngredientSearchResult>> build() {
    return const AsyncData([]);
  }

  void search(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      if (query.isEmpty) {
        state = const AsyncData([]);
        return;
      }

      state = const AsyncLoading();
      try {
        final dao = ref.read(ingredientDaoProvider);
        final results = await dao.searchByName(query);
        
        // فلترة: استبعاد المكونات الموجودة في المخزون
        final pantryIds = await ref.read(pantryDaoProvider).getPantryIngredientIds();
        final filtered = results.where((r) => !pantryIds.contains(r.ingredientId)).toList();
        
        state = AsyncData(filtered);
      } catch (e) {
        state = AsyncError(e, StackTrace.current);
      }
    });
  }
}
```

### 3.3 تطبيع النص العربي (تحسين الموجود)

```dart
// core/utils/text_normalizer.dart — ترقية

class ArabicNormalizer {
  static final _diacritics = RegExp(r'[\u064B-\u065F\u0670]');
  static final _tatweel = RegExp(r'\u0640');

  static String normalize(String text) {
    return text
        .replaceAll(_diacritics, '')    // إزالة التشكيل
        .replaceAll(_tatweel, '')       // إزالة التطويل
        .replaceAll('إ', 'ا')           // توحيد الهمزات
        .replaceAll('أ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ى', 'ي')           // توحيد الياء
        .replaceAll('ة', 'ه')           // توحيد التاء المربوطة
        .replaceAll('ؤ', 'و')
        .replaceAll('ئ', 'ي')
        .trim()
        .toLowerCase();
  }

  /// استخراج أسماء المكونات من جملة حرة
  /// مثال: "عندي بيض وجبنة وطماطم" → ['بيض', 'جبنة', 'طماطم']
  static List<String> extractIngredientNames(String sentence) {
    // إزالة كلمات التوقف
    final stopWords = {'عندي', 'عندنا', 'في', 'الثلاجة', 'يوجد', 'لدي', 'و', 'مع'};
    
    final words = sentence
        .split(RegExp(r'[\s,،.]+'))
        .map((w) => w.trim())
        .where((w) => w.isNotEmpty && !stopWords.contains(normalize(w)))
        .toList();

    return words;
  }
}
```

---

## 4. خوارزمية المطابقة ⭐

> **هذا هو أهم جزء في التطبيق** — يجب أن تكون سريعة ودقيقة.

### 4.1 المبدأ

```
مكونات المستخدم (المخزون) + الأساسيات
        ↓
مقارنة مع مكونات كل وصفة
        ↓
حساب نسبة التغطية + تحديد الناقص
        ↓
ترتيب النتائج + تطبيق الفلاتر
```

### 4.2 UseCase المطابقة

```dart
// domain/usecases/match_recipes.dart

class MatchRecipesUseCase {
  final IRecipeRepository _recipeRepo;
  final IPantryRepository _pantryRepo;
  final IIngredientRepository _ingredientRepo;

  MatchRecipesUseCase(this._recipeRepo, this._pantryRepo, this._ingredientRepo);

  Future<List<RecipeMatch>> execute(MatchFilters filters) async {
    // 1. جلب مكونات المستخدم
    final userIngredientIds = await _pantryRepo.getIngredientIds();

    // 2. إضافة الأساسيات المفترضة
    if (filters.assumeStaples) {
      final staples = await _ingredientRepo.getStapleIds();
      userIngredientIds.addAll(staples);
    }

    // 3. جلب خريطة الوصفات → مكوناتها
    final recipesWithIngredients = await _recipeRepo.getAllWithIngredients(
      cuisine: filters.cuisine,
      maxMinutes: filters.maxMinutes,
      maxDifficulty: filters.maxDifficulty,
      mealTypes: filters.mealTypes,
      excludeAllergens: filters.allergens,
      excludeDiets: filters.excludeDiets,
    );

    // 4. المطابقة (في Isolate لعدم حجب UI)
    final matches = await compute(
      _matchInIsolate,
      _MatchInput(
        recipes: recipesWithIngredients,
        userIngredients: userIngredientIds,
        maxMissing: filters.maxMissing,
      ),
    );

    // 5. ترتيب
    matches.sort((a, b) {
      // أولوية: التغطية الأعلى
      final coverageCompare = b.coveragePercent.compareTo(a.coveragePercent);
      if (coverageCompare != 0) return coverageCompare;
      // ثم: الأقل وقتًا
      return (a.recipe.totalMinutes ?? 999)
          .compareTo(b.recipe.totalMinutes ?? 999);
    });

    return matches;
  }
}

// دالة المطابقة (تعمل في Isolate)
List<RecipeMatch> _matchInIsolate(_MatchInput input) {
  final results = <RecipeMatch>[];

  for (final recipe in input.recipes) {
    // تصنيف المكونات حسب الدور
    final coreIngredients = recipe.ingredients
        .where((i) => i.role == 'core')
        .map((i) => i.ingredientId)
        .toSet();

    final importantIngredients = recipe.ingredients
        .where((i) => i.role == 'important')
        .map((i) => i.ingredientId)
        .toSet();

    final optionalIngredients = recipe.ingredients
        .where((i) => i.role == 'optional')
        .map((i) => i.ingredientId)
        .toSet();

    // حساب التغطية
    final requiredIngredients = {...coreIngredients, ...importantIngredients};

    final matchedRequired = requiredIngredients
        .intersection(input.userIngredients);
    final missingRequired = requiredIngredients
        .difference(input.userIngredients);

    final matchedOptional = optionalIngredients
        .intersection(input.userIngredients);

    // نسبة التغطية (core و important فقط)
    final coveragePercent = requiredIngredients.isEmpty
        ? 100.0
        : (matchedRequired.length / requiredIngredients.length) * 100;

    // فلترة: لا نعرض وصفات بتغطية أقل من العتبة
    final missingCount = missingRequired.length;
    if (missingCount > input.maxMissing) continue;

    // لا نعرض وصفات ينقصها مكوّن core
    final missingCore = coreIngredients.difference(input.userIngredients);
    if (missingCore.isNotEmpty && input.maxMissing < coreIngredients.length) {
      continue;
    }

    results.add(RecipeMatch(
      recipe: recipe.recipe,
      coveragePercent: coveragePercent,
      matchedCount: matchedRequired.length + matchedOptional.length,
      totalRequired: requiredIngredients.length,
      missingIngredientIds: missingRequired.toList(),
      matchType: missingRequired.isEmpty
          ? MatchType.readyNow      // جاهز الآن
          : MatchType.almostReady,   // ينقصك قليل
    ));
  }

  return results;
}
```

### 4.3 نموذج النتيجة

```dart
// domain/models/recipe_match.dart

@freezed
class RecipeMatch with _$RecipeMatch {
  const factory RecipeMatch({
    required Recipe recipe,
    required double coveragePercent,
    required int matchedCount,
    required int totalRequired,
    required List<String> missingIngredientIds,
    required MatchType matchType,
  }) = _RecipeMatch;
}

enum MatchType {
  readyNow,        // 100% تغطية
  almostReady,     // ينقصك 1-2
}
```

### 4.4 Provider الاقتراحات

```dart
// presentation/providers/matching_provider.dart — ترقية

@riverpod
class SuggestionsNotifier extends _$SuggestionsNotifier {
  @override
  Future<SuggestionsState> build() async {
    // يُعاد حسابه كلما تغيّر المخزون
    final pantryItems = await ref.watch(pantryNotifierProvider.future);
    
    if (pantryItems.isEmpty) {
      return SuggestionsState.empty();
    }

    final matcher = ref.read(matchRecipesUseCaseProvider);
    final filters = ref.watch(filtersProvider);

    final matches = await matcher.execute(filters);

    return SuggestionsState(
      readyNow: matches.where((m) => m.matchType == MatchType.readyNow).toList(),
      almostReady: matches.where((m) => m.matchType == MatchType.almostReady).toList(),
      totalMatches: matches.length,
    );
  }
}

@freezed
class SuggestionsState with _$SuggestionsState {
  const factory SuggestionsState({
    @Default([]) List<RecipeMatch> readyNow,
    @Default([]) List<RecipeMatch> almostReady,
    @Default(0) int totalMatches,
  }) = _SuggestionsState;

  factory SuggestionsState.empty() => const SuggestionsState();
}
```

---

## 5. الفلاتر

### 5.1 نموذج الفلاتر

```dart
// domain/models/match_filters.dart

@freezed
class MatchFilters with _$MatchFilters {
  const factory MatchFilters({
    @Default(true) bool assumeStaples,
    @Default(2) int maxMissing,           // أقصى عدد مكونات ناقصة
    String? cuisine,                       // gulf, levant, egypt...
    int? maxMinutes,                       // أقصى وقت
    int? maxDifficulty,                    // 1-3
    @Default([]) List<String> mealTypes,   // breakfast, lunch, dinner
    @Default([]) List<String> allergens,   // nuts, gluten, dairy
    @Default([]) List<String> excludeDiets,
    @Default([]) List<String> equipment,   // oven, blender
    int? servings,
  }) = _MatchFilters;
}
```

### 5.2 Provider الفلاتر

```dart
// presentation/providers/filters_provider.dart

@riverpod
class FiltersNotifier extends _$FiltersNotifier {
  @override
  MatchFilters build() {
    // تحميل تفضيلات المستخدم كفلاتر افتراضية
    final prefs = ref.watch(userPreferencesProvider);
    return MatchFilters(
      allergens: prefs.allergens,
      excludeDiets: prefs.diets,
      assumeStaples: prefs.assumeStaples,
    );
  }

  void updateCuisine(String? cuisine) {
    state = state.copyWith(cuisine: cuisine);
  }

  void updateMaxMinutes(int? minutes) {
    state = state.copyWith(maxMinutes: minutes);
  }

  void updateDifficulty(int? difficulty) {
    state = state.copyWith(maxDifficulty: difficulty);
  }

  void updateMealTypes(List<String> types) {
    state = state.copyWith(mealTypes: types);
  }

  void updateMaxMissing(int max) {
    state = state.copyWith(maxMissing: max);
  }

  void reset() {
    state = const MatchFilters();
  }
}
```

---

## 6. الإدخال الصوتي

### 6.1 تدفق الإدخال

```
المستخدم يضغط الميكروفون
    ↓
speech_to_text يحوّل الكلام لنص
    ↓
ArabicNormalizer.extractIngredientNames()
    ↓
مطابقة الأسماء مع القاموس (Fuzzy match)
    ↓
عرض شرائح تأكيد (قابلة للحذف)
    ↓
إضافة المؤكد للمخزون
```

### 6.2 مطابقة ضبابية

```dart
// domain/usecases/extract_voice_ingredients.dart

class ExtractVoiceIngredientsUseCase {
  final IIngredientRepository _ingredientRepo;

  ExtractVoiceIngredientsUseCase(this._ingredientRepo);

  Future<List<IngredientSuggestion>> execute(String spokenText) async {
    // 1. استخراج الأسماء المحتملة
    final names = ArabicNormalizer.extractIngredientNames(spokenText);

    // 2. مطابقة كل اسم مع القاموس
    final suggestions = <IngredientSuggestion>[];
    for (final name in names) {
      final matches = await _ingredientRepo.fuzzySearch(
        name,
        limit: 3,
        threshold: 0.5,
      );

      if (matches.isNotEmpty) {
        suggestions.add(IngredientSuggestion(
          spokenName: name,
          bestMatch: matches.first,
          alternatives: matches.skip(1).toList(),
          confidence: matches.first.score,
        ));
      }
    }

    return suggestions;
  }
}
```

---

## 7. أداء المطابقة

### 7.1 استراتيجية الأداء

| التقنية | الهدف |
|---------|-------|
| Isolate (compute) | عدم حجب UI thread |
| فهرس معكوس (ingredient → recipes) | O(1) للبحث |
| Bitset للمقارنة | سرعة عالية لمجموعات كبيرة |
| تخزين مؤقت (Cache) | عدم إعادة الحساب لنفس المدخلات |
| Pagination | عرض أول 20 نتيجة فورًا |

### 7.2 فهرس معكوس

```dart
// data/local/inverted_index.dart

class InvertedIndex {
  // ingredient_id → Set<recipe_id>
  final Map<String, Set<String>> _index = {};

  Future<void> build(RecipeDao dao) async {
    final allRecipeIngredients = await dao.getAllRecipeIngredients();
    for (final ri in allRecipeIngredients) {
      _index.putIfAbsent(ri.ingredientId, () => {}).add(ri.recipeId);
    }
  }

  /// الوصفات التي تحتوي على أيٍّ من المكونات
  Set<String> getCandidateRecipes(Set<String> ingredientIds) {
    final candidates = <String>{};
    for (final id in ingredientIds) {
      candidates.addAll(_index[id] ?? {});
    }
    return candidates;
  }
}
```

### 7.3 معايير الأداء

```
الهدف: < 300ms لمطابقة 10,000 وصفة على جهاز متوسط
القياس: DevTools Performance → Timeline
```

---

## 8. قائمة تحقق المرحلة

- [ ] ترقية `pantry_provider.dart` ليستخدم Drift
- [ ] إنشاء `MatchRecipesUseCase` مع Isolate
- [ ] إنشاء نموذج `MatchFilters` (freezed)
- [ ] إنشاء `FiltersNotifier`
- [ ] ترقية `SuggestionsNotifier` ليستخدم المطابقة الحقيقية
- [ ] تحسين `ArabicNormalizer` بالمرادفات
- [ ] إنشاء `ExtractVoiceIngredientsUseCase`
- [ ] بناء الفهرس المعكوس
- [ ] ربط الشاشات الموجودة بالـ Providers الجديدة
- [ ] اختبار: إضافة 5 مكونات → عرض وصفات مطابقة
- [ ] اختبار: تغيير فلتر → تحديث النتائج فورًا
- [ ] اختبار: بحث صوتي → استخراج مكونات صحيحة
- [ ] اختبار أداء: < 300ms لـ 10,000 وصفة
- [ ] اختبار: المطابقة تعمل Offline
