# 05 — الوصفات ووضع الطهي والتسوق

> **المدة المُقدَّرة:** 5–7 أيام
> **يعتمد على:** الملف 04 (الميزات الأساسية)
> **الأولوية:** 🔴 عالية — التجربة الأساسية

---

## 1. شاشة تفاصيل الوصفة — الترقية

### 1.1 الحالة الحالية
- الشاشة موجودة: `recipe_detail_screen.dart` (16,399 bytes)
- تعمل ببيانات Mock

### 1.2 الترقية المطلوبة

#### Repository الوصفات

```dart
// data/repositories/recipe_repository_impl.dart

class RecipeRepositoryImpl implements IRecipeRepository {
  final RecipeDao _localDao;
  final SupabaseClient _remote;

  RecipeRepositoryImpl(this._localDao, this._remote);

  @override
  Future<RecipeWithDetails?> getById(String id) async {
    // 1. محلي أولًا (Offline-first)
    final local = await _localDao.getFullRecipe(id);
    if (local != null) return local;

    // 2. من الخادم إن لم يوجد محليًا
    try {
      final response = await _remote
          .from('recipes')
          .select('*, recipe_ingredients(*), recipe_steps(*)')
          .eq('id', id)
          .single();

      final recipe = RecipeWithDetails.fromJson(response);

      // حفظ محليًا للمرة القادمة
      await _localDao.upsertRecipe(recipe);

      return recipe;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<RecipeWithIngredients>> getAllWithIngredients({
    String? cuisine,
    int? maxMinutes,
    int? maxDifficulty,
    List<String>? mealTypes,
    List<String>? excludeAllergens,
    List<String>? excludeDiets,
  }) async {
    // دائمًا من المحلي (Offline-first)
    return _localDao.getFilteredRecipesWithIngredients(
      cuisine: cuisine,
      maxMinutes: maxMinutes,
      maxDifficulty: maxDifficulty,
    );
  }
}
```

#### Provider تفاصيل الوصفة

```dart
// presentation/providers/recipe_detail_provider.dart

@riverpod
Future<RecipeWithDetails?> recipeDetail(
  RecipeDetailRef ref,
  String recipeId,
) async {
  final repo = ref.watch(recipeRepositoryProvider);
  return repo.getById(recipeId);
}

// تغيير عدد الأشخاص
@riverpod
class ServingsNotifier extends _$ServingsNotifier {
  @override
  int build(int baseServings) => baseServings;

  void increment() => state++;
  void decrement() {
    if (state > 1) state--;
  }

  /// تحويل المقادير حسب عدد الأشخاص
  double scaleAmount(double originalAmount, int baseServings) {
    return (originalAmount / baseServings) * state;
  }
}
```

### 1.3 ميزات صفحة الوصفة

```
✅ الصورة الرئيسية مع BlurHash
✅ العنوان + الوصف
✅ شارات: الوقت | الصعوبة | السعرات | المطبخ
✅ تغيير عدد الأشخاص (+ / -)
✅ قائمة المكونات مع إشارة «لديك ✅ / ينقصك ❌»
✅ الخطوات
⬜ زر «ابدأ الطهي» → وضع الطهي
⬜ زر «أضف الناقص للتسوق»
⬜ زر المفضلة (❤️)
⬜ زر المشاركة
```

---

## 2. وضع الطهي (Cook Mode) — الترقية

### 2.1 الحالة الحالية
- الشاشة موجودة: `cook_mode_screen.dart` (16,942 bytes)

### 2.2 المتطلبات الأساسية

```
1. خطوة واحدة في الشاشة — خط كبير ≥ 24sp
2. الشاشة لا تنطفئ (WakeLock)
3. مؤقتات مدمجة تعمل بالخلفية
4. أزرار كبيرة (التالي / السابق)
5. شريط تقدم الخطوات
6. اهتزاز عند انتهاء المؤقت
```

### 2.3 Provider وضع الطهي

