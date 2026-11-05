import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../providers/matching_provider.dart';
import '../providers/meal_planner_provider.dart';
import '../providers/pantry_provider.dart';
import '../providers/shopping_provider.dart';
import 'cook_mode_screen.dart';
import 'recipe_detail_screen.dart';

class MealPlannerScreen extends ConsumerStatefulWidget {
  const MealPlannerScreen({super.key});

  @override
  ConsumerState<MealPlannerScreen> createState() => _MealPlannerScreenState();
}

class _MealPlannerScreenState extends ConsumerState<MealPlannerScreen> {
  final List<String> _days = [
    'السبت',
    'الأحد',
    'الاثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
  ];

  void _showRecipePickerModal(BuildContext context, int dayIndex, MealSlot slot) {
    final allRecipes = ref.read(recipesProvider);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 0.92,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'اختر وجبة لـ (${slot.labelAr})',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        _days[dayIndex],
                        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Expanded(
                  child: ListView.separated(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: allRecipes.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, idx) {
                      final r = allRecipes[idx];
                      return ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: const BorderSide(color: AppColors.borderLight),
                        ),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            r.heroImageUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: 50,
                              height: 50,
                              color: AppColors.secondaryCream,
                              child: const Icon(Icons.restaurant, color: AppColors.primary),
                            ),
                          ),
                        ),
                        title: Text(r.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        subtitle: Text('${r.cuisine} • ${r.cookMinutes} دقيقة • ${r.calories} سعرة'),
                        trailing: const Icon(Icons.add_circle_outline_rounded, color: AppColors.primary),
                        onTap: () {
                          ref.read(mealPlannerProvider.notifier).addMeal(
                            dayIndex: dayIndex,
                            slot: slot,
                            recipe: r,
                          );
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: AppColors.primary,
                              content: Text('تمت إضافة "${r.title}" إلى جدول يوم ${_days[dayIndex]} 🗓️'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _exportToShoppingList() {
    final pantry = ref.read(pantryProvider);
    final pantryNames = pantry.toList();

    final addedCount = ref.read(mealPlannerProvider.notifier).exportMissingIngredientsToShoppingList(
      pantryIngredientNames: pantryNames,
      addToShopping: (name, amount) {
        ref.read(shoppingProvider.notifier).addItem(
          '$name ($amount)',
          fromRecipe: 'مخطط الوجبات الأسبوعي',
        );
      },
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.shopping_cart_checkout_rounded, color: AppColors.primary, size: 28),
            SizedBox(width: 10),
            Text('قائمة التسوق جاهزة! 🛒', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          addedCount > 0
              ? 'تم فحص جدول الوجبات الأسبوعي ومقارنته بمطبخك، وتمت إضافة $addedCount صنفاً ناقصاً بنجاح إلى قائمة مشترياتك!'
              : 'رائع جداً! كافة مكونات وجباتك المخططة لهذا الأسبوع متوفرة بالفعل في مطبخك ومؤنتك.',
          style: const TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final plannerState = ref.watch(mealPlannerProvider);
    final selectedDay = plannerState.selectedDayIndex;
    final mealsForDay = plannerState.mealsForSelectedDay;

    return Scaffold(
      appBar: AppBar(
        title: const Text('مخطط الوجبات الأسبوعي 🗓️', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep_rounded),
            tooltip: 'إفراغ الجدول',
            onPressed: () {
              ref.read(mealPlannerProvider.notifier).clearWeek();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // شريط الأيام الأفقي
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: AppColors.borderLight)),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: List.generate(_days.length, (idx) {
                  final isSelected = selectedDay == idx;
                  final dayMealsCount = plannerState.meals.where((m) => m.dayIndex == idx).length;

                  return Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: ChoiceChip(
                      label: Row(
                        children: [
                          Text(_days[idx]),
                          if (dayMealsCount > 0) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.accentGold : AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '$dayMealsCount',
                                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ],
                      ),
                      selected: isSelected,
                      selectedColor: AppColors.primary,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textPrimaryLight,
                        fontWeight: FontWeight.bold,
                      ),
                      backgroundColor: AppColors.surfaceCream,
                      side: BorderSide(color: isSelected ? AppColors.primary : AppColors.borderLight),
                      onSelected: (_) => ref.read(mealPlannerProvider.notifier).selectDay(idx),
                    ),
                  );
                }),
              ),
            ),
          ),

          // إحصائية السعرات لليوم
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'جدول وجبات ${_days[selectedDay]}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryCream,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.local_fire_department_rounded, size: 16, color: AppColors.accentTomato),
                      const SizedBox(width: 4),
                      Text(
                        '${plannerState.totalCaloriesForSelectedDay} سعرة',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // بطاقات الوجبات الأربع لليوم
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              children: MealSlot.values.map((slot) {
                final planned = mealsForDay.where((m) => m.slot == slot).firstOrNull;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: planned != null
                      ? Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    slot.labelAr,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                      fontSize: 13,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close_rounded, size: 18, color: Colors.grey),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: () {
                                      ref.read(mealPlannerProvider.notifier).removeMeal(selectedDay, slot);
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => RecipeDetailScreen(recipe: planned.recipe)),
                                  );
                                },
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        planned.recipe.heroImageUrl,
                                        width: 64,
                                        height: 64,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Container(
                                          width: 64,
                                          height: 64,
                                          color: AppColors.secondaryCream,
                                          child: const Icon(Icons.restaurant, color: AppColors.secondary),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            planned.recipe.title,
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${planned.recipe.cuisine} • ${planned.recipe.cookMinutes} د • ${planned.recipe.calories} ك/سعرة',
                                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.accentGold,
                                        foregroundColor: AppColors.darkBackground,
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                        minimumSize: Size.zero,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (_) => CookModeScreen(recipe: planned.recipe)),
                                        );
                                      },
                                      child: const Text('طهي 🍳', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () => _showRecipePickerModal(context, selectedDay, slot),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: AppColors.secondaryCream,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.add, color: AppColors.primary, size: 20),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'إضافة ${slot.labelAr}',
                                    style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 14),
                                  ),
                                ),
                                const Icon(Icons.chevron_left_rounded, color: Colors.grey),
                              ],
                            ),
                          ),
                        ),
                );
              }).toList(),
            ),
          ),

          // زر توليد قائمة التسوق
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.borderLight)),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                icon: const Icon(Icons.shopping_cart_checkout_rounded, size: 20),
                label: const Text(
                  'توليد قائمة التسوق من المخطط الأسبوعي 🛒',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                onPressed: plannerState.meals.isEmpty ? null : _exportToShoppingList,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
