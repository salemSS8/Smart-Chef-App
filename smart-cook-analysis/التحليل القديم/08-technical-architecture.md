# 08 — المعمارية التقنية (Flutter)

> الإصدارات والحزم أدناه اقتراحات؛ **تحقق من أحدث الإصدارات والتوافق** عند بدء التنفيذ.

## 1. القرارات التقنية الكبرى

| القرار | الاختيار المقترح | السبب |
|--------|-------------------|-------|
| إطار العمل | **Flutter** (Dart 3) | قاعدة كود واحدة، أداء ممتاز، RTL قوي، رسوم متحركة غنية |
| إدارة الحالة | **Riverpod** (مع توليد الكود) | قابلية الاختبار، فصل واضح، مناسب للمشاريع المتوسطة والكبيرة |
| التنقل | **go_router** | روابط عميقة (مشاركة وصفات)، إدارة مسارات |
| قاعدة محلية | **Drift (SQLite)** | استعلامات قوية، فهارس، Offline-first، FTS للبحث |
| الشبكة | **Dio** (+ Retrofit أو يدويًا) | اعتراضات، إعادة محاولة، تخزين مؤقت |
| النماذج | **freezed + json_serializable** | عدم قابلية التغيير، توليد كود |
| الباك اند | **Supabase** (Postgres + Auth + Storage + Edge Functions) *أو* **Firebase** | انظر المقارنة أدناه |
| الذكاء الاصطناعي | واجهة خلفية (Edge/Cloud Functions) تستدعي نموذجًا لغويًا/رؤية | لا مفاتيح في التطبيق |
| الاشتراكات | **RevenueCat** | تبسيط الفوترة عبر المتجرين |
| التحليلات/الأعطال | Firebase Analytics/Crashlytics أو PostHog + Sentry | رصد وقياس |
| الدفع بالإشعارات | FCM | إشعارات الفساد والتذكير |

### Supabase مقابل Firebase
| المعيار | Supabase | Firebase |
|---------|----------|----------|
| نموذج البيانات | علائقي (SQL) — **مناسب جدًا لبنية الوصفات والمكونات** | وثائقي (Firestore) — علاقات معقدة أصعب |
| البحث/الفهارس | GIN، pg_trgm، **pgvector** للتضمينات | محدود؛ يحتاج خدمة إضافية |
| التسعير | متوقع، مفتوح المصدر | قد يتصاعد مع القراءات |
| النضج/المنظومة | أحدث | أنضج مع Crashlytics/FCM |
**التوصية:** Supabase للبيانات والمصادقة + FCM/Crashlytics من Firebase عند الحاجة.

## 2. معمارية التطبيق (Feature-first + Clean Architecture)

```
lib/
├─ main.dart / app.dart
├─ core/
│  ├─ design_system/    (tokens, theme, widgets مشتركة)
│  ├─ l10n/             (ar, en + ARB)
│  ├─ network/ errors/ utils/ constants/
│  └─ platform/         (wakelock, haptics, speech, camera wrappers)
├─ data/
│  ├─ local/            (Drift DB, DAOs, migrations)
│  ├─ remote/           (API clients, DTOs)
│  └─ repositories/     (تنفيذ الواجهات)
├─ domain/
│  ├─ entities/         (Recipe, Ingredient, PantryItem…)
│  ├─ repositories/     (واجهات مجردة)
│  └─ usecases/         (MatchRecipes, AddIngredient, GenerateRecipe…)
└─ features/
   ├─ onboarding/
   ├─ pantry/           (presentation: screens, controllers, widgets)
   ├─ suggestions/
   ├─ recipe_detail/
   ├─ cook_mode/
   ├─ discover/
   ├─ meal_plan/
   ├─ shopping/
   ├─ profile/
   └─ paywall/
```

**قواعد:** الطبقات تعتمد للداخل (presentation → domain ← data)، ومنطق المطابقة نقي في `domain` ليُختبر بسهولة وينفَّذ في Isolate.

