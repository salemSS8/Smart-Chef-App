# 01 — تأسيس المشروع: الحزم والهيكل والبيئات

> **المدة المُقدَّرة:** 3–5 أيام
> **الأولوية:** 🔴 عالية — لا يمكن البدء بأي ميزة حقيقية بدون هذه الخطوة

---

## 1. إعادة هيكلة الحزم (`pubspec.yaml`)

### 1.1 الحزم الجديدة المطلوبة

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter

  # === إدارة الحالة ===
  flutter_riverpod: ^3.3.2           # ✅ موجود
  riverpod_annotation: ^2.6.1        # جديد — لتوليد الكود

  # === التنقل ===
  go_router: ^14.8.1                 # جديد — روابط عميقة + تنقل مُنظم

  # === قاعدة بيانات محلية ===
  drift: ^2.23.1                     # جديد — SQLite مع type-safety
  sqlite3_flutter_libs: ^0.5.28      # جديد — مكتبة SQLite أصلية
  path_provider: ^2.1.5              # جديد — مسارات الملفات
  path: ^1.9.1                       # جديد — تعامل مع المسارات

  # === الشبكة ===
  dio: ^5.7.0                        # جديد — HTTP client متقدم
  connectivity_plus: ^6.1.3          # جديد — حالة الاتصال

  # === النماذج ===
  freezed_annotation: ^3.0.0         # جديد — تعريفات النماذج
  json_annotation: ^4.9.0            # جديد — تحويل JSON

  # === المصادقة ===
  supabase_flutter: ^2.9.0           # جديد — Supabase SDK

  # === واجهة المستخدم ===
  google_fonts: ^8.2.1               # ✅ موجود
  flutter_animate: ^4.5.2            # ✅ موجود
  cached_network_image: ^3.4.1       # ✅ موجود
  shimmer: ^3.0.0                    # جديد — تحميل جميل
  lottie: ^3.3.1                     # جديد — رسوم متحركة

  # === أدوات ===
  intl: 0.20.2                       # ✅ موجود
  shared_preferences: ^2.5.5         # ✅ موجود
  flutter_secure_storage: ^9.2.4     # جديد — تخزين آمن للرموز
  wakelock_plus: ^1.2.10             # جديد — شاشة دائمة (وضع الطهي)
  share_plus: ^10.1.4                # جديد — مشاركة
  url_launcher: ^6.3.1               # جديد — فتح روابط

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0              # ✅ موجود
  flutter_launcher_icons: ^0.14.3    # ✅ موجود

  # === توليد الكود ===
  build_runner: ^2.4.15              # جديد
  drift_dev: ^2.23.1                 # جديد — توليد Drift
  freezed: ^3.0.3                    # جديد — توليد النماذج
  json_serializable: ^6.9.4          # جديد — توليد JSON
  riverpod_generator: ^2.6.5         # جديد — توليد Riverpod

  # === اختبارات ===
  mocktail: ^1.0.4                   # جديد — Mock objects
  integration_test:                  # جديد — اختبارات تكامل
    sdk: flutter
```

### 1.2 خطوات التنفيذ

```powershell
# 1. تحديث pubspec.yaml بالحزم أعلاه
# 2. تثبيت الحزم
flutter pub get

# 3. تجربة توليد الكود
dart run build_runner build --delete-conflicting-outputs
```

---

## 2. إعادة هيكلة المجلدات

### 2.1 الهيكل الحالي
```
lib/
├─ main.dart
├─ core/
│  ├─ theme/        (app_colors.dart, app_theme.dart)
│  └─ utils/        (text_normalizer.dart)
├─ data/
│  ├─ mock/         (ingredients_data.dart, recipes_data.dart)
│  └─ repositories/ (pantry_repository.dart)
├─ domain/
│  └─ models/       (ingredient.dart, recipe.dart)
└─ presentation/
   ├─ providers/    (5 ملفات)
   ├─ screens/      (13 شاشة)
   └─ widgets/      (5 ويدجت)
