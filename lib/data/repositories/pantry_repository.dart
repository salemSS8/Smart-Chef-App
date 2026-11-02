import 'package:shared_preferences/shared_preferences.dart';

class PantryRepository {
  static const String _pantryKey = 'user_pantry_ingredients';
  static const String _favoritesKey = 'user_favorite_recipes';
  static const String _shoppingKey = 'user_shopping_items';

  /// تحميل معرفات المكونات المتوفرة في مطبخ المستخدم
  Future<Set<String>> getPantryIngredientIds() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_pantryKey);
    if (list == null || list.isEmpty) {
      // مكونات افتراضية مبهجة للمستخدم الجديد للبدء فوراً وتجربة المطابقة
      return {
        'ing_eggs',
        'ing_tomato',
        'ing_onion',
        'ing_bell_pepper',
      };
    }
    return list.toSet();
  }

  /// حفظ المكونات محلياً
  Future<void> savePantryIngredientIds(Set<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_pantryKey, ids.toList());
  }

  /// تحميل المفضلة
  Future<Set<String>> getFavoriteRecipeIds() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_favoritesKey);
    return list?.toSet() ?? {};
  }

  /// حفظ المفضلة
  Future<void> saveFavoriteRecipeIds(Set<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoritesKey, ids.toList());
  }

  /// تحميل عناصر قائمة التسوق
  Future<List<String>> getShoppingItems() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_shoppingKey) ?? [];
  }

  /// حفظ عناصر قائمة التسوق
  Future<void> saveShoppingItems(List<String> items) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_shoppingKey, items);
  }

  /// فحص اكتمال الترحيب
  Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboarding_completed') ?? false;
  }

  /// تعيين اكتمال الترحيب
  Future<void> setOnboardingCompleted(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', value);
  }

  /// تعيين لغة التطبيق المفضلة
  Future<void> setAppLanguage(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_language', lang);
  }

  /// جلب لغة التطبيق الحالية
  Future<String> getAppLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('app_language') ?? 'ar';
  }

  /// تعيين المطابخ المفضلة عالمياً
  Future<void> setPreferredCuisines(List<String> cuisines) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('preferred_cuisines', cuisines);
  }

  /// جلب المطابخ المفضلة
  Future<List<String>> getPreferredCuisines() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('preferred_cuisines') ?? ['خليجي', 'شامي', 'مصري', 'مغاربي'];
  }
}
