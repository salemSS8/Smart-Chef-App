# 06 — المصادقة والمزامنة

> **المدة المُقدَّرة:** 5–7 أيام
> **يعتمد على:** الملفات 03 + 04 + 05
> **الأولوية:** 🔴 عالية — أساس تجربة المستخدم عبر الأجهزة

---

## 1. استراتيجية المصادقة

### 1.1 المبدأ: «يعمل بدون حساب»

```
المستخدم يفتح التطبيق لأول مرة
    ↓
يستخدم كضيف (كل البيانات محلية)
    ↓
عند محاولة المزامنة أو ميزة تحتاج حسابًا:
    ↓
عرض شاشة تسجيل الدخول (غير إلزامية)
    ↓
عند التسجيل: ربط البيانات المحلية بالحساب
```

### 1.2 مزوّدو تسجيل الدخول

| المزوّد | المنصة | الأولوية |
|---------|--------|:--------:|
| Google | Android + iOS | 🔴 MVP |
| Apple | iOS (إلزامي) | 🔴 MVP |
| Email/Password | الكل | 🟠 MVP |
| مجهول (Anonymous) | الكل | 🔴 MVP |

---

## 2. تنفيذ المصادقة

### 2.1 خدمة المصادقة

```dart
// data/remote/auth_service.dart

class AuthService {
  final SupabaseClient _client;

  AuthService(this._client);

  User? get currentUser => _client.auth.currentUser;
  bool get isAuthenticated => currentUser != null;
  bool get isAnonymous => currentUser?.isAnonymous ?? true;

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  /// تسجيل الدخول بـ Google
  Future<AuthResponse> signInWithGoogle() async {
    return _client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'com.smartcook.app://callback',
    );
  }

  /// تسجيل الدخول بـ Apple
  Future<AuthResponse> signInWithApple() async {
    return _client.auth.signInWithOAuth(
      OAuthProvider.apple,
      redirectTo: 'com.smartcook.app://callback',
    );
  }

  /// تسجيل الدخول بالبريد
  Future<AuthResponse> signInWithEmail(String email, String password) async {
    return _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// إنشاء حساب بالبريد
  Future<AuthResponse> signUpWithEmail(String email, String password) async {
    return _client.auth.signUp(
      email: email,
      password: password,
    );
  }

  /// تسجيل دخول مجهول
  Future<AuthResponse> signInAnonymously() async {
    return _client.auth.signInAnonymously();
  }

  /// ربط حساب مجهول بحساب حقيقي
  Future<UserResponse> linkAnonymousToEmail(String email, String password) async {
    return _client.auth.updateUser(
      UserAttributes(email: email, password: password),
    );
  }

  /// تسجيل الخروج
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  /// حذف الحساب (إلزامي للمتاجر)
  Future<void> deleteAccount() async {
    // 1. حذف بيانات المستخدم من الخادم
    await _client.rpc('delete_user_data');
    // 2. تسجيل الخروج
    await signOut();
  }
}
```

### 2.2 Provider المصادقة

```dart
// presentation/providers/auth_provider.dart

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  Stream<AuthState> build() {
    return ref.watch(authServiceProvider).authStateChanges;
  }

  Future<void> signInWithGoogle() async {
    try {
      await ref.read(authServiceProvider).signInWithGoogle();
      // بعد التسجيل: مزامنة البيانات المحلية
      await _syncLocalDataToCloud();
    } catch (e) {
      // معالجة الخطأ
    }
  }

  Future<void> signInWithApple() async {
    try {
      await ref.read(authServiceProvider).signInWithApple();
      await _syncLocalDataToCloud();
    } catch (e) {
      // معالجة الخطأ
    }
  }

  Future<void> signOut() async {
    await ref.read(authServiceProvider).signOut();
  }

  Future<void> deleteAccount() async {
    // 1. حذف البيانات المحلية
    await ref.read(databaseProvider).clearUserData();
    // 2. حذف الحساب من الخادم
    await ref.read(authServiceProvider).deleteAccount();
  }

  Future<void> _syncLocalDataToCloud() async {
    final syncService = ref.read(syncServiceProvider);
    await syncService.pushAllLocal();
  }
}
```

### 2.3 دالة حذف بيانات المستخدم (Supabase)

```sql
-- في الباك اند: RPC function
CREATE OR REPLACE FUNCTION delete_user_data()
RETURNS void AS $$
BEGIN
  DELETE FROM pantry_items WHERE user_id = auth.uid();
  DELETE FROM favorites WHERE user_id = auth.uid();
  DELETE FROM shopping_items WHERE user_id = auth.uid();
  DELETE FROM cook_sessions WHERE user_id = auth.uid();
  DELETE FROM ratings WHERE user_id = auth.uid();
  DELETE FROM meal_plan_entries WHERE user_id = auth.uid();
  DELETE FROM profiles WHERE id = auth.uid();
  -- حذف الصور من Storage
  -- يُنفَّذ عبر Edge Function أو trigger
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```

