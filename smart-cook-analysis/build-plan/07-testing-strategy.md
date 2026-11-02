# 07 — استراتيجية الاختبار

> **المدة المُقدَّرة:** 5–7 أيام (بالتوازي مع التطوير)
> **الأولوية:** 🟠 متوسطة-عالية — ضرورية لجودة المنتج

---

## 1. هرم الاختبار

```
         /\
        /  \         اختبارات التكامل (E2E)
       / 10% \       ← أبطأ، أغلى
      /--------\
     /    20%   \    اختبارات الويدجت
    /            \   ← متوسطة
   /--------------\
  /      70%       \ اختبارات الوحدة
 /                  \← أسرع، أرخص
/____________________\
```

---

## 2. اختبارات الوحدة (Unit Tests)

### 2.1 ما يُختبر

| المكوّن | الأولوية | التغطية المطلوبة |
|---------|:--------:|:----------------:|
| خوارزمية المطابقة | 🔴 | ≥ 95% |
| تطبيع النص العربي | 🔴 | ≥ 95% |
| استخراج المكونات الصوتية | 🔴 | ≥ 90% |
| تحويل المقادير | 🟠 | ≥ 85% |
| حل التعارضات (المزامنة) | 🟠 | ≥ 90% |
| النماذج (freezed) | 🟡 | ≥ 80% |
| Providers (المنطق) | 🟠 | ≥ 80% |

### 2.2 مثال: اختبار خوارزمية المطابقة

