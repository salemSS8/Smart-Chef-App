import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/recipe.dart';

enum MealSlot {
  breakfast('فطور 🌅', 'Breakfast'),
  lunch('غداء ☀️', 'Lunch'),
  dinner('عشاء 🌙', 'Dinner'),
  snack('وجبة خفيفة 🍎', 'Snack');

  final String labelAr;
  final String labelEn;
  const MealSlot(this.labelAr, this.labelEn);
}

class PlannedMeal {
  final int dayIndex; // 0: السبت, 1: الأحد, ..., 6: الجمعة
  final MealSlot slot;
  final Recipe recipe;

  const PlannedMeal({
    required this.dayIndex,
    required this.slot,
    required this.recipe,
  });

  Map<String, dynamic> toJson() => {
    'dayIndex': dayIndex,
    'slot': slot.name,
    'recipe': recipe.toJson(),
  };

  factory PlannedMeal.fromJson(Map<String, dynamic> json) => PlannedMeal(
    dayIndex: json['dayIndex'] as int,
    slot: MealSlot.values.firstWhere((e) => e.name == json['slot']),
    recipe: Recipe.fromJson(Map<String, dynamic>.from(json['recipe'] as Map)),
  );
}

class MealPlannerState {
  final List<PlannedMeal> meals;
  final int selectedDayIndex;

  const MealPlannerState({
    this.meals = const [],
    this.selectedDayIndex = 0,
  });

  MealPlannerState copyWith({
    List<PlannedMeal>? meals,
    int? selectedDayIndex,
  }) {
    return MealPlannerState(
      meals: meals ?? this.meals,
      selectedDayIndex: selectedDayIndex ?? this.selectedDayIndex,
    );
  }

  List<PlannedMeal> get mealsForSelectedDay =>
      meals.where((m) => m.dayIndex == selectedDayIndex).toList();

  int get totalCaloriesForSelectedDay {
    return mealsForSelectedDay.fold(0, (sum, m) => sum + m.recipe.calories);
  }
}

class MealPlannerNotifier extends StateNotifier<MealPlannerState> {
  static const String _storageKey = 'smart_cook_weekly_meal_plan_v1';

  MealPlannerNotifier() : super(const MealPlannerState()) {
    _loadFromStorage();
  }

  Future<void> _loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_storageKey);
      if (raw != null) {
        final list = (jsonDecode(raw) as List)
            .map((item) => PlannedMeal.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList();
        state = state.copyWith(meals: list);
      }
    } catch (_) {}
  }

  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = jsonEncode(state.meals.map((m) => m.toJson()).toList());
      await prefs.setString(_storageKey, raw);
    } catch (_) {}
  }

  void selectDay(int index) {
    state = state.copyWith(selectedDayIndex: index);
  }

  void addMeal({
    required int dayIndex,
    required MealSlot slot,
    required Recipe recipe,
  }) {
    final updated = List<PlannedMeal>.from(state.meals)
      ..removeWhere((m) => m.dayIndex == dayIndex && m.slot == slot)
      ..add(PlannedMeal(dayIndex: dayIndex, slot: slot, recipe: recipe));

    state = state.copyWith(meals: updated);
    _saveToStorage();
  }

  void removeMeal(int dayIndex, MealSlot slot) {
    final updated = List<PlannedMeal>.from(state.meals)
      ..removeWhere((m) => m.dayIndex == dayIndex && m.slot == slot);

    state = state.copyWith(meals: updated);
    _saveToStorage();
  }

  void clearWeek() {
    state = state.copyWith(meals: []);
    _saveToStorage();
  }

  /// التحقق من المكونات الناقصة في جدول الأسبوع وتوليد قائمة التسوق بنقرة واحدة
  int exportMissingIngredientsToShoppingList({
    required List<String> pantryIngredientNames,
    required void Function(String name, String amount) addToShopping,
  }) {
    final pantrySet = pantryIngredientNames.map((s) => s.trim().toLowerCase()).toSet();
    final neededIngredients = <String, String>{};

    for (final meal in state.meals) {
      for (final ing in meal.recipe.ingredients) {
        final cleanName = ing.name.trim();
        final lower = cleanName.toLowerCase();
        // إذا لم يكن المكون متوفراً في المطبخ
        if (!pantrySet.contains(lower)) {
          neededIngredients[cleanName] = ing.amount;
        }
      }
    }

    // إضافة كافة النواقص لقائمة التسوق
    for (final entry in neededIngredients.entries) {
      addToShopping(entry.key, entry.value);
    }

    return neededIngredients.length;
  }
}

final mealPlannerProvider =
    StateNotifierProvider<MealPlannerNotifier, MealPlannerState>((ref) {
  return MealPlannerNotifier();
});