---

## 3. خدمة المزامنة (Sync Service)

### 3.1 المبدأ: Offline-first مع طابور عمليات

```
┌─────────────┐     ┌──────────┐     ┌───────────┐
│  واجهة      │ ←── │  Drift   │ ←→  │  طابور    │
│  المستخدم   │     │  (محلي)  │     │  المزامنة │
└─────────────┘     └──────────┘     └─────┬─────┘
                                           │
                                     ┌─────▼─────┐
                                     │  Supabase  │
                                     │  (بعيد)    │
                                     └───────────┘
```

### 3.2 خدمة المزامنة

```dart
// data/sync/sync_service.dart

class SyncService {
  final AppDatabase _db;
  final SupabaseClient _remote;
  final ConnectivityNotifier _connectivity;

  SyncService(this._db, this._remote, this._connectivity);

  /// إضافة عملية لطابور المزامنة
  Future<void> queueOperation({
    required String table,
    required String operation,
    required String recordId,
    Map<String, dynamic>? payload,
  }) async {
    await _db.syncDao.addToQueue(SyncQueueCompanion(
      tableName: Value(table),
      recordId: Value(recordId),
      operation: Value(operation),
      payload: Value(jsonEncode(payload ?? {})),
      createdAt: Value(DateTime.now()),
    ));

    // محاولة المزامنة فورًا إن كان هناك اتصال
    if (await _connectivity.isConnected) {
      await _processQueue();
    }
  }

  /// معالجة الطابور
  Future<void> _processQueue() async {
    final pending = await _db.syncDao.getPending();

    for (final item in pending) {
      try {
        await _executeOperation(item);
        await _db.syncDao.markSynced(item.id);
      } catch (e) {
        // إعادة المحاولة لاحقًا
        debugPrint('فشل مزامنة: ${item.tableName}/${item.recordId}: $e');
      }
    }
  }

  Future<void> _executeOperation(SyncQueueEntry item) async {
    final payload = jsonDecode(item.payload) as Map<String, dynamic>;

    switch (item.operation) {
      case 'insert':
      case 'update':
        await _remote.from(item.tableName).upsert(payload);
        break;
      case 'delete':
        await _remote
            .from(item.tableName)
            .delete()
            .eq('id', item.recordId);
        break;
    }
  }

  /// دفع كل البيانات المحلية (عند أول تسجيل دخول)
  Future<void> pushAllLocal() async {
    final userId = _remote.auth.currentUser!.id;

    // 1. المخزون
    final pantryItems = await _db.pantryDao.getAll();
    if (pantryItems.isNotEmpty) {
      await _remote.from('pantry_items').upsert(
        pantryItems.map((e) => e.toJson()..['user_id'] = userId).toList(),
      );
    }

    // 2. المفضلة
    final favorites = await _db.favoritesDao.getAll();
    if (favorites.isNotEmpty) {
      await _remote.from('favorites').upsert(
        favorites.map((e) => {'user_id': userId, 'recipe_id': e.recipeId}).toList(),
      );
    }

    // 3. قائمة التسوق
    final shopping = await _db.shoppingDao.getAll();
    if (shopping.isNotEmpty) {
      await _remote.from('shopping_items').upsert(
        shopping.map((e) => e.toJson()..['user_id'] = userId).toList(),
      );
    }
  }

  /// سحب البيانات من الخادم
  Future<void> pullFromCloud() async {
    final userId = _remote.auth.currentUser?.id;
    if (userId == null) return;

    // 1. المخزون
    final remotePantry = await _remote
        .from('pantry_items')
        .select()
        .eq('user_id', userId);
    await _db.pantryDao.upsertBatch(remotePantry);

    // 2. المفضلة
    final remoteFavorites = await _remote
        .from('favorites')
        .select()
        .eq('user_id', userId);
    await _db.favoritesDao.upsertBatch(remoteFavorites);

    // 3. التسوق
    final remoteShopping = await _remote
        .from('shopping_items')
        .select()
        .eq('user_id', userId);
    await _db.shoppingDao.upsertBatch(remoteShopping);
  }

  /// مزامنة المحتوى (وصفات + مكونات)
  Future<void> syncContent() async {
    final lastSync = await _db.getLastContentSync();

    final response = await _remote.functions.invoke(
      'content-sync',
      body: {
        'last_sync_at': lastSync?.toIso8601String(),
        'content_version': await _db.getContentVersion(),
      },
    );

    final data = jsonDecode(response.data);

    // حفظ المكونات المُحدَّثة
    if (data['ingredients'] != null) {
      await _db.ingredientDao.upsertBatch(data['ingredients']);
    }

    // حفظ الوصفات المُحدَّثة
    if (data['recipes'] != null) {
      await _db.recipeDao.upsertBatch(data['recipes']);
    }

    // تحديث وقت المزامنة
    await _db.setLastContentSync(DateTime.parse(data['sync_at']));
  }
}
```