```dart
// test/domain/usecases/match_recipes_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRecipeRepository extends Mock implements IRecipeRepository {}
class MockPantryRepository extends Mock implements IPantryRepository {}
class MockIngredientRepository extends Mock implements IIngredientRepository {}

void main() {
  late MatchRecipesUseCase useCase;
  late MockRecipeRepository recipeRepo;
  late MockPantryRepository pantryRepo;
  late MockIngredientRepository ingredientRepo;

  setUp(() {
    recipeRepo = MockRecipeRepository();
    pantryRepo = MockPantryRepository();
    ingredientRepo = MockIngredientRepository();
    useCase = MatchRecipesUseCase(recipeRepo, pantryRepo, ingredientRepo);
  });

  group('المطابقة الأساسية', () {
    test('وصفة جاهزة الآن عندما كل المكونات الأساسية موجودة', () async {
      // Arrange
      when(() => pantryRepo.getIngredientIds())
          .thenAnswer((_) async => {'chicken', 'rice', 'onion', 'tomato'});
      when(() => ingredientRepo.getStapleIds())
          .thenAnswer((_) async => {'salt', 'oil', 'water'});
      when(() => recipeRepo.getAllWithIngredients())
          .thenAnswer((_) async => [
            RecipeWithIngredients(
              recipe: _makeRecipe('kabsa'),
              ingredients: [
                _makeRI('chicken', 'core'),
                _makeRI('rice', 'core'),
                _makeRI('onion', 'important'),
                _makeRI('tomato', 'important'),
                _makeRI('salt', 'staple'),
              ],
            ),
          ]);

      // Act
      final results = await useCase.execute(const MatchFilters());

      // Assert
      expect(results, hasLength(1));
      expect(results.first.matchType, MatchType.readyNow);
      expect(results.first.coveragePercent, 100.0);
      expect(results.first.missingIngredientIds, isEmpty);
    });

    test('وصفة "ينقصك 1" عندما يغيب مكوّن واحد', () async {
      when(() => pantryRepo.getIngredientIds())
          .thenAnswer((_) async => {'chicken', 'rice', 'onion'});
      when(() => ingredientRepo.getStapleIds())
          .thenAnswer((_) async => {'salt', 'oil'});
      when(() => recipeRepo.getAllWithIngredients())
          .thenAnswer((_) async => [
            RecipeWithIngredients(
              recipe: _makeRecipe('kabsa'),
              ingredients: [
                _makeRI('chicken', 'core'),
                _makeRI('rice', 'core'),
                _makeRI('onion', 'important'),
                _makeRI('tomato', 'important'),
                _makeRI('salt', 'staple'),
              ],
            ),
          ]);

      final results = await useCase.execute(const MatchFilters());

      expect(results, hasLength(1));
      expect(results.first.matchType, MatchType.almostReady);
      expect(results.first.missingIngredientIds, ['tomato']);
    });

    test('لا تُعرض وصفة ينقصها مكوّن core', () async {
      when(() => pantryRepo.getIngredientIds())
          .thenAnswer((_) async => {'rice', 'onion', 'tomato'});
      when(() => ingredientRepo.getStapleIds())
          .thenAnswer((_) async => {'salt'});
      when(() => recipeRepo.getAllWithIngredients())
          .thenAnswer((_) async => [
            RecipeWithIngredients(
              recipe: _makeRecipe('kabsa'),
              ingredients: [
                _makeRI('chicken', 'core'),  // ← ناقص!
                _makeRI('rice', 'core'),
                _makeRI('onion', 'important'),
              ],
            ),
          ]);

      final results = await useCase.execute(
        const MatchFilters(maxMissing: 1),
      );

      // لا نعرض وصفة ينقصها core مع maxMissing=1
      expect(results, isEmpty);
    });

    test('الأساسيات المفترضة تُستبعد من الناقص', () async {
      when(() => pantryRepo.getIngredientIds())
          .thenAnswer((_) async => {'eggs', 'cheese'});
      when(() => ingredientRepo.getStapleIds())
          .thenAnswer((_) async => {'salt', 'oil'});
      when(() => recipeRepo.getAllWithIngredients())
          .thenAnswer((_) async => [
            RecipeWithIngredients(
              recipe: _makeRecipe('omelette'),
              ingredients: [
                _makeRI('eggs', 'core'),
                _makeRI('cheese', 'important'),
                _makeRI('salt', 'staple'),
                _makeRI('oil', 'staple'),
              ],
            ),
          ]);

      final results = await useCase.execute(
        const MatchFilters(assumeStaples: true),
      );

      expect(results.first.coveragePercent, 100.0);
    });
  });

  group('الفلاتر', () {
    test('فلتر الحساسية يستبعد الوصفات', () async {
      // وصفة تحتوي nuts ← مستخدم حساس من المكسرات
      // ← لا تظهر
    });

    test('فلتر الوقت يعمل', () async {
      // maxMinutes: 30 ← وصفة 45 دقيقة لا تظهر
    });

    test('فلتر المطبخ يعمل', () async {
      // cuisine: 'gulf' ← فقط وصفات خليجية
    });
  });

  group('الترتيب', () {
    test('التغطية الأعلى أولًا', () async {
      // وصفة 100% قبل وصفة 80%
    });

    test('عند تساوي التغطية، الأقل وقتًا أولًا', () async {
      // 100% + 30 دقيقة قبل 100% + 60 دقيقة
    });
  });
}
```

### 2.3 مثال: اختبار تطبيع النص العربي

```dart
// test/core/utils/text_normalizer_test.dart

void main() {
  group('ArabicNormalizer.normalize', () {
    test('يزيل التشكيل', () {
      expect(ArabicNormalizer.normalize('طَمَاطِم'), 'طماطم');
    });

    test('يوحّد الهمزات', () {
      expect(ArabicNormalizer.normalize('إبراهيم'), 'ابراهيم');
      expect(ArabicNormalizer.normalize('أحمد'), 'احمد');
    });

    test('يوحّد التاء المربوطة', () {
      expect(ArabicNormalizer.normalize('طماطة'), 'طماطه');
    });

    test('يوحّد الياء', () {
      expect(ArabicNormalizer.normalize('بطاطى'), 'بطاطي');
    });
  });

  group('ArabicNormalizer.extractIngredientNames', () {
    test('يستخرج من جملة بسيطة', () {
      final result = ArabicNormalizer.extractIngredientNames(
        'عندي بيض وجبنة وطماطم',
      );
      expect(result, ['بيض', 'جبنة', 'طماطم']);
    });

    test('يتعامل مع الفواصل', () {
      final result = ArabicNormalizer.extractIngredientNames(
        'بيض، جبنة، طماطم',
      );
      expect(result, ['بيض', 'جبنة', 'طماطم']);
    });

    test('يزيل كلمات التوقف', () {
      final result = ArabicNormalizer.extractIngredientNames(
        'في الثلاجة يوجد دجاج مع بصل',
      );
      expect(result, ['دجاج', 'بصل']);
    });
  });
}
```