## 3. استراتيجية Offline-first

```
UI ← Riverpod ← Repository ← (Drift المحلي = مصدر الحقيقة) ⇄ المزامنة ⇄ Supabase
```
- حزمة الوصفات الأساسية تُنزَّل مرة واحدة (مضغوطة) وتُحدَّث تدريجيًا (delta sync بحسب `updated_at`).
- مخزون المستخدم والمفضلة تُكتب محليًا أولًا ثم تُزامَن (طابور عمليات مع حل التعارض: «آخر كتابة تفوز» لكل حقل أو CRDT مبسط لقوائم).
- الصور تُحمَّل عند الطلب مع **تخزين مؤقت** (`cached_network_image`) + BlurHash/ThumbHash.
- الوضع الافتراضي: **يعمل دون حساب**؛ عند التسجيل تُربط البيانات المحلية بالحساب.

## 4. الحزم المقترحة (حسب الوظيفة)

| الوظيفة | الحزمة |
|---------|--------|
| الحالة | `flutter_riverpod`, `riverpod_annotation` |
| التنقل | `go_router` |
| محلي | `drift`, `sqlite3_flutter_libs` |
| شبكة | `dio`, `connectivity_plus` |
| نماذج | `freezed`, `json_serializable` |
| صوت | `speech_to_text` (أو خدمة سحابية للدقة العالية) |
| كاميرا | `camera` / `image_picker`; ML على الجهاز: `google_mlkit_*` أو `tflite_flutter` |
| باركود | `mobile_scanner` |
| شاشة دائمة | `wakelock_plus` |
| مؤقتات/إشعارات | `flutter_local_notifications`, `workmanager`/`android_alarm_manager_plus` (للخلفية) |
| صور | `cached_network_image`, `flutter_blurhash` |
| رسوم | `lottie` أو `rive` |
| اشتراكات | `purchases_flutter` (RevenueCat) |
| تخزين آمن | `flutter_secure_storage` |
| مشاركة/روابط | `share_plus`, `app_links` |
| لغة | `flutter_localizations`, `intl` |
| صوت TTS (قراءة الخطوات) | `flutter_tts` |
| اختبار | `flutter_test`, `mocktail`, `integration_test`, `patrol` (اختياري) |

## 5. الباك اند

### 5.1 المكونات
- **Postgres:** الوصفات، المكونات، البدائل، المستخدمين، التقييمات.
- **Auth:** Google، Apple، هاتف/بريد.
- **Storage + CDN:** صور الوصفات بمقاسات متعددة (WebP/AVIF).
- **Edge Functions:** 
  - `/ai/extract-ingredients` (نص/صورة → مكونات)
  - `/ai/generate-recipe`
  - `/ai/substitute`
  - `/content/sync` (حزم التحديث)
  - `/webhooks/revenuecat`
- **لوحة محتوى (CMS):** أداة داخلية (مثل Retool/Directus أو لوحة مخصصة) لإدخال الوصفات وهيكلة المكونات والمراجعة.
- **RLS (Row Level Security):** المستخدم يرى بياناته فقط؛ الوصفات العامة للقراءة.

### 5.2 حماية واجهات الذكاء الاصطناعي
- مصادقة إلزامية (حتى للضيف: رمز مجهول Anonymous Auth) + **تحديد معدل** لكل مستخدم/جهاز.
- فحص حجم الصور وأنواعها، حذف فوري بعد المعالجة.
- سجل استخدام لتتبع التكلفة وكشف إساءة الاستخدام.
- **App Attest / Play Integrity** لتقليل الطلبات من تطبيقات مزيفة.

## 6. الأمان

