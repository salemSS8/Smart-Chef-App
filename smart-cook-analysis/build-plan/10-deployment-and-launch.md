# 10 — النشر والإطلاق: التوقيع، الرفع، الإطلاق التدريجي، وما بعد الإطلاق

> **المدة المُقدَّرة:** 5–7 أيام
> **يعتمد على:** الملفات 08 (CI/CD والأتمتة) + 09 (قائمة ما قبل الإطلاق)
> **الأولوية:** 🔴 عالية — مرحلة التتويج والوصول الفعلي للمستخدمين على المتاجر

---

## 1. نظرة عامة على خارطة الإطلاق

```
            [حزم الإنتاج الموقعة Production Builds]
                      │
        ┌─────────────┴─────────────┐
        ▼                           ▼
[Google Play Console]       [App Store Connect]
  ├─ Internal Test (فريق)     ├─ TestFlight Internal
  ├─ Closed Beta (500 مستخدم) ├─ TestFlight Public Link
  ├─ Open Beta                ├─ App Review Submission
  └─ Staged Rollout (1%→100%) └─ Phased Release (7 Days)
        │                           │
        └─────────────┬─────────────┘
                      ▼
        [مراقبة حية Post-Launch]
          ├─ Crash-Free Users (≥ 99.5%)
          ├─ ANR & Vitals Health
          ├─ Sentry / Crashlytics Traces
          ├─ Serverless / Supabase Metrics
          └─ In-App Review Loop & Hotfix Triggers
```

---

## 2. إدارة التوقيع والشهادات (App Signing & Certificates)

### 2.1 إعداد توقيع Android (Upload Keystore)

```powershell
# 1. توليد مفتاح التوقيع باستخدام keytool في PowerShell
keytool -genkey -v -keystore "upload-keystore.jks" `
  -alias "smartcook-upload" `
  -keyalg RSA -keysize 2048 -validity 10000 `
  -storetype JKS

# 2. الاحتفاظ بالملف في مكان آمن وعدم رفعه إلى Git مطلقاً
# إنشاء ملف android/key.properties
```

محتوى `android/key.properties`:
```properties
storePassword=YOUR_STRONG_STORE_PASSWORD
keyPassword=YOUR_STRONG_KEY_PASSWORD
keyAlias=smartcook-upload
storeFile=../upload-keystore.jks
```

ربطه داخل `android/app/build.gradle.kts`:
```kotlin
import java.io.FileInputStream
import java.util.Properties