---

## 3. اختبارات الويدجت (Widget Tests)

### 3.1 ما يُختبر

| الويدجت | ما يُختبر |
|---------|----------|
| `RecipeCard` | العرض الصحيح، RTL، الضغط |
| `IngredientChip` | الحالات (عادي، محدد، محذوف) |
| `FiltersBottomSheet` | الفلاتر تُطبَّق |
| `VoiceInputSheet` | حالات الميكروفون |
| `AuthModal` | الأزرار تظهر |

### 3.2 مثال: اختبار بطاقة الوصفة

```dart
// test/presentation/widgets/recipe_card_test.dart

void main() {
  testWidgets('RecipeCard يعرض العنوان والوقت والصعوبة', (tester) async {
    final recipe = Recipe(
      id: '1',
      slug: 'test',
      title: {'ar': 'كبسة الدجاج'},
      totalMinutes: 60,
      difficulty: 2,
      heroImageUrl: null,
    );

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ar'),
        home: Scaffold(
          body: RecipeCard(
            recipe: recipe,
            onTap: () {},
          ),
        ),
      ),
    );

    expect(find.text('كبسة الدجاج'), findsOneWidget);
    expect(find.text('60 دقيقة'), findsOneWidget);
  });

  testWidgets('RecipeCard يعمل RTL', (tester) async {
    // ... التحقق من محاذاة RTL
  });
}
```

### 3.3 اختبارات Golden (لقطات مرجعية)

```dart
// test/golden/screens_golden_test.dart

void main() {
  testWidgets('PantryScreen golden (عربي)', (tester) async {
    await tester.pumpWidget(/* ... */);
    await expectLater(
      find.byType(PantryScreen),
      matchesGoldenFile('goldens/pantry_screen_ar.png'),
    );
  });

  testWidgets('PantryScreen golden (إنجليزي)', (tester) async {
    // ... نفس الشيء بالإنجليزية
  });
}
```

---

## 4. اختبارات التكامل (Integration Tests)

### 4.1 المسارات الأساسية

```dart
// integration_test/core_flow_test.dart

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('المسار الأساسي: إضافة مكونات → اقتراحات → طهي', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // 1. تخطي الترحيب (إن وُجد)
    if (find.text('ابدأ').evaluate().isNotEmpty) {
      await tester.tap(find.text('ابدأ'));
      await tester.pumpAndSettle();
    }

    // 2. الانتقال للمخزون
    await tester.tap(find.byIcon(Icons.kitchen));
    await tester.pumpAndSettle();

    // 3. إضافة مكونات
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // البحث عن «دجاج»
    await tester.enterText(find.byType(TextField), 'دجاج');
    await tester.pumpAndSettle();

    // اختيار النتيجة الأولى
    await tester.tap(find.text('دجاج').first);
    await tester.pumpAndSettle();

    // 4. الانتقال لـ «اليوم» للاقتراحات
    await tester.tap(find.byIcon(Icons.today));
    await tester.pumpAndSettle();

    // التحقق من وجود اقتراحات
    expect(find.byType(RecipeCard), findsWidgets);

    // 5. فتح وصفة
    await tester.tap(find.byType(RecipeCard).first);
    await tester.pumpAndSettle();

    // 6. بدء الطهي
    await tester.tap(find.text('ابدأ الطهي'));
    await tester.pumpAndSettle();

    // التحقق من وضع الطهي
    expect(find.text('الخطوة 1'), findsOneWidget);
  });
}
```

---

## 5. اختبارات البيانات

### 5.1 سلامة الوصفات