```dart
// presentation/providers/cook_mode_provider.dart

@riverpod
class CookModeNotifier extends _$CookModeNotifier {
  @override
  CookModeState build(String recipeId) {
    // تفعيل WakeLock
    ref.onDispose(() {
      WakelockPlus.disable();
    });
    WakelockPlus.enable();

    return CookModeState(
      currentStep: 0,
      totalSteps: 0,
      timers: {},
      startedAt: DateTime.now(),
    );
  }

  void nextStep() {
    if (state.currentStep < state.totalSteps - 1) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  void goToStep(int step) {
    state = state.copyWith(currentStep: step);
  }

  // --- المؤقتات ---
  void startTimer(int stepIndex, int seconds) {
    final timerId = 'step_$stepIndex';
    final timer = CookTimer(
      id: timerId,
      totalSeconds: seconds,
      remainingSeconds: seconds,
      isRunning: true,
    );

    state = state.copyWith(
      timers: {...state.timers, timerId: timer},
    );

    // بدء العد التنازلي
    _startCountdown(timerId, seconds);
  }

  void _startCountdown(String timerId, int remaining) {
    Future.delayed(const Duration(seconds: 1), () {
      final timer = state.timers[timerId];
      if (timer == null || !timer.isRunning) return;

      final newRemaining = timer.remainingSeconds - 1;
      if (newRemaining <= 0) {
        // انتهى المؤقت!
        _onTimerComplete(timerId);
        return;
      }

      state = state.copyWith(
        timers: {
          ...state.timers,
          timerId: timer.copyWith(remainingSeconds: newRemaining),
        },
      );

      _startCountdown(timerId, newRemaining);
    });
  }

  void _onTimerComplete(String timerId) {
    // اهتزاز + إشعار محلي
    HapticFeedback.heavyImpact();

    // إشعار محلي (إن كان التطبيق في الخلفية)
    ref.read(localNotificationProvider).show(
      title: 'المؤقت انتهى! ⏰',
      body: 'حان وقت الخطوة التالية',
    );

    state = state.copyWith(
      timers: {
        ...state.timers,
        timerId: state.timers[timerId]!.copyWith(
          isRunning: false,
          remainingSeconds: 0,
        ),
      },
    );
  }

  void pauseTimer(String timerId) {
    final timer = state.timers[timerId];
    if (timer != null) {
      state = state.copyWith(
        timers: {
          ...state.timers,
          timerId: timer.copyWith(isRunning: false),
        },
      );
    }
  }

  // --- إكمال الطهي ---
  Future<void> completeCooking() async {
    await WakelockPlus.disable();

    // تسجيل جلسة الطهي
    final session = CookSession(
      id: const Uuid().v4(),
      recipeId: recipeId,
      startedAt: state.startedAt,
      completedAt: DateTime.now(),
    );
    await ref.read(cookSessionDaoProvider).insert(session);
  }
}

@freezed
class CookModeState with _$CookModeState {
  const factory CookModeState({
    required int currentStep,
    required int totalSteps,
    required Map<String, CookTimer> timers,
    required DateTime startedAt,
  }) = _CookModeState;
}

@freezed
class CookTimer with _$CookTimer {
  const factory CookTimer({
    required String id,
    required int totalSeconds,
    required int remainingSeconds,
    required bool isRunning,
  }) = _CookTimer;
}
```

### 2.4 شاشة إكمال الطهي

```dart
// الشاشة موجودة: cook_completed_screen.dart (8,345 bytes)
// الترقية:
// ✅ عرض مدة الطهي الفعلية
// ⬜ طلب التقييم (1-5 نجوم)
// ⬜ «نجحت الوصفة؟» (نعم/لا)
// ⬜ إمكانية التقاط صورة النتيجة
// ⬜ خيار إزالة المكونات المستخدمة من المخزون
// ⬜ اقتراح: «هل تريد إضافتها للمفضلة؟»
```

---

## 3. قائمة التسوق — الترقية

### 3.1 الحالة الحالية
- الشاشة موجودة: `shopping_screen.dart` (18,898 bytes)
- المزوّد موجود: `shopping_provider.dart` (3,354 bytes)

### 3.2 Provider التسوق (ترقية)

```dart
// presentation/providers/shopping_provider.dart — ترقية

@riverpod
class ShoppingNotifier extends _$ShoppingNotifier {
  @override
  Stream<List<ShoppingItemWithIngredient>> build() {
    final dao = ref.watch(shoppingDaoProvider);
    return dao.watchItems();
  }

  /// إضافة المكونات الناقصة من وصفة
  Future<void> addMissingFromRecipe(RecipeMatch match) async {
    final dao = ref.read(shoppingDaoProvider);

    for (final ingredientId in match.missingIngredientIds) {
      // جلب تفاصيل المكوّن للحصول على الكمية المطلوبة
      final recipeIngredient = match.recipe.ingredients
          .firstWhere((i) => i.ingredientId == ingredientId);

      await dao.addItem(ShoppingItemsCompanion(
        id: Value(const Uuid().v4()),
        ingredientId: Value(ingredientId),
        quantity: Value(recipeIngredient.amount),
        unit: Value(recipeIngredient.unit),
        sourceRecipeId: Value(match.recipe.id),
      ));
    }
  }

  /// تحديد/إلغاء عنصر كمُشترى
  Future<void> toggleChecked(String itemId) async {
    await ref.read(shoppingDaoProvider).toggleChecked(itemId);
  }

  /// إزالة عنصر
  Future<void> removeItem(String itemId) async {
    await ref.read(shoppingDaoProvider).removeItem(itemId);
  }

  /// مسح جميع المُشترَيات
  Future<void> clearChecked() async {
    await ref.read(shoppingDaoProvider).clearChecked();
  }

  /// نقل المُشترَيات للمخزون
  Future<void> moveCheckedToPantry() async {
    final checked = await ref.read(shoppingDaoProvider).getCheckedItems();
    final pantryDao = ref.read(pantryDaoProvider);

    for (final item in checked) {
      if (item.ingredientId != null) {
        await pantryDao.addItem(PantryItemsCompanion(
          id: Value(const Uuid().v4()),
          ingredientId: Value(item.ingredientId!),
          quantity: Value(item.quantity),
          unit: Value(item.unit),
          source: Value('shopping'),
          addedAt: Value(DateTime.now()),
        ));
      }
    }

    await ref.read(shoppingDaoProvider).clearChecked();
  }
}
```

