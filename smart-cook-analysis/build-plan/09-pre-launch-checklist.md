# 09 — قائمة ما قبل الإطلاق

> **المدة المُقدَّرة:** 5–7 أيام
> **يعتمد على:** الملفات 01–08 (كل ما سبق)
> **الأولوية:** 🔴 عالية — لا إطلاق بدون إتمام هذه القائمة

---

## 1. الأداء والتحسين

### 1.1 قائمة فحص الأداء

- [ ] **بدء التشغيل < 2 ثانية** على جهاز متوسط
  ```
  القياس: flutter run --trace-startup
  التحسين: تأجيل التهيئات الثقيلة، Splash أصلي
  ```

- [ ] **التمرير 60fps** بدون تقطيع
  ```
  القياس: Flutter DevTools → Performance
  التحسين: ListView.builder، const widgets، RepaintBoundary
  ```

- [ ] **حجم التطبيق < 50MB** (بدون الأصول المُحمَّلة)
  ```
  القياس: flutter build apk --analyze-size
  التحسين: App Bundles، ضغط الصور، tree-shaking
  ```

- [ ] **المطابقة < 300ms** لـ 10,000 وصفة
  ```
  القياس: اختبار أداء مخصص
  التحسين: Isolate، فهرس معكوس، bitset
  ```

- [ ] **استهلاك البطارية** في وضع الطهي مقبول
  ```
  القياس: Battery Historian أو DevTools
  التحسين: تقليل إعادة البناء، مؤقتات فعالة
  ```

### 1.2 تحسين الصور

```dart
// قبل الإطلاق: التأكد من:
// 1. الصور بصيغة WebP (حجم أقل 25-35%)
// 2. مقاسات مناسبة (لا 4K لبطاقة صغيرة)
// 3. BlurHash/ThumbHash لكل صورة
// 4. cached_network_image مع fadeIn
// 5. precacheImage للصور المهمة
```

### 1.3 التشويش (Obfuscation)

```powershell
flutter build apk --obfuscate --split-debug-info=build/debug-info
flutter build appbundle --obfuscate --split-debug-info=build/debug-info
flutter build ipa --obfuscate --split-debug-info=build/debug-info
```

---

## 2. الأمان

### 2.1 قائمة فحص الأمان

- [ ] **لا مفاتيح API في الكود المصدري**
  ```bash
  # بحث سريع
  grep -r "sk_live\|secret\|password\|api_key" lib/
  # يجب أن يكون فارغًا
  ```

- [ ] **HTTPS فقط** — لا HTTP
  ```
  التحقق: كل URLs تبدأ بـ https://
  Android: android:usesCleartextTraffic="false"
  iOS: NSAppTransportSecurity مُقيَّد
  ```

- [ ] **التخزين الآمن** — الرموز في FlutterSecureStorage
  ```
  لا SharedPreferences للرموز الحساسة
  ```

- [ ] **RLS مُفعَّل** على كل جداول المستخدم في Supabase
  ```sql
  -- التحقق
  SELECT tablename, rowsecurity FROM pg_tables
  WHERE schemaname = 'public';
  ```

- [ ] **تحديد المعدل (Rate Limiting)** لـ Edge Functions
  ```
  خاصة واجهات AI: حد 10 طلبات/دقيقة/مستخدم
  ```

- [ ] **فحص التبعيات**
  ```powershell
  flutter pub outdated
  # مراجعة التحذيرات الأمنية
  ```

- [ ] **حذف الحساب** يعمل كاملًا (إلزامي Apple + Google)

---

## 3. القانوني والخصوصية

### 3.1 المستندات المطلوبة

- [ ] **سياسة الخصوصية** (عربي + إنجليزي)
  ```
  - ما نجمعه ولماذا
  - كيف نحميه
  - حقوق المستخدم (حذف، تصدير، تصحيح)
  - مزودو الخدمات (Supabase, Google, Apple)
  - ملفات تعريف الارتباط/التتبع
  - الأطفال (13+)
  - معلومات الاتصال
  ```

- [ ] **شروط الاستخدام** (عربي + إنجليزي)
  ```
  - الاستخدام المقبول
  - إخلاء المسؤولية الغذائي والصحي
  - الملكية الفكرية
  - محتوى المستخدم
  - الإنهاء
  ```

- [ ] **إخلاء المسؤولية الغذائي**
  ```
  "معلومات التغذية والحساسية إرشادية وقد لا تكون دقيقة.
  لا تُغني عن استشارة الطبيب لأصحاب الحساسية الشديدة."
  ```