```dart
// test/data/recipe_integrity_test.dart

void main() {
  test('كل وصفة لها مكوّن core واحد على الأقل', () {
    for (final recipe in allRecipes) {
      final coreIngredients = recipe.ingredients
          .where((i) => i.role == 'core');
      expect(coreIngredients, isNotEmpty,
          reason: 'وصفة ${recipe.title} ليس لها مكوّن core');
    }
  });

  test('كل مكوّن في الوصفات موجود في القاموس', () {
    final knownIds = allIngredients.map((i) => i.id).toSet();
    for (final recipe in allRecipes) {
      for (final ri in recipe.ingredients) {
        expect(knownIds, contains(ri.ingredientId),
            reason: 'مكوّن ${ri.ingredientId} غير موجود في القاموس');
      }
    }
  });

  test('كل وصفة لها خطوات', () {
    for (final recipe in allRecipes) {
      expect(recipe.steps, isNotEmpty,
          reason: 'وصفة ${recipe.title} بدون خطوات');
    }
  });

  test('الحساسية محسوبة صحيحًا', () {
    for (final recipe in allRecipes) {
      final computedAllergens = recipe.ingredients
          .expand((i) => allIngredients
              .firstWhere((ing) => ing.id == i.ingredientId)
              .allergens)
          .toSet();
      expect(Set.from(recipe.allergens), computedAllergens);
    }
  });
}
```

---

## 6. اختبارات الأداء

```dart
// test/performance/matching_performance_test.dart

void main() {
  test('المطابقة < 300ms لـ 10,000 وصفة', () async {
    // توليد 10,000 وصفة وهمية
    final recipes = List.generate(10000, (i) => _makeRandomRecipe(i));
    final userIngredients = _makeRandomIngredientSet(20);

    final stopwatch = Stopwatch()..start();
    final results = matchRecipes(recipes, userIngredients);
    stopwatch.stop();

    expect(stopwatch.elapsedMilliseconds, lessThan(300));
    debugPrint('المطابقة: ${stopwatch.elapsedMilliseconds}ms '
        'لـ ${recipes.length} وصفة → ${results.length} نتيجة');
  });
}
```

---

## 7. هيكل مجلد الاختبارات

```
test/
├─ core/
│  └─ utils/
│     └─ text_normalizer_test.dart
├─ domain/
│  └─ usecases/
│     ├─ match_recipes_test.dart
│     ├─ add_to_pantry_test.dart
│     └─ extract_voice_ingredients_test.dart
├─ data/
│  ├─ recipe_integrity_test.dart
│  └─ repositories/
│     └─ recipe_repository_test.dart
├─ presentation/
│  ├─ providers/
│  │  └─ matching_provider_test.dart
│  └─ widgets/
│     ├─ recipe_card_test.dart
│     └─ ingredient_chip_test.dart
├─ golden/
│  └─ screens_golden_test.dart
└─ performance/
   └─ matching_performance_test.dart

integration_test/
├─ core_flow_test.dart
├─ auth_flow_test.dart
└─ offline_test.dart
```

---

## 8. أوامر التشغيل

```powershell
# اختبارات الوحدة
flutter test

# اختبار ملف محدد
flutter test test/domain/usecases/match_recipes_test.dart

# التغطية
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html

# اختبارات الويدجت
flutter test test/presentation/

# تحديث لقطات Golden
flutter test --update-goldens

# اختبارات التكامل
flutter test integration_test/ -d <device_id>
```

---

## 9. قائمة تحقق المرحلة

- [ ] إنشاء هيكل مجلد `test/`
- [ ] كتابة اختبارات خوارزمية المطابقة (≥ 10 سيناريوهات)
- [ ] كتابة اختبارات تطبيع النص العربي
- [ ] كتابة اختبارات استخراج المكونات الصوتية
- [ ] كتابة اختبارات تحويل المقادير
- [ ] كتابة اختبار ويدجت لـ RecipeCard
- [ ] كتابة اختبار ويدجت لـ IngredientChip
- [ ] إنشاء لقطات Golden للشاشات الأساسية (عربي + إنجليزي)
- [ ] كتابة اختبار التكامل: المسار الأساسي
- [ ] كتابة اختبار سلامة الوصفات
- [ ] كتابة اختبار الأداء (< 300ms)
- [ ] التغطية الإجمالية ≥ 70%
- [ ] تغطية المنطق الأساسي ≥ 90%