```

### 2.2 الهيكل المستهدف
```
lib/
├─ main.dart
├─ app.dart                          # ← فصل التطبيق عن main
├─ core/
│  ├─ theme/                         # ✅ يبقى كما هو
│  ├─ utils/                         # ✅ يبقى كما هو
│  ├─ constants/                     # ← جديد: ثوابت عامة
│  │  ├─ app_constants.dart
│  │  └─ api_constants.dart
│  ├─ network/                       # ← جديد: Dio client
│  │  ├─ dio_client.dart
│  │  ├─ api_interceptor.dart
│  │  └─ network_exceptions.dart
│  ├─ errors/                        # ← جديد: معالجة الأخطاء
│  │  ├─ failures.dart
│  │  └─ exceptions.dart
│  ├─ l10n/                          # ← جديد: ملفات الترجمة
│  │  ├─ app_ar.arb
│  │  └─ app_en.arb
│  └─ router/                        # ← جديد: go_router
│     ├─ app_router.dart
│     └─ route_names.dart
├─ data/
│  ├─ local/                         # ← جديد: Drift DB
│  │  ├─ database.dart
│  │  ├─ tables/
│  │  │  ├─ ingredients_table.dart
│  │  │  ├─ recipes_table.dart
│  │  │  ├─ pantry_table.dart
│  │  │  └─ ...
│  │  ├─ daos/
│  │  │  ├─ ingredient_dao.dart
│  │  │  ├─ recipe_dao.dart
│  │  │  └─ ...
│  │  └─ migrations/
│  ├─ remote/                        # ← جديد: API clients
│  │  ├─ supabase_client.dart
│  │  └─ dtos/
│  ├─ mock/                          # ✅ يبقى مؤقتًا
│  └─ repositories/                  # ← يُوسَّع
│     ├─ pantry_repository_impl.dart
│     ├─ recipe_repository_impl.dart
│     └─ ingredient_repository_impl.dart
├─ domain/
│  ├─ models/                        # ← يُعاد تسميتها entities
│  │  ├─ ingredient.dart             # ← يُحوَّل لـ freezed
│  │  ├─ recipe.dart                 # ← يُحوَّل لـ freezed
│  │  ├─ pantry_item.dart
│  │  └─ shopping_item.dart
│  ├─ repositories/                  # ← جديد: واجهات مجردة
│  │  ├─ i_recipe_repository.dart
│  │  ├─ i_ingredient_repository.dart
│  │  └─ i_pantry_repository.dart
│  └─ usecases/                      # ← جديد
│     ├─ match_recipes.dart
│     ├─ search_ingredients.dart
│     └─ add_to_pantry.dart
└─ presentation/                     # ✅ يبقى مع تحسينات
   ├─ providers/
   ├─ screens/
   └─ widgets/
```

### 2.3 خطوات الانتقال (بدون كسر الكود)

> ⚠️ **القاعدة الذهبية:** كل خطوة يجب أن تُبقي التطبيق يعمل. لا تُعِد الهيكلة دفعة واحدة.

```
الخطوة 1: أضف المجلدات الجديدة الفارغة
الخطوة 2: أنشئ app.dart وانقل SmartCookApp من main.dart
الخطوة 3: أنشئ core/constants/ و core/errors/
الخطوة 4: أنشئ core/router/ مع go_router (واستبدل التنقل تدريجيًا)
الخطوة 5: أنشئ domain/repositories/ (الواجهات المجردة)
الخطوة 6: حوّل النماذج لـ freezed (واحدة تلو الأخرى)
الخطوة 7: أنشئ data/local/ (Drift) — تفاصيله في الملف التالي
```

---

## 3. إعداد البيئات (Flavors)

### 3.1 ثلاث بيئات

| البيئة | الغرض | Supabase | التحليلات |
|--------|--------|----------|-----------|
| `dev` | التطوير المحلي | مشروع Dev | معطلة |
| `staging` | اختبار Beta | مشروع Staging | مفعلة (بيانات اختبار) |
| `prod` | الإنتاج | مشروع Production | مفعلة |

### 3.2 الملفات المطلوبة

```
lib/
├─ main_dev.dart
├─ main_staging.dart
├─ main_prod.dart
└─ core/
   └─ config/
      ├─ env_config.dart        # enum Environment + إعدادات
      └─ flavor_config.dart     # URLs, keys per flavor
```

### 3.3 مثال `env_config.dart`

```dart
enum Environment { dev, staging, prod }

class EnvConfig {
  final Environment environment;
  final String supabaseUrl;
  final String supabaseAnonKey;
  final bool enableAnalytics;
  final bool enableCrashlytics;

  const EnvConfig({
    required this.environment,
    required this.supabaseUrl,
    required this.supabaseAnonKey,
    this.enableAnalytics = false,
    this.enableCrashlytics = false,
  });

  bool get isDev => environment == Environment.dev;
  bool get isProd => environment == Environment.prod;
}
```

### 3.4 إعداد Android Flavors

في `android/app/build.gradle.kts`:
```kotlin
android {
    flavorDimensions += "environment"
    productFlavors {
        create("dev") {
            dimension = "environment"
            applicationIdSuffix = ".dev"
            versionNameSuffix = "-dev"
        }
        create("staging") {
            dimension = "environment"
            applicationIdSuffix = ".staging"
            versionNameSuffix = "-staging"
        }
        create("prod") {
            dimension = "environment"
        }
    }
}
```

### 3.5 إعداد iOS Schemes

```
1. افتح Runner.xcworkspace في Xcode
2. أنشئ Configurations جديدة:
   - Debug-dev, Release-dev
   - Debug-staging, Release-staging
   - Debug-prod, Release-prod
