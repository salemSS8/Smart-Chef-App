import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/models/recipe.dart';
import 'auth_service.dart';

/// تعريف مسببات الحساسية المعتمدة في النظام التحريري
class AllergenInfo {
  final String id;
  final String nameAr;
  final String nameEn;
  final String icon;

  const AllergenInfo({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.icon,
  });
}

/// تعريف الأنظمة الغذائية التحريرية
class DietInfo {
  final String id;
  final String nameAr;
  final String nameEn;
  final String icon;

  const DietInfo({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.icon,
  });
}

class DietaryService {
  DietaryService._();

  static const String _allergensKey = 'smart_cook_user_allergens';
  static const String _dietsKey = 'smart_cook_user_diets';

  static const List<AllergenInfo> supportedAllergens = [
    AllergenInfo(id: 'gluten', nameAr: 'جلوتين (القمح والشعير)', nameEn: 'Gluten', icon: '🌾'),
    AllergenInfo(id: 'dairy', nameAr: 'مشتقات الألبان واللاكتوز', nameEn: 'Dairy / Lactose', icon: '🥛'),
    AllergenInfo(id: 'nuts', nameAr: 'مكسرات شجرية (لوز، جوز)', nameEn: 'Tree Nuts', icon: '🥜'),
    AllergenInfo(id: 'peanuts', nameAr: 'فول سوداني', nameEn: 'Peanuts', icon: '🥜'),
    AllergenInfo(id: 'eggs', nameAr: 'البيض', nameEn: 'Eggs', icon: '🥚'),
    AllergenInfo(id: 'seafood', nameAr: 'مأكولات بحرية وأسماك', nameEn: 'Seafood & Fish', icon: '🐟'),
    AllergenInfo(id: 'soy', nameAr: 'فول الصويا', nameEn: 'Soy', icon: '🌱'),
    AllergenInfo(id: 'sesame', nameAr: 'السمسم', nameEn: 'Sesame', icon: '🌿'),
  ];

  static const List<DietInfo> supportedDiets = [
    DietInfo(id: 'halal', nameAr: 'حلال 100%', nameEn: 'Halal', icon: '✨'),
    DietInfo(id: 'keto', nameAr: 'كيتو منخفض الكارب', nameEn: 'Keto', icon: '🥑'),
    DietInfo(id: 'vegetarian', nameAr: 'نباتي (Vegetarian)', nameEn: 'Vegetarian', icon: '🥗'),
    DietInfo(id: 'vegan', nameAr: 'نباتي صرف (Vegan)', nameEn: 'Vegan', icon: '🌱'),
    DietInfo(id: 'high_protein', nameAr: 'عالي البروتين للرياضيين', nameEn: 'High Protein', icon: '💪'),
    DietInfo(id: 'sugar_free', nameAr: 'خالي من السكر المكرر', nameEn: 'Sugar Free', icon: '🍃'),
    DietInfo(id: 'low_sodium', nameAr: 'قليل الصوديوم والأملاح', nameEn: 'Low Sodium', icon: '🧂'),
  ];

  static Set<String> _activeAllergens = {};
  static Set<String> _activeDiets = {'halal'};

  static Set<String> get activeAllergens => Set.unmodifiable(_activeAllergens);
  static Set<String> get activeDiets => Set.unmodifiable(_activeDiets);

  /// تحميل التفضيلات المحفوظة عند بدء التطبيق
  static Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedAllergens = prefs.getStringList(_allergensKey);
      if (savedAllergens != null) {
        _activeAllergens = savedAllergens.toSet();
      }

      final savedDiets = prefs.getStringList(_dietsKey);
      if (savedDiets != null) {
        _activeDiets = savedDiets.toSet();
      }
    } catch (e) {
      debugPrint('Error loading dietary preferences: $e');
    }
  }

  /// حفظ وتحديث الحساسيات والأنظمة الغذائية محلياً وفي Supabase
  static Future<void> savePreferences({
    required Set<String> allergens,
    required Set<String> diets,
  }) async {
    _activeAllergens = Set.from(allergens);
    _activeDiets = Set.from(diets);

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_allergensKey, _activeAllergens.toList());
      await prefs.setStringList(_dietsKey, _activeDiets.toList());

      // مزامنة مع Supabase profiles
      final user = AuthService.activeUser;
      if (!user.isAnonymous && Supabase.instance.isInitialized) {
        final client = Supabase.instance.client;
        await client.from('profiles').upsert({
          'id': user.id,
          'allergens': _activeAllergens.toList(),
          'diets': _activeDiets.toList(),
          'updated_at': DateTime.now().toIso8601String(),
        });
      }
    } catch (e) {
      debugPrint('Error saving dietary preferences: $e');
    }
  }

  /// فحص هل الوصفة تتعارض مع حساسيات المستخدم المسجلة
  static List<String> detectConflicts(Recipe recipe) {
    if (_activeAllergens.isEmpty) return const [];

    final conflicts = <String>[];
    final fullText = '${recipe.title} ${recipe.tags.join(" ")} ${recipe.ingredients.map((i) => i.name).join(" ")}'.toLowerCase();

    for (final allergen in _activeAllergens) {
      if (allergen == 'gluten' && (fullText.contains('طحين') || fullText.contains('دقيق') || fullText.contains('خبز') || fullText.contains('قمح') || fullText.contains('معكرونة'))) {
        conflicts.add('جلوتين (دقيق / معكرونة)');
      }
      if (allergen == 'dairy' && (fullText.contains('حليب') || fullText.contains('جبن') || fullText.contains('قشطة') || fullText.contains('كريمة') || fullText.contains('زبدة'))) {
        conflicts.add('مشتقات ألبان (حليب / زبدة / جبن)');
      }
      if ((allergen == 'nuts' || allergen == 'peanuts') && (fullText.contains('فول سوداني') || fullText.contains('لوز') || fullText.contains('جوز') || fullText.contains('فستق') || fullText.contains('كاجو'))) {
        conflicts.add('مكسرات');
      }
      if (allergen == 'eggs' && (fullText.contains('بيض') || fullText.contains('صفار') || fullText.contains('بياض'))) {
        conflicts.add('بيض');
      }
      if (allergen == 'seafood' && (fullText.contains('سمك') || fullText.contains('جمبري') || fullText.contains('روبيان') || fullText.contains('سلمون') || fullText.contains('تونة'))) {
        conflicts.add('مأكولات بحرية');
      }
    }

    return conflicts;
  }
}