val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    ...
    signingConfigs {
        create("release") {
            if (keystorePropertiesFile.exists()) {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}
```

قواعد Proguard المطلوبة في `android/app/proguard-rules.pro`:
```proguard
# Flutter Proguard Rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Drift / SQLite Native Libs
-keep class com.simontastic.drift.** { *; }

# Google Sign-in / Supabase
-keepattributes *Annotation*
-keepattributes Signature
```

### 2.2 إعداد شهادات iOS (Apple Certificates & Provisioning)

أفضل ممارسة موصى بها هي أتمتة الشهادات عبر `Fastlane Match` بمستودع Git خاص مشفر:

```bash
# تهيئة match عبر Fastlane
fastlane match init

# توليد شهادات التطوير والإنتاج لـ App Store
fastlane match appstore --app_identifier "com.smartcook.app"
fastlane match development --app_identifier "com.smartcook.app"
```

أو عبر Xcode يدوياً:
1. الدخول إلى **Apple Developer Account** → Certificates, Identifiers & Profiles.
2. إنشاء **App ID**: `com.smartcook.app` مع تفعيل القدرات (Sign In with Apple, Push Notifications, Associated Domains).
3. إنشاء **Distribution Certificate** و **App Store Provisioning Profile**.
4. استيرادها في Xcode تحت تبويب `Signing & Capabilities` لاستهداف `Release`.

---

## 3. بناء الحزم الإنتاجية المعزولة (Production Builds)

### 3.1 أمر بناء Android App Bundle (AAB)

```powershell
# بناء حزمة الإنتاج مع التشويش الكامل وتفريغ رموز التصحيح
flutter build appbundle `
  --release `
  --flavor production `
  -t lib/main_production.dart `
  --obfuscate `
  --split-debug-info=build/app/outputs/symbols `
  --build-name="1.0.0" `
  --build-number=1
```

> **ملاحظة:** احتفظ بمجلد `symbols` المرتبط بكل `build-number` لتتمكن من فك تشفير Crash Stack Traces عبر Google Play Console أو Sentry.

### 3.2 أمر بناء iOS IPA

```bash
# بناء حزمة iOS مع الإعدادات الإنتاجية
flutter build ipa \
  --release \
  --flavor production \
  -t lib/main_production.dart \
  --obfuscate \
  --split-debug-info=build/ios/outputs/symbols \
  --build-name="1.0.0" \
  --build-number=1 \
  --export-options-plist=ios/ExportOptions.plist
```

محتوى `ios/ExportOptions.plist`:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>app-store</string>
    <key>teamID</key>
    <string>YOUR_APPLE_TEAM_ID</string>
    <key>uploadBitcode</key>
    <false/>
    <key>compileBitcode</key>
    <false/>
    <key>uploadSymbols</key>
    <true/>
    <key>signingStyle</key>
    <string>manual</string>
</dict>
</plist>
```

---

## 4. إعداد واجهات المتاجر والبيانات الوصفية (Store Presence & Metadata)

### 4.1 البيانات الوصفية لـ Google Play Store

| الحقل | الحد الأقصى | القيمة المقترحة |
|-------|:-----------:|-----------------|
| **App Title** | 30 حرف | طبخي الذكي: وصفات من مكوناتك |
| **Short Description** | 80 حرف | اطبخ ألذ الوجبات بما يتوفر في مطبخك فوراً وبدون هدر للطعام |
| **Full Description** | 4000 حرف | وصف تفصيلي يحتوي على: المشكلة، الحل، الميزات (المخزن، وضع الطهي خطوة بخطوة، حساب السعرات، العمل بدون إنترنت) |
| **Category** | - | Food & Drink (طعام ومشروبات) |
| **Content Rating** | - | IARC: مناسب لجميع الفئات (Everyone 3+) |

### 4.2 نموذج أمان البيانات (Data Safety Section - Google Play)

يجب التصريح الصادق عن البيانات لتجنب رفض التطبيق:
- **الموقع التقريبي / الدقيق:** ❌ لا يجمعه التطبيق.
- **المعلومات الشخصية (الاسم، البريد):** ✅ يُجمع اختياريًا عند تسجيل الدخول لحفظ المزامنة.
- **معلومات الاستخدام (Analytics):** ✅ بيانات تفاعل التطبيق لتشخيص الأخطاء وتحسين التوصيات (مشفرة أثناء النقل `TLS`).
- **معلومات الأعطال (Diagnostics):** ✅ Crashlytics / Sentry لرفع استقرار النظام.
- **حذف الحساب والبيانات:** ✅ يوفر التطبيق زرًا فوريًا داخل الإعدادات لحذف الحساب وحذف كافة البيانات من الخوادم نهائيًا.

### 4.3 متطلبات خصوصية Apple App Store (Privacy Nutrition Labels)

- **Data Used to Track You:** لا شيء (No Tracking).
- **Data Linked to You:**
  - Contact Info (Email Address في حال تسجيل الدخول).
  - User Content (قوائم المكونات والوصفات المفضلة المرتبطة بالحساب).
- **Data Not Linked to You:**
  - Usage Data & Diagnostics (Crash reports مجهولة المصدر).

### 4.4 الأصول المرئية المطلوبة للمتاجر

1. **أيقونة التطبيق عالية الدقة:**
   - Play Store: `512 x 512 px`, 32-bit PNG, شفافية غير مسموحة.
   - App Store: `1024 x 1024 px`, PNG بدون زوايا دائرية وبدون قنوات ألفا.
2. **صورة الميزة (Feature Graphic - Play Store):**
   - `1024 x 500 px`, JPG/PNG، تعرض هوية التطبيق البصرية الجذابة بدون نصوص مكتظة.
3. **لقطات الشاشة (Screenshots):**
   - **الهواتف:** قياس 6.5 بوصة (1284 x 2778) و 5.5 بوصة (1242 x 2208).
   - **الأجهزة اللوحية:** شاشات 12.9 بوصة لـ iPad / أجهزة Android اللوحية.
   - تصميم اللقطات بإطارات هواتف عصرية ونصوص عربية جذابة وموجزة فوق كل شاشة تشرح ميزة واحدة واضحة.

---

## 5. استراتيجية الإطلاق التدريجي (Staged Rollout Strategy)

لا تطلق التطبيق بنسبة 100% فورًا لتجنب الكوارث البرمجية غير المتوقعة في بيئات الأجهزة الحقيقية.

### 5.1 جدول الإطلاق على Google Play (Staged Rollout)

```
اليوم 1:  1%   ← فحص أولي للأعطال الحرجة والانفجارات التقنية المبكرة
اليوم 2:  5%   ← التحقق من استقرار السيرفرات وقواعد Supabase مع مستخدمين جدد
اليوم 3: 10%   ← مراقبة تقييمات اليوم الأول وتعليقات المستخدمين
اليوم 4: 20%   ← فحص استهلاك الموارد وحجم الـ Bandwidth
اليوم 5: 50%   ← بدء حملات تسويقية مصغرة
اليوم 7: 100%  ← الإطلاق الكامل العام للجميع
```

### 5.2 جدول الإطلاق على Apple App Store (Phased Release)

يوفر متجر Apple نظام إطلاق تدريجي تلقائي على مدى 7 أيام:
- اليوم الأول: 1%
- اليوم الثاني: 2%
- اليوم الثالث: 5%
- اليوم الرابع: 10%
- اليوم الخامس: 20%
- اليوم السادس: 50%
- اليوم السابع: 100%

### 5.3 مؤشرات الإيقاف الطارئ للإطلاق (Halt & Abort Criteria)

يتم إيقاف النشر التدريجي فوراً (`Halt Rollout`) إذا تحقق أي من الآتي:
1. انخفاض نسبة **Crash-Free Users** تحت **99.2%**.
2. نسبة **ANR (Application Not Responding)** تتجاوز **0.3%**.
3. فشل خدمة المزامنة مع قاعدة البيانات السحابية وتكرار أخطاء `HTTP 5xx` بنسبة تفوق 1%.
4. اكتشاف ثغرة أمنية أو خطأ في حساب المقادير قد يسبب ضرراً لصحة المستخدم أو حساسياته الغذائية.

---

## 6. المراقبة التشغيلية بعد الإطلاق (Post-Launch Operations)

### 6.1 لوحة المراقبة اليومية (Daily Operations Dashboard)

```dart
// lib/core/monitoring/app_vitals_service.dart

import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class AppVitalsService {
  static void logUserAction(String action, {Map<String, dynamic>? params}) {
    if (kReleaseMode) {
      Sentry.addBreadcrumb(
        Breadcrumb(
          category: 'user.action',
          message: action,
          data: params,
          level: SentryLevel.info,
        ),
      );
    }
  }

  static void recordPerformanceMetric(String metricName, int durationMs) {
    if (durationMs > 1000) {
      // تنبيه إذا تجاوزت العملية ثانية واحدة
      Sentry.captureMessage(
        'Slow Operation: $metricName took ${durationMs}ms',
        level: SentryLevel.warning,
      );
    }
  }
}
```

### 6.2 مؤشرات الأداء الحيوية (Key Vitals to Monitor)

- **زمن التشغيل البارد (Cold App Start):** < 1.8 ثانية.
- **استهلاك الذاكرة (RAM Usage):** < 140MB في وضع التصفح العادي، و < 200MB في وضع الطهي التفاعلي.
- **معدل استجابة خوارزمية المطابقة:** < 250ms على الهواتف الضعيفة والمتوسطة.
- **نجاح عمليات المزامنة العكسية (Sync Reliability):** ≥ 99.8%.

---

## 7. آلية التحديثات الساخنة وطلب المراجعات الذكي

### 7.1 التحديث الإجباري والاختياري داخل التطبيق (In-App Updates)

تطبيق آلية `In-App Update` على نظام Android للتأكد من وصول التحديثات الأمنية العاجلة:

```dart
// lib/core/services/update_checker_service.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';

class UpdateCheckerService {
  static Future<void> checkForAndroidUpdate(BuildContext context) async {
    if (!Platform.isAndroid) return;

    try {
      final updateInfo = await InAppUpdate.checkForUpdate();
      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        if (updateInfo.immediateUpdateAllowed) {
          // تحديث فوري إجباري في حال وجود تحديث حرج
          await InAppUpdate.performImmediateUpdate();
        } else if (updateInfo.flexibleUpdateAllowed) {
          // تحديث مرن في الخلفية مع تنبيه لطيف
          await InAppUpdate.startFlexibleUpdate();
          await InAppUpdate.completeFlexibleUpdate();
        }
      }
    } catch (e) {
      debugPrint('Update check failed: $e');
    }
  }
}
```

### 7.2 التقييم الذكي داخل التطبيق (Smart In-App Review)

طلب التقييم في اللحظة النفسية المناسبة (وليس عند أول فتح للتطبيق):

```dart
// lib/core/services/review_service.dart

import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewService {
  static const _keyCookedRecipesCount = 'cooked_recipes_count';
  static const _keyReviewRequested = 'review_requested_already';

  /// يُستدعى فقط بعد إتمام المستخدم لوصفة بنجاح في شاشة وضع الطهي
  static Future<void> onRecipeSuccessfullyCooked() async {
    final prefs = await SharedPreferences.getInstance();
    final alreadyRequested = prefs.getBool(_keyReviewRequested) ?? false;
    if (alreadyRequested) return;

    int count = (prefs.getInt(_keyCookedRecipesCount) ?? 0) + 1;
    await prefs.setInt(_keyCookedRecipesCount, count);

    // نطلب التقييم بعد طهي 3 وصفات بنجاح
    if (count >= 3) {
      final InAppReview inAppReview = InAppReview.instance;
      if (await inAppReview.isAvailable()) {
        await inAppReview.requestReview();
        await prefs.setBool(_keyReviewRequested, true);
      }
    }
  }
}
```

---

## 8. بروتوكول الطوارئ والإصلاح السريع (Hotfix Protocol)

عند حدوث عطل برمجي كبير غير متوقع في الإنتاج:

```
[اكتشاف العطل في Crashlytics / Sentry]
                  │
                  ▼
         [إيقاف الطرح التدريجي]
         Halt Staged Rollout فوراً
                  │
                  ▼
         [إنشاء فرع الإصلاح السريع]
         git checkout -b hotfix/1.0.1 main
                  │
                  ▼
         [كتابة الاختبار التراجعي]
         كتابة Unit / Integration Test يُثبت العطل ويمنع عودته
                  │
                  ▼
         [إصلاح الكود واختباره محلياً]
         flutter test & flutter analyze
                  │
                  ▼
         [رفع Build Number وبناء AAB / IPA]
         version: 1.0.1+2
                  │
                  ▼
         [طلب مراجعة مستعجلة من Apple و Google]
         App Store: Submit Expedited Review Request
         Google Play: Rollout to 100% directly
```

---

## 9. استراتيجية الإطلاق التسويقي الأولى (Go-To-Market)

### 9.1 تحسين محركات البحث في المتاجر (ASO - App Store Optimization)

- **الكلمات المفتاحية المستهدفة (عربي):**
  - `طبخ، وصفات، مطبخ، مكونات، أكلات سريعة، طبخ بالبيت، ماذا أطبخ اليوم، جدول الوجبات، بدون هدر، دايت، كيتو`
- **الكلمات المفتاحية المستهدفة (English):**
  - `smart cook, recipe generator, pantry food, ingredients recipes, meal planner, zero food waste`

### 9.2 مسار إشراك المستخدمين الجدد (First 10,000 Users)

1. **اليوم 1–7:** إطلاق لمجموعات الطهي المهتمة على منصات التواصل (Reddit r/recipes, مجموعات فيسبوك المتخصصة بالطبخ العربي، قنوات تليجرام).
2. **اليوم 8–14:** مقاطع فيديو قصيرة (Reels / TikTok / Shorts) تُظهر المشكلة الأكثر انتشاراً: *"عندك ثلاجة مليانة بس مش عارف شو تطبخ؟ شوف هذا التطبيق يحلها بزر واحد"*.
3. **اليوم 15–30:** مشاركة التطبيق مع طهاة مؤثرين (Micro-influencers) واستعراض ميزة وضع الطهي الخالي من اللمس ومؤقتات المراحل الذكية.

---

## 10. جدول دورات الصيانة والتطوير المستمر (Release Cadence)

| الدورة | التوقيت | الأنشطة |
|--------|:-------:|---------|
| **Minor Release** | كل أسبوعين | ميزات فرعية جديدة، وصفات إضافية، تحسينات واجهة المستخدم، إصلاح أخطاء طفيفة |
| **Hotfix Release** | حسب الحاجة (خلال 24-48 ساعة) | إصلاحات أمنية، أخطاء انهيار غير متوقعة، معالجة انقطاع APIs |
| **Major Release** | كل شهرين - 3 أشهر | ميزات ذكاء اصطناعي كبرى (مثل تحليل المكونات بالصور Vision AI)، دعم خطط الوجبات الأسبوعية والاشتراكات المتقدمة |
| **Dependency Update** | نهاية كل شهر | فحص تحديثات حزم Flutter و Dart، وتأكيد التوافق مع أحدث إصدارات iOS و Android SDKs |