### 3.3 مراقبة الاتصال

```dart
// core/network/connectivity_notifier.dart

@riverpod
class ConnectivityNotifier extends _$ConnectivityNotifier {
  @override
  Stream<bool> build() {
    return Connectivity()
        .onConnectivityChanged
        .map((results) => results.any((r) => r != ConnectivityResult.none));
  }
}

// مزامنة تلقائية عند عودة الاتصال
@riverpod
class AutoSyncNotifier extends _$AutoSyncNotifier {
  @override
  void build() {
    ref.listen(connectivityNotifierProvider, (prev, next) {
      next.whenData((isConnected) {
        if (isConnected && prev?.value == false) {
          // عاد الاتصال — مزامنة!
          ref.read(syncServiceProvider).processQueue();
        }
      });
    });
  }
}
```

---

## 4. حل التعارضات

### 4.1 قاعدة: «آخر كتابة تفوز» (Last Write Wins)

```dart
// للحقول البسيطة: المخزون، المفضلة
// نقارن updated_at:
// - إن كان المحلي أحدث → نرسل للخادم
// - إن كان البعيد أحدث → نحدّث المحلي

class ConflictResolver {
  static T resolveByTimestamp<T extends HasUpdatedAt>(T local, T remote) {
    if (local.updatedAt.isAfter(remote.updatedAt)) {
      return local;
    }
    return remote;
  }
}
```

### 4.2 الحذف الناعم

```dart
// لتجنب «عودة» العناصر المحذوفة:
// - نستخدم deleted_at بدل الحذف الفعلي
// - العناصر المحذوفة تُستبعد من الاستعلامات
// - تُنظَّف بعد 30 يومًا
```

---

## 5. التخزين الآمن للرموز

```dart
// core/services/secure_storage.dart

class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: 'refresh_token', value: token);
  }

  Future<String?> getRefreshToken() async {
    return _storage.read(key: 'refresh_token');
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
```

---

## 6. واجهة تسجيل الدخول

### 6.1 الشاشة الموجودة
- `auth_modal.dart` (6,014 bytes) — موجودة كويدجت

### 6.2 النقاط المطلوبة

```
✅ عرض كـ Bottom Sheet (ليس شاشة كاملة)
⬜ زر Google (مع أيقونة)
⬜ زر Apple (iOS فقط)
⬜ خيار «متابعة بدون حساب»
⬜ رسالة واضحة: «البيانات ستُحفظ على هذا الجهاز فقط»
⬜ ربط البيانات المحلية عند التسجيل
⬜ رسالة نجاح: «تمت المزامنة ✅»
```

---

## 7. متى يُعرض تسجيل الدخول؟

```dart
// لا يُعرض عند أول فتح!
// يُعرض عند:
enum AuthTrigger {
  syncRequest,         // المستخدم يطلب المزامنة
  secondDevice,        // إعداد → «استخدام على جهاز آخر»
  ratingSubmit,        // محاولة إرسال تقييم
  proSubscription,     // الاشتراك المدفوع
  exportData,          // تصدير البيانات
}
```

---

## 8. قائمة تحقق المرحلة

- [ ] إنشاء `AuthService` مع Google + Apple + Email + Anonymous
- [ ] إنشاء `AuthNotifier` (Riverpod)
- [ ] ترقية `auth_modal.dart` بالأزرار الحقيقية
- [ ] إعداد Deep Links (Android + iOS) لـ OAuth callback
- [ ] إنشاء `SyncService` مع طابور العمليات
- [ ] إنشاء `SyncQueue` table في Drift
- [ ] تنفيذ `pushAllLocal` (دفع البيانات عند أول تسجيل)
- [ ] تنفيذ `pullFromCloud` (سحب البيانات)
- [ ] تنفيذ `syncContent` (مزامنة الوصفات)
- [ ] إنشاء `ConnectivityNotifier` + مزامنة تلقائية
- [ ] إعداد `FlutterSecureStorage` للرموز
- [ ] تنفيذ حذف الحساب (إلزامي للمتاجر)
- [ ] اختبار: ضيف → يستخدم → يسجل → البيانات تظهر في Supabase
- [ ] اختبار: فقدان اتصال → إضافة مكونات → عودة اتصال → مزامنة
- [ ] اختبار: تسجيل على جهاز 1 → فتح جهاز 2 → البيانات موجودة
- [ ] اختبار: حذف حساب → كل البيانات تُحذف