3. أنشئ Schemes:
   - dev, staging, prod
4. اربط كل Scheme بالـ Configuration المناسب
```

### 3.6 أوامر التشغيل

```powershell
# تطوير
flutter run --flavor dev -t lib/main_dev.dart

# اختبار
flutter run --flavor staging -t lib/main_staging.dart

# إنتاج
flutter run --flavor prod -t lib/main_prod.dart
```

---

## 4. إعداد go_router

### 4.1 الملف الأساسي `core/router/app_router.dart`

```dart
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      // --- Onboarding ---
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // --- Main Shell (Bottom Navigation) ---
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainNavigationScreen(navigationShell: navigationShell);
        },
        branches: [
          // تبويب: اليوم
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/',
              name: 'today',
              builder: (context, state) => const TodayScreen(),
            ),
          ]),
          // تبويب: المخزون
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/pantry',
              name: 'pantry',
              builder: (context, state) => const PantryScreen(),
            ),
          ]),
          // تبويب: استكشاف
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/discover',
              name: 'discover',
              builder: (context, state) => const DiscoverScreen(),
            ),
          ]),
          // تبويب: التسوق
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/shopping',
              name: 'shopping',
              builder: (context, state) => const ShoppingScreen(),
            ),
          ]),
          // تبويب: الإعدادات
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/settings',
              name: 'settings',
              builder: (context, state) => const SettingsScreen(),
            ),
          ]),
        ],
      ),

      // --- شاشات فرعية ---
      GoRoute(
        path: '/recipe/:id',
        name: 'recipeDetail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return RecipeDetailScreen(recipeId: id);
        },
      ),
      GoRoute(
        path: '/cook/:id',
        name: 'cookMode',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return CookModeScreen(recipeId: id);
        },
      ),
    ],
  );
});
```

---

## 5. تحويل النماذج لـ freezed

### 5.1 مثال: `Recipe` model

**قبل (الحالي):**
```dart
class Recipe {
  final String id;
  final String title;
  // ... حقول كثيرة
  Recipe({required this.id, required this.title, ...});
}
```

**بعد (freezed):**
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'recipe.freezed.dart';
part 'recipe.g.dart';

@freezed
class Recipe with _$Recipe {
  const factory Recipe({
    required String id,
    required String slug,
    required Map<String, String> title,         // {ar: '...', en: '...'}
    Map<String, String>? description,
    String? cuisine,
    @Default([]) List<String> mealType,
    @Default(1) int difficulty,
    int? prepMinutes,
    int? cookMinutes,
    @Default(4) int baseServings,
    int? caloriesPerServing,
    @Default([]) List<String> equipment,
    @Default({}) Map<String, dynamic> dietFlags,
    @Default([]) List<String> allergens,
    @Default('editorial') String sourceType,
    @Default(false) bool verified,
    String? heroImageUrl,
    String? blurhash,
    @Default(0.0) double ratingAvg,
    @Default(0) int ratingCount,
    @Default([]) List<RecipeIngredient> ingredients,
    @Default([]) List<RecipeStep> steps,
  }) = _Recipe;

  factory Recipe.fromJson(Map<String, dynamic> json) =>
      _$RecipeFromJson(json);
}
```

### 5.2 ترتيب التحويل

```
1. Recipe → recipe.dart
2. Ingredient → ingredient.dart
3. إنشاء PantryItem → pantry_item.dart
4. إنشاء ShoppingItem → shopping_item.dart
5. إنشاء UserPreferences → user_preferences.dart
6. إنشاء CookSession → cook_session.dart
```

---

## 6. إعداد `.gitignore` المُحدَّث

```gitignore
# أضف هذه الأسطر
*.g.dart
*.freezed.dart
*.drift.dart

# Supabase
supabase/.temp/

# البيئات
.env
.env.*
```

---

## 7. قائمة تحقق المرحلة

- [ ] تحديث `pubspec.yaml` بجميع الحزم الجديدة
- [ ] `flutter pub get` يعمل بنجاح
- [ ] إنشاء المجلدات الجديدة (constants, network, errors, l10n, router, local, remote, usecases)
- [ ] فصل `app.dart` عن `main.dart`
- [ ] إعداد `EnvConfig` مع 3 بيئات
- [ ] إعداد Android Flavors
- [ ] إعداد iOS Schemes (إن توفر macOS)
- [ ] إعداد go_router واستبدال التنقل القديم
- [ ] تحويل نموذج `Recipe` لـ freezed
- [ ] تحويل نموذج `Ingredient` لـ freezed
- [ ] `dart run build_runner build` يعمل بنجاح
- [ ] التطبيق يعمل ويُبنى بدون أخطاء
- [ ] تحديث `.gitignore`
