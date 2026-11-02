# 📋 خطة تنفيذ المرحلة الخامسة (Sprint 5 Execution Plan)
## السحابة، المصادقة، والمزامنة في الخلفية (Cloud, Authentication & Offline-First Sync)

> **المشروع:** تطبيق الطهي الذكي — Smart Cook  
> **المرحلة:** المرحلة الخامسة (Sprint 5: السحابة والمزامنة)  
> **الهدف:** بناء معمارية المصادقة المرنة (Guest First ➔ Email/OAuth) مع خدمة المزامنة السحابية في الخلفية عبر طابور `SyncQueue` بأسلوب Offline-First، والامتثال لشروط متاجر التطبيقات بتمكين المستخدم من حذف حسابه وبياناته بالكامل.  
> **المرجع التقني المعتمد:** وثائق [03-backend-setup.md](file:///d:/My%20Work/Flutter%20Projects/food%20app/smart-cook-analysis/build-plan/03-backend-setup.md) و [06-auth-and-sync.md](file:///d:/My%20Work/Flutter%20Projects/food%20app/smart-cook-analysis/build-plan/06-auth-and-sync.md).

---

## 🧭 خريطة تدفق المصادقة والمزامنة (Auth & Sync Architecture)

```mermaid
graph TD
    User["المستخدم الجديد"] -->|دخول فوري بدون إجبار| Guest["حساب مجهول محلي (Guest Mode)"]
    Guest -->|يعمل دون إنترنت 100%| LocalDB["قاعدة بيانات Drift SQLite"]
    
    LocalDB -->|تسجيل العمليات (Insert/Update/Delete)| Queue["طابور المزامنة (SyncQueue Table)"]
    
    Network["فاحص الاتصال (ConnectivityService)"] -->|متصل بالإنترنت Online| SyncWorker["محرك المزامنة (SyncService)"]
    Queue --> SyncWorker
    
    SyncWorker -->|مزامنة تدريجية في الخلفية| Supabase["سحابة Supabase Cloud"]
    
    Guest -.->|رغبة المزامنة عبر أجهزة متعددة| Upgrade["ترقية الحساب (Google / Apple / Email)"]
    Upgrade -->|دمج البيانات المحلية| Supabase
```

---

## 📝 تفصيل المهام التنفيذية الست (The 6 Execution Steps)

### 1️⃣ الخطوة 5.1: خدمة مراقبة الاتصال بالشبكة (Network Connectivity Service)
- **الملف المستهدف:**
  - `lib/core/network/network_connectivity_service.dart`
- **المهام:**
  - مراقبة حالة الاتصال بالإنترنت (WiFi، بيانات الهاتف، غير متصل) باستخدام حزمة `connectivity_plus`.
  - توفير دالة `isOnline` ومزود Riverpod تفاعلي `connectivityStatusProvider` لتحديث حالة المزامنة في الواجهة فورياً.

---

### 2️⃣ الخطوة 5.2: خدمة ونماذج المصادقة (Authentication Service & Notifier)
- **الملفات المستهدفة:**
  - `lib/core/services/auth_service.dart`
  - `lib/presentation/providers/auth_provider.dart`
- **المهام:**
  - **مبدأ "يعمل بدون حساب":** تفعيل وضع الضيف التلقائي (`Anonymous / Guest User`) ليعمل التطبيق بكامل طاقته محلياً دون إزعاج المستخدم بطلب تسجيل الدخول.
  - إتاحة تسجيل الدخول بالبريد الإلكتروني وكلمة المرور (`signInWithEmail`, `signUpWithEmail`).
  - تجهيز مسارات تسجيل الدخول بـ Google و Apple (`signInWithOAuth`).
  - **الامتثال الإلزامي لمتجري App Store و Google Play:** دالة `deleteAccountAndUserData()` التي تقوم بحذف كافة بيانات المستخدم المحلية من Drift وحذف سجله من الخادم السحابي.

---

### 3️⃣ الخطوة 5.3: محرك المزامنة السحابية في الخلفية (Offline-First Sync Engine)
- **الملف المستهدف:**
  - `lib/core/services/sync_service.dart`
- **المهام:**
  - الاستفادة من جدول `SyncQueue` و `SyncDao` المبنيين مسبقاً في Drift.
  - دالة `queueOperation({table, operation, recordId, payload})` لإضافة أي تغيير يجريه المستخدم إلى الطابور فوراً.
  - دالة `processQueue()` لمعالجة العمليات المتراكمة عند توفر اتصال بالإنترنت وإرسالها إلى Supabase.
  - معالجة النزاعات باستراتيجية **Last-Write-Wins (LWW)** مع إعادة المحاولة التلقائية حتى 3 مرات مع توثيق الأخطاء في `AppLogger`.

---

### 4️⃣ الخطوة 5.4: ربط عمليات المخزن والتسوق بطابور المزامنة
- **الملفات المستهدفة:**
  - `lib/presentation/providers/pantry_provider.dart`
  - `lib/presentation/providers/shopping_provider.dart`
- **المهام:**
  - عند إضافة أو حذف عنصر من المخزن أو قائمة التسوق، يتم إدراج أمر التحديث تلقائياً في `SyncQueue`.
  - ضمان استمرار عمل التطبيق بسرعة فائقة محلياً حتى في وضع الطيران الكامل دون أي تأخير.

---

### 5️⃣ الخطوة 5.5: ترقية شاشة الإعدادات وحالة المزامنة وحذف الحساب (Settings UI Wiring)
- **الملف المستهدف:**
  - `lib/presentation/screens/settings_screen.dart`
- **المهام:**
  - عرض حالة المستخدم الحالية (مستخدم ضيف 👤 أو بريد إلكتروني مسجل).
  - إضافة شارة حالة المزامنة الحية:
    - 🟢 *تمت المزامنة بنجاح*
    - 🟡 *يوجد عناصر بانتظار المزامنة (X عمليات)*
    - ⚪ *غير متصل بالإنترنت*
  - نافذة تسجيل الدخول/إنشاء حساب منبثقة وسريعة.
  - زر **«حذف الحساب وجميع البيانات»** مع رسالة تأكيد تحذيرية لحماية خصوصية المستخدم والالتزام بسياسات النشر.

---

### 6️⃣ الخطوة 5.6: الاختبارات الشاملة والتحقق من المزامنة (Sync & Auth Testing)
- **الملفات المستهدفة:**
  - `test/sync/sync_service_test.dart`
  - `test/auth/auth_service_test.dart`
- **المهام:**
  - اختبار إضافة العمليات إلى طابور `SyncQueue` ومعالجتها بنجاح.
  - اختبار عمل وضع الضيف والترقية السلسة للمصادقة.
  - اختبار حذف الحساب والبيانات بالكامل.
  - تشغيل `flutter test` والتحقق من نجاح كافة الاختبارات.
  - تشغيل `flutter analyze` بنتيجة خالية من أي مشاكل.

---

## ⏱️ الجدول الزمني المقترح لـ Sprint 5

| الخطوة | المهمة الرئيسية | المخرجات البرمجية |
|:------:|:----------------|:------------------|
| **5.1** | فاحص الاتصال بالشبكة | `network_connectivity_service.dart` |
| **5.2** | خدمة ومزود المصادقة | `auth_service.dart`, `auth_provider.dart` |
| **5.3** | محرك المزامنة التلقائي | `sync_service.dart` مع `SyncDao` |
| **5.4** | ربط العمليات بالمزامنة | تحديث مزودات `pantry` و `shopping` |
| **5.5** | شاشة الإعدادات وحذف الحساب | `settings_screen.dart` |
| **5.6** | الاختبارات والتحقق الشامل | `test/sync/sync_service_test.dart` |

---

## ✅ معايير القبول واكتمال المرحلة (Definition of Done)
1. التطبيق يعمل بكامل مزاياه بدون اشتراط تسجيل الدخول (Guest First).
2. أي عملية تعديل في وضع عدم الاتصال تُخزن في طابور `SyncQueue` وتُعالج تلقائياً فور عودة الاتصال.
3. ميزة "حذف الحساب والبيانات" تعمل بشكل سليم وتمتثل لمتطلبات متجري Google Play و App Store.
4. مؤشر المزامنة في شاشة الإعدادات يعكس الحالة الحقيقية للشبكة والطابور.
5. اجتياز كافة اختبارات الوحدة والتكامل، وتحقيق `flutter analyze: No issues found!`.