### 3.3 ميزات قائمة التسوق

```
✅ عرض القائمة مع اسم المكوّن + الكمية
✅ تحديد كمُشترى (Checkbox)
⬜ تجميع حسب التصنيف (خضار، لحوم، ألبان...)
⬜ إضافة عنصر يدوي (غير مرتبط بمكوّن)
⬜ نقل المُشترَيات للمخزون تلقائيًا
⬜ ربط بالوصفة المصدر
⬜ مشاركة القائمة (نص)
```

---

## 4. المفضلة — الترقية

### 4.1 Provider المفضلة

```dart
// presentation/providers/favorites_provider.dart — ترقية

@riverpod
class FavoritesNotifier extends _$FavoritesNotifier {
  @override
  Stream<List<String>> build() {
    final dao = ref.watch(favoritesDaoProvider);
    return dao.watchFavoriteIds();
  }

  Future<void> toggle(String recipeId) async {
    final dao = ref.read(favoritesDaoProvider);
    final isFav = await dao.isFavorite(recipeId);

    if (isFav) {
      await dao.remove(recipeId);
    } else {
      await dao.add(recipeId);
      // اهتزاز لطيف
      HapticFeedback.lightImpact();
    }
  }

  Future<bool> isFavorite(String recipeId) async {
    return ref.read(favoritesDaoProvider).isFavorite(recipeId);
  }
}
```

---

## 5. الإشعارات المحلية (للمؤقتات)

```dart
// core/services/local_notification_service.dart

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _plugin;

  LocalNotificationService() : _plugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: false,
      requestSoundPermission: true,
    );
    const settings = InitializationSettings(android: android, iOS: ios);
    await _plugin.initialize(settings);
  }

  Future<void> show({
    required String title,
    required String body,
    int id = 0,
  }) async {
    const android = AndroidNotificationDetails(
      'cook_timer',
      'مؤقتات الطهي',
      channelDescription: 'إشعارات عند انتهاء مؤقت الطهي',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const ios = DarwinNotificationDetails(
      presentAlert: true,
      presentSound: true,
    );

    await _plugin.show(id, title, body,
        const NotificationDetails(android: android, iOS: ios));
  }

  Future<void> scheduleTimer({
    required int id,
    required String title,
    required Duration duration,
  }) async {
    // جدولة إشعار بعد مدة محددة
    await _plugin.zonedSchedule(
      id,
      title,
      'حان الوقت! ⏰',
      tz.TZDateTime.now(tz.local).add(duration),
      const NotificationDetails(
        android: AndroidNotificationDetails('cook_timer', 'مؤقتات الطهي'),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}
```

---

## 6. شاشة اليوم (Today) — الترقية

### 6.1 الحالة الحالية
- الشاشة موجودة: `today_screen.dart` (20,795 bytes)

### 6.2 المحتوى المطلوب

```
┌──────────────────────────────┐
│  🌤️ مرحبًا! ماذا نطبخ اليوم؟ │
├──────────────────────────────┤
│  🟢 جاهز الآن (X وصفات)      │
│  [بطاقة وصفة 1]              │
│  [بطاقة وصفة 2]              │
│  [بطاقة وصفة 3]              │
├──────────────────────────────┤
│  🟡 ينقصك قليل (Y وصفات)     │
│  [بطاقة وصفة + ناقص]         │
├──────────────────────────────┤
│  ⏰ مكونات ستنتهي قريبًا     │  ← V1
│  [مكوّن + أيام متبقية]        │
├──────────────────────────────┤
│  ⭐ المفضلة الأخيرة          │
│  [بطاقة وصفة]                │
└──────────────────────────────┘
```

---

## 7. قائمة تحقق المرحلة

- [ ] ربط `RecipeDetailScreen` بـ `RecipeRepositoryImpl`
- [ ] تفعيل تغيير عدد الأشخاص مع تحويل المقادير
- [ ] إضافة زر «أضف الناقص للتسوق»
- [ ] ترقية `CookModeScreen` بـ WakeLock + مؤقتات حقيقية
- [ ] إعداد إشعارات محلية للمؤقتات
- [ ] إنشاء `CookCompletedScreen` مع تسجيل الجلسة
- [ ] ترقية `ShoppingScreen` مع تجميع وحذف
- [ ] إضافة «نقل للمخزون» من التسوق
- [ ] ترقية `FavoritesNotifier` بـ Drift
- [ ] ترقية `TodayScreen` بأقسام ديناميكية
- [ ] اختبار: فتح وصفة → بدء طهي → مؤقت → إكمال
- [ ] اختبار: إضافة ناقص للتسوق → شراء → نقل للمخزون
- [ ] اختبار: WakeLock يعمل ولا تنطفئ الشاشة
- [ ] اختبار: إشعار محلي عند انتهاء المؤقت في الخلفية
