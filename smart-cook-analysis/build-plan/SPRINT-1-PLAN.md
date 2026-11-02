# 📋 خطة تنفيذ المرحلة الأولى (Sprint 1 Plan)
## تأسيس البنية التحتية، البيئات (Flavors)، والتوجيه المتقدم (GoRouter)

> **المشروع:** تطبيق الطهي الذكي (Smart Cook)  
> **المرحلة:** Sprint 1 — التأسيس والهيكلة (Infrastructure & Architecture)  
> **المرجع التقني:** [01-project-setup.md](file:///d:/My%20Work/Flutter%20Projects/food%20app/smart-cook-analysis/build-plan/01-project-setup.md) و [EXECUTION-PLAN.md](file:///d:/My%20Work/Flutter%20Projects/food%20app/smart-cook-analysis/build-plan/EXECUTION-PLAN.md)  
> **الهدف التشغيلي:** إعداد الأساس التقني للمشروع بالكامل (حزم، بيئات، هيكلية، تنقل متقدم) دون التأثير على عمل الشاشات الحالية الـ 13.

---

## 🎯 1. أهداف المرحلة الأولى (Sprint Objectives)

1. **تحديث الحزم والاعتماديات:** إضافة حزم `Drift`, `Supabase`, `GoRouter`, `Freezed`, `WakelockPlus` وغيرها بتوافق دقيق يمنع أي تعارض في `pubspec.lock`.
2. **استكمال هيكل Clean Architecture:** إنشاء المجلدات الفرعية الناقصة في `lib/core/`, `lib/data/`, `lib/domain/` مع ملفات التصدير الموحدة.
3. **إعداد بيئات التشغيل المتعددة (Flavors):** فصل بيئة التطوير (`dev`) عن الإنتاج (`prod`) مع معالجة المتغيرات عبر `AppConfig`.
4. **بناء نظام التوجيه المركزي (GoRouter):** استبدال التنقل اليدوي بنظام مسارات آمن يدعم الروابط العميقة (`Deep Linking`) لكل الشاشات الـ 13.
5. **معالجة الأخطاء والتسجيل الموحد:** بناء `AppLogger` و `GlobalErrorHandler` لاصطياد أي استثناء قبل انهيار التطبيق.

---

## 🏗️ 2. خارطة التعديلات والملفات (File Map)

```
lib/
├── core/
│   ├── config/
│   │   ├── app_config.dart          [جديد] كائن البيئة والمتغيرات
│   │   └── environment.dart         [جديد] Enum البيئات (dev, staging, prod)
│   ├── errors/
│   │   ├── exceptions.dart          [جديد] تصنيف الاستثناءات
│   │   ├── failures.dart            [جديد] كائنات الفشل للـ Domain
│   │   └── error_handler.dart       [جديد] مصيدة الأخطاء العامة
│   ├── router/
│   │   ├── app_router.dart          [جديد] مسارات GoRouter لجميع الشاشات الـ 13
│   │   └── route_names.dart         [جديد] أسماء ومسارات التنقل الثابتة
│   ├── utils/
│   │   └── logger.dart              [جديد] خدمة السجلات الموحدة (Log Service)
│   └── theme/                       [موجود] يتم الحفاظ عليه
├── data/                            [موجود] تجهيز المجلدات لقاعدة البيانات لاحقاً
├── domain/                          [موجود] تجهيز مجلدات الكيانات لاحقاً
├── presentation/                    [موجود]
│   └── screens/
│       └── error_screen.dart        [جديد] شاشة خطأ 404 بديلة أنيقة
├── main.dart                        [تعديل] الترقية لدعم MaterialApp.router
├── main_dev.dart                    [جديد] نقطة دخول بيئة التطوير
├── main_prod.dart                   [جديد] نقطة دخول بيئة الإنتاج
└── pubspec.yaml                     [تعديل] إضافة وتثبيت الحزم اللازمة
```

---

## 📝 3. تفصيل المهام التنفيذية خطوة بخطوة (Step-by-Step Tasks)

### 🔹 الخطوة 1: تحديث ملف `pubspec.yaml` وتثبيت الحزم
**المسار:** [`pubspec.yaml`](file:///d:/My%20Work/Flutter%20Projects/food%20app/pubspec.yaml)  
**الإجراءات:**
1. إضافة الحزم الأساسية التالية تحت `dependencies`:
   - `go_router: ^14.6.2` (نظام التوجيه)
   - `drift: ^2.24.2` و `sqlite3_flutter_libs: ^0.5.28` و `path_provider: ^2.1.5` و `path: ^1.9.0` (التخزين المحلي)
   - `supabase_flutter: ^2.8.3` (الباك اند السحابي)
   - `connectivity_plus: ^6.1.1` (فحص الاتصال)
   - `wakelock_plus: ^1.2.8` (إبقاء الشاشة مفعلة في وضع الطهي)
   - `flutter_local_notifications: ^18.0.1` (مؤقتات الطهي)
   - `speech_to_text: ^7.0.0` (البحث الصوتي)
   - `share_plus: ^10.1.3` (مشاركة الوصفات)
2. إضافة حزم المولدات تحت `dev_dependencies`:
   - `build_runner: ^2.4.13`
   - `drift_dev: ^2.24.2`
   - `riverpod_generator: ^2.6.2`
   - `freezed: ^2.5.7`
   - `freezed_annotation: ^2.4.4`
   - `json_serializable: ^6.9.0`
3. تنفيذ أمر التثبيت: `flutter pub get`.
4. التحقق من عدم وجود أي تعارض (Conflict) في `pubspec.lock`.

---

### 🔹 الخطوة 2: إنشاء نظام التكوين والبيئات (Flavors System)
**الملفات المعنية:**
- `lib/core/config/environment.dart`
- `lib/core/config/app_config.dart`
- `lib/main_dev.dart`
- `lib/main_prod.dart`

**الإجراءات:**
1. إنشاء `Environment` enum يمثل `dev` و `staging` و `prod`.
2. إنشاء `AppConfig` يحتوي على:
   - اسم التطبيق بحسب البيئة (`Smart Cook Dev` مقابل `Smart Cook`).
   - رابط API أو Supabase URL ومفتاح الـ Anon Key الخاص بالبيئة.
   - ميزة `enableLogging` (مفعلة في التطوير، معطلة في الإنتاج).
   - ميزة `useMockDataFallback` (للاختبار السريع عند انقطاع السيرفر).
3. إنشاء ملفي التشغيل المنفصلين:
   - `main_dev.dart`: يهيئ `AppConfig.dev` ثم يستدعي `main()`.
   - `main_prod.dart`: يهيئ `AppConfig.prod` ثم يستدعي `main()`.

---

### 🔹 الخطوة 3: إدارة الأخطاء والتسجيل الموحد (Logging & Error Handling)
**الملفات المعنية:**
- `lib/core/utils/logger.dart`
- `lib/core/errors/failures.dart`
- `lib/core/errors/error_handler.dart`
- `lib/presentation/screens/error_screen.dart`

**الإجراءات:**
1. بناء `AppLogger` يوفر دوال واضحة: `AppLogger.debug()`, `AppLogger.info()`, `AppLogger.warning()`, `AppLogger.error()` مع تنسيق أنيق وطباعة اسم الملف ورقم السطر تلقائياً في بيئة التطوير فقط.
2. ضبط التقاط الاستثناءات على مستوى التطبيق:
   - `FlutterError.onError`: اصطياد أخطاء إطار عمل Flutter وعرض واجهة بديلة ودية في الإنتاج بدلاً من الشاشة الحمراء.
   - `PlatformDispatcher.instance.onError`: اصطياد الاستثناءات غير المتزامنة (Async Unhandled Errors).
3. تصميم `ErrorScreen` تعرض رسالة ودية للمستخدم وزر "العودة للرئيسية".

---

### 🔹 الخطوة 4: بناء نظام التوجيه المركزي بـ `GoRouter`
**الملفات المعنية:**
- `lib/core/router/route_names.dart`
- `lib/core/router/app_router.dart`

**الإجراءات:**
1. تعريف أسماء ومسارات جميع الشاشات الـ 13 كثوابت في `RouteNames`:
   - `/` ➔ `OnboardingScreen` / `MainNavigationScreen` (حسب حالة المستخدم)
   - `/today` ➔ شاشة اليوم (الاقتراحات)
   - `/pantry` ➔ شاشة المخزن
   - `/discover` ➔ شاشة الاستكشاف
   - `/shopping` ➔ شاشة التسوق
   - `/settings` ➔ شاشة الإعدادات
   - `/recipe/:id` ➔ شاشة تفاصيل الوصفة مع تمرير معرف الوصفة
   - `/cook-mode/:id` ➔ شاشة وضع الطهي مع تمرير معرف الوصفة
   - `/cook-completed` ➔ شاشة إتمام الطبخ والاحتفال
   - `/fridge-scanner` ➔ شاشة تصوير الثلاجة والمكونات
   - `/ai-inspire` ➔ شاشة الإلهام بالذكاء الاصطناعي
   - `/paywall` ➔ شاشة الاشتراك المميز
2. بناء كائن `GoRouter` وتزويده بـ `initialLocation: '/'`، وإعداد `errorBuilder` ليعرض `ErrorScreen`.
3. إتاحة التوجيه عبر مزود Riverpod: `appRouterProvider`.

---

### 🔹 الخطوة 5: ترقية `SmartCookApp` في `lib/main.dart`
**المسار:** [`lib/main.dart`](file:///d:/My%20Work/Flutter%20Projects/food%20app/lib/main.dart)  
**الإجراءات:**
1. تحويل `MaterialApp` إلى `MaterialApp.router`.
2. ربط `routerConfig` مع `ref.watch(appRouterProvider)`.
3. الحفاظ التام على:
   - الثيم الحالي: `AppTheme.lightTheme` و `AppTheme.darkTheme`.
   - إدارة حالة الثيم عبر `themeProvider`.
   - التوطين العربي الافتراضي: `const Locale('ar', 'SA')`.
   - `supportedLocales` و `localizationsDelegates`.
4. التحقق من أن تشغيل التطبيق يفتح الشاشة الرئيسية كالمعتاد ويعمل التنقل بين التبويبات بسلاسة تامة.

---

### 🔹 الخطوة 6: الفحص والاختبار والتحقق (Validation)
**الإجراءات:**
1. تشغيل فحص الأكواد الشامل:
   ```powershell
   flutter analyze
   ```
   **الهدف:** صفر أخطاء (0 issues found).
2. فحص البناء في بيئة التطوير:
   ```powershell
   flutter run -t lib/main_dev.dart -d chrome # أو عبر المحاكي
   ```
3. التحقق اليدوي:
   - التنقل بين التبويبات الأربعة السفلية.
   - فتح شاشة تفاصيل وصفة عبر الرابط `/recipe/1`.
   - فتح شاشة وضع الطهي عبر الرابط `/cook-mode/1`.
   - فتح مسار خاطئ مثل `/invalid-route` والتأكد من ظهور `ErrorScreen` الأنيقة.

---

## ⏱️ 4. خطة التوقيت وجدول التنفيذ (Execution Timeline)

| المهمة | الوقت المتوقع | المخرجات الرئيسية |
|--------|:------------:|-------------------|
| **الخطوة 1: الحزم** | 30 دقيقة | `pubspec.yaml` محدث و `pub get` ناجح |
| **الخطوة 2: البيئات** | 45 دقيقة | `app_config.dart`, `main_dev.dart`, `main_prod.dart` |
| **الخطوة 3: الأخطاء والسجلات** | 45 دقيقة | `logger.dart`, `error_handler.dart`, `error_screen.dart` |
| **الخطوة 4: التوجيه GoRouter** | 60 دقيقة | `app_router.dart` يغطي 13 مساراً وروابط عميقة |
| **الخطوة 5: ترقية main.dart** | 30 دقيقة | تطبيق يعمل بـ `MaterialApp.router` |
| **الخطوة 6: الفحص والتجربة** | 30 دقيقة | خلو تام من أخطاء `flutter analyze` واختبار المسارات |
| **المجموع** | **~4 ساعات عمل مركزة** | **اكتمال Sprint 1 بنسبة 100% وبأعلى معايير الجودة** |

---

## 🛡️ 5. خطة التراجع السريع عند الطوارئ (Rollback Plan)

- بما أننا نعتمد نهج التوسع الإضافي (Additive Changes)، فإن الشاشات الـ 13 الحالية لن يتم تعديل منطقها الداخلي في هذه المرحلة.
- يتم إنشاء نقطة حفظ (Git Commit / Stash) قبل بدء التعديل:
  ```powershell
  git add .
  git commit -m "checkpoint: before sprint 1 infrastructure changes"
  ```
- في حال حدوث أي تعارض في حزم الطرف الثالث، يمكن إعادة تثبيت الحزم السابقة فوراً عبر استرجاع `pubspec.yaml` و `pubspec.lock`.

---

## ✅ 6. معايير اكتمال المرحلة (Sprint 1 Definition of Done)

- [ ] نجاح `flutter pub get` مع جميع الحزم المطلوبة.
- [ ] خلو فحص `flutter analyze` من أي أخطاء أو تحذيرات حرجة.
- [ ] وجود بيئتين منفصلتين (`main_dev.dart` و `main_prod.dart`) تعملان بنجاح.
- [ ] جميع الشاشات الـ 13 مسجلة وتعمل عبر `GoRouter`.
- [ ] اصطياد الأخطاء غير المتوقعة وعرض شاشة ودية بدلاً من شاشات الانهيار الحمراء.
- [ ] الحفاظ على اللغة العربية RTL والثيمين الفاتح والداكن كما هما في واجهات التطبيق الحالية.
