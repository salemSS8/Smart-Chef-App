# 🚀 خطة السبرنت السابع: تجهيز الإنتاج، أتمتة التوقيع، والنشر للمتاجر (Sprint 7 Plan)

## 🎯 الأهداف الرئيسية (Sprint Objectives)
1. **إعداد توقيع التطبيق الآمن (Keystore & Release Signing Configuration):**
   - تهيئة `android/app/build.gradle.kts` لقراءة ملف `key.properties` للتوقيع التلقائي لنسخة الإنتاج دون تسريب المفاتيح في نظام التتبع Git.
   - توفير ملف نموذجي `android/key.properties.example` مع التعليمات الواضحة لتوليد مفتاح `upload-keystore.jks`.
2. **تحسين الحجم وحماية الكود (R8 / Proguard Rules Optimization):**
   - إعداد `android/app/proguard-rules.pro` لحماية قواعد بيانات Drift SQLite، ومكتبات Network/Connectivity، ومكتبات التنبيهات، وضغط حجم الـ APK لتقليل حجم التحميل للمستخدمين.
3. **أتمتة الاختبارات والبناء (CI/CD Pipeline with GitHub Actions):**
   - إنشاء خط سير العمل الآلي `.github/workflows/build_and_test.yml` لفحص `flutter analyze`، وتشغيل حزمة الاختبارات `flutter test` تلقائياً، وبناء حزمة الإنتاج.
4. **التحقق من جاهزية البناء النهائي (Production Build Verification):**
   - تجميع حزمة الإنتاج `flutter build apk --release` للتأكد الحاسم من عدم وجود أي خطأ يمنع المستخدم من تثبيت التطبيق أو رفعه على Google Play Console / App Store Connect.
5. **إعداد التقرير الختامي للمشروع (Final Deliverable Report):**
   - توثيق كافة المراحل (Sprint 1 إلى 7) مع دليل التشغيل ومؤشرات الأداء.