### 3.2 استضافة المستندات

```
الخيار 1: صفحات GitHub Pages (مجاني)
الخيار 2: صفحة ويب بسيطة على Supabase Storage
URL: https://smartcook.app/privacy
URL: https://smartcook.app/terms
```

### 3.3 التراخيص

- [ ] كل الخطوط مرخّصة للاستخدام التجاري
- [ ] كل الصور أصلية أو مرخّصة
- [ ] كل الأيقونات مرخّصة
- [ ] `licenses_page` في الإعدادات يعرض تراخيص الحزم

---

## 4. إعداد المتاجر

### 4.1 Google Play Console

- [ ] إنشاء حساب مطوّر ($25 مرة واحدة)
- [ ] إنشاء التطبيق
- [ ] ملء المعلومات:
  ```
  - الاسم: طاهي ذكي - Smart Cook
  - الوصف القصير (80 حرف)
  - الوصف الكامل (4000 حرف)
  - الفئة: Food & Drink
  - التقييم العمري: IARC
  - سياسة الخصوصية URL
  - معلومات الاتصال
  ```
- [ ] لقطات الشاشة:
  ```
  - هاتف: 2-8 لقطات (1080×1920 أو أعلى)
  - جهاز لوحي 7": اختياري
  - جهاز لوحي 10": اختياري
  - رسم بياني للميزات: 1024×500
  - أيقونة: 512×512
  ```
- [ ] إعداد Data Safety (ملصق الخصوصية)
- [ ] إعداد App Signing by Google Play
- [ ] إعداد Internal Testing track

### 4.2 Apple App Store Connect

- [ ] إنشاء حساب مطوّر ($99/سنة)
- [ ] إنشاء App ID
- [ ] إنشاء Provisioning Profiles
- [ ] إنشاء التطبيق في App Store Connect
- [ ] ملء المعلومات:
  ```
  - الاسم
  - الوصف
  - الكلمات المفتاحية (100 حرف)
  - الفئة: Food & Drink
  - التقييم العمري
  - سياسة الخصوصية URL
  - App Privacy (ملصق الخصوصية)
  ```
- [ ] لقطات الشاشة:
  ```
  - iPhone 6.9": إلزامي (1320×2868)
  - iPhone 6.7": إلزامي (1290×2796)
  - iPhone 6.5": إلزامي (1284×2778)
  - iPad Pro 13": إن أُضيف دعم iPad
  ```
- [ ] Review Information:
  ```
  - حساب اختبار (بريد + كلمة مرور)
  - ملاحظات للمراجع
  ```

---

## 5. الوصولية (Accessibility)

- [ ] **قارئ الشاشة** (TalkBack/VoiceOver)
  ```
  - كل صورة لها semanticLabel
  - كل زر له tooltip
  - ترتيب التنقل منطقي
  ```

- [ ] **تكبير الخط**
  ```
  - النصوص تستجيب لإعداد النظام
  - لا نص يُقطع عند تكبير 200%
  ```

- [ ] **التباين** WCAG AA
  ```
  - نسبة تباين النص ≥ 4.5:1
  - نسبة تباين العناصر التفاعلية ≥ 3:1
  ```

- [ ] **أهداف اللمس** ≥ 48dp × 48dp

---

## 6. التحليلات والرصد

### 6.1 إعداد Crashlytics/Sentry

```dart
// main.dart — إضافة معالج الأخطاء

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // معالجة أخطاء Flutter
  FlutterError.onError = (details) {
    // إرسال لـ Crashlytics/Sentry
    CrashReporter.report(details.exception, details.stack);
  };

  // معالجة أخطاء Dart غير المُلتقطة
  PlatformDispatcher.instance.onError = (error, stack) {
    CrashReporter.report(error, stack);
    return true;
  };

  runApp(const ProviderScope(child: SmartCookApp()));
}
```

### 6.2 الأحداث الأساسية

```dart
// core/services/analytics_service.dart

class AnalyticsService {
  void trackEvent(String name, [Map<String, dynamic>? params]) {
    // Firebase Analytics أو PostHog
  }

  // أحداث أساسية:
  void onboardingComplete() => trackEvent('onboarding_complete');
  void ingredientAdded(String method) =>
      trackEvent('ingredient_added', {'method': method});
  void suggestionsViewed(int count) =>
      trackEvent('suggestions_viewed', {'count': count});
  void recipeOpened(String id) =>
      trackEvent('recipe_opened', {'recipe_id': id});
  void cookStarted(String id) =>
      trackEvent('cook_started', {'recipe_id': id});
  void cookCompleted(String id, int durationMinutes) =>
      trackEvent('cook_completed', {
        'recipe_id': id,
        'duration_minutes': durationMinutes,
      });
  void paywallViewed() => trackEvent('paywall_viewed');
  void subscribed(String plan) =>
      trackEvent('subscribed', {'plan': plan});
}
```