| الجانب | الإجراء |
|--------|---------|
| الاتصال | HTTPS، تثبيت الشهادة (اختياري) |
| الأسرار | لا مفاتيح في الكود؛ متغيرات بيئة على الخادم |
| الرموز | تخزين آمن، تجديد دوري |
| التشويش | `--obfuscate --split-debug-info` للإصدارات |
| الخصوصية | تقليل البيانات، تشفير في الراحة، سياسات احتفاظ |
| الاعتماديات | فحص دوري (Dependabot) |
| اختبارات اختراق | قبل الإطلاق العام |

## 7. الأداء

- **الاستعلامات:** فهارس على جداول الربط `recipe_ingredients`، استعلامات مخزّنة، pagination.
- **المطابقة:** في Isolate؛ بنى بيانات bitset.
- **الصور:** مقاسات مناسبة للشاشة، `precacheImage` للأوائل، `ListView.builder`/Slivers.
- **حجم التطبيق:** App Bundles، تقسيم الأصول، تحميل الحزم الكبيرة عند الحاجة.
- **التحقق:** Flutter DevTools، اختبارات الأداء على أجهزة اقتصادية، هدف 60fps.
- **بدء التشغيل:** تأجيل التهيئات الثقيلة، Splash أصلي خفيف.

## 8. CI/CD

- **GitHub Actions** (أو Codemagic): تنسيق + تحليل ثابت + اختبارات + بناء.
- **Fastlane**: توقيع ورفع إلى TestFlight/Play Internal.
- **قنوات:** dev → staging → production، مع **Feature Flags** (Remote Config) لتجارب الإصدارات.
- **ترحيل قاعدة البيانات:** نسخ مرقمة، تدريجي، قابل للتراجع.
- **Flavors** (dev/staging/prod) بإعدادات منفصلة.

## 9. الاختبار

| المستوى | الأدوات | التغطية |
|---------|---------|---------|
| وحدة | `flutter_test`, `mocktail` | خوارزمية المطابقة، المحوّلات، التحويلات (≥ 80%) |
| ودجت | `flutter_test`, golden tests | المكونات البصرية، RTL، أحجام الخط |
| تكامل | `integration_test` | المسارات الأساسية: إضافة مكونات → اقتراح → طهي |
| بيانات | سكربتات تحقق | سلامة وصفات (وحدات، مكونات معروفة، لا حساسية مفقودة) |
| أداء | DevTools profiling | زمن المطابقة، 60fps |
| إتاحة | TalkBack/VoiceOver يدويًا | الشاشات الرئيسية |

## 10. الرصد والتحليلات

أحداث رئيسية: `onboarding_complete`, `ingredient_added(method)`, `suggestions_viewed(count)`, `recipe_opened`, `cook_started`, `cook_completed`, `ai_generate_requested`, `paywall_viewed`, `subscribed`.
- قمع التحويل: فتح ← إضافة 3 مكونات ← عرض نتائج ← فتح وصفة ← بدء طهي ← إكمال.
- احترام الموافقة على التتبع (ATT على iOS، GDPR/قوانين محلية).

## 11. التوافق والمنصات

- Android: API 26+ (تحقق من متطلبات Google Play لمستوى الاستهداف الحالي).
- iOS: 15+ (تحقق من متطلبات Apple).
- لاحقًا: Tablet layouts (مفيد في المطبخ)، ساعات ذكية (مؤقتات)، Web لعرض الوصفات المشاركة (SEO).

## 12. تقدير التعقيد التقني

| المكوّن | التعقيد | ملاحظة |
|---------|:-------:|--------|
| واجهة وتصميم نظام | متوسط-عالٍ | جودة الحركة وRTL تستغرق وقتًا |
| المطابقة المحلية | متوسط | منطق + فهارس + اختبارات |
| مزامنة Offline | عالٍ | أكثر الأجزاء خطرًا على الجودة |
| الصوت والكاميرا | متوسط-عالٍ | تحدي اللهجات والدقة |
| AI التوليدي الآمن | عالٍ | يحتاج مدققات وتقييم مستمر |
| CMS للمحتوى | متوسط | قد يُستعان بأداة جاهزة |