### 6.3 احترام الخصوصية

```dart
// لا نتتبع إلا بموافقة:
// iOS: ATT (App Tracking Transparency)
// Android: موافقة صريحة عند أول تشغيل
// GDPR: خيار الرفض متاح دائمًا من الإعدادات
```

---

## 7. اختبار الأجهزة

### 7.1 قائمة الأجهزة

| الجهاز | النظام | الأولوية | الغرض |
|--------|--------|:--------:|-------|
| Samsung A14/A15 | Android 13+ | 🔴 | جهاز اقتصادي شائع |
| Samsung S24 | Android 14+ | 🟠 | رائد |
| Xiaomi Redmi Note 13 | Android 14+ | 🔴 | اقتصادي شائع |
| Huawei (بدون GMS) | HarmonyOS | 🟡 | حالة خاصة |
| iPhone 16 | iOS 18 | 🔴 | رائد |
| iPhone SE 3 | iOS 17 | 🔴 | شاشة صغيرة |
| iPhone 12 | iOS 16 | 🟠 | أقل إصدار مدعوم |
| iPad Air | iPadOS 17 | 🟡 | جهاز لوحي |

### 7.2 ما يُختبر على كل جهاز

```
✅ التثبيت والتشغيل
✅ RTL صحيح
✅ الخطوط تظهر (خاصة العربية)
✅ لا تقطيع نصوص
✅ 60fps في التمرير
✅ وضع الطهي (WakeLock)
✅ المؤقتات في الخلفية
✅ الإشعارات المحلية
✅ الوضع المظلم
✅ إدارة الذاكرة (لا تسريب)
```

---

## 8. Beta Testing

### 8.1 خطة Beta المغلق

```
الأسبوع 1: 50 مستخدم (فريق + أصدقاء)
الأسبوع 2: 200 مستخدم (قائمة الانتظار)
الأسبوع 3: 500 مستخدم (توسيع)
الأسبوع 4: 1000 مستخدم + تحليل البيانات

القنوات:
  - Android: Google Play Internal Testing → Closed Beta
  - iOS: TestFlight (حتى 10,000 مختبر)
```

### 8.2 جمع الملاحظات

```
1. نموذج ملاحظات داخل التطبيق
2. قناة Discord/Telegram مخصصة
3. مراقبة Crashlytics يوميًا
4. تحليل أنماط الاستخدام
5. مقابلات مع 10 مستخدمين
```

---

## 9. قائمة التحقق النهائية 🏁

### وظيفي
- [ ] كل الشاشات تعمل بدون أخطاء
- [ ] المطابقة تعمل Offline
- [ ] وضع الطهي كامل (مؤقتات + WakeLock)
- [ ] تسجيل الدخول + حذف الحساب
- [ ] قائمة التسوق تعمل
- [ ] المفضلة تعمل
- [ ] الإعدادات (حساسية، حمية) تعمل كفلاتر

### تقني
- [ ] لا أخطاء في `flutter analyze`
- [ ] التغطية ≥ 70%
- [ ] Crashlytics/Sentry مُعَدّ
- [ ] التحليلات مُعَدّة مع احترام الخصوصية
- [ ] التشويش مُفعَّل
- [ ] لا مفاتيح في الكود

### قانوني
- [ ] سياسة الخصوصية منشورة
- [ ] شروط الاستخدام منشورة
- [ ] إخلاء المسؤولية الغذائي ظاهر
- [ ] حذف الحساب يعمل
- [ ] IARC rating مُعبأ

### تجاري
- [ ] حساب Google Play مُعَدّ
- [ ] حساب App Store Connect مُعَدّ
- [ ] لقطات الشاشة جاهزة
- [ ] الأيقونة النهائية جاهزة
- [ ] الوصف والكلمات المفتاحية جاهزة
- [ ] فيديو المعاينة (اختياري)

### جودة
- [ ] اختبار 15+ جهاز
- [ ] Beta مع 500+ مستخدم
- [ ] تقييم Beta ≥ 4.0
- [ ] معدل خلو الأعطال ≥ 99.5%
- [ ] إصلاح كل الأخطاء الحرجة من Beta
