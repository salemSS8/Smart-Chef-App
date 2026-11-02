import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/models/recipe.dart';
import '../providers/pantry_provider.dart';

class CookCompletedScreen extends ConsumerStatefulWidget {
  final Recipe recipe;

  const CookCompletedScreen({super.key, required this.recipe});

  @override
  ConsumerState<CookCompletedScreen> createState() => _CookCompletedScreenState();
}

class _CookCompletedScreenState extends ConsumerState<CookCompletedScreen> {
  int _starRating = 5;
  bool _didRecipeSucceed = true;
  bool _deductIngredients = true;
  bool _photoAdded = false;

  void _finish() {
    if (_deductIngredients) {
      final idsToRemove = widget.recipe.ingredients
          .where((i) => i.role != IngredientRole.staple)
          .map((i) => i.ingredientId)
          .toSet();

      final currentPantry = ref.read(pantryProvider);
      // خصم المكونات المستخدمة من المخزن تلقائياً
      for (final id in idsToRemove) {
        if (currentPantry.contains(id)) {
          ref.read(pantryProvider.notifier).toggleIngredient(id);
        }
      }
    }

    Navigator.pop(context); // Close completed screen
    Navigator.pop(context); // Close cook mode
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('إتمام الطهي 🎉'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Celebration Icon
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppColors.secondaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.celebration_rounded, color: AppColors.secondary, size: 50),
            ),

            const SizedBox(height: 16),

            const Text(
              'تسلم الأيادي! بالهناء والشفاء 🍽️',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'أكملت تحضير «${widget.recipe.title}» بنجاح.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: AppColors.textSecondaryLight),
            ),

            const SizedBox(height: 24),

            // Star Rating
            const Text('كيف تقيّم الوصفة وطعمها؟', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final starNum = index + 1;
                return IconButton(
                  icon: Icon(
                    starNum <= _starRating ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: Colors.amber,
                    size: 36,
                  ),
                  onPressed: () {
                    setState(() {
                      _starRating = starNum;
                    });
                  },
                );
              }),
            ),

            const SizedBox(height: 20),

            // Did recipe succeed?
            const Text('هل نجحت الوصفة معك؟', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  label: const Text('نعم، كانت ممتازة! 😍'),
                  selected: _didRecipeSucceed,
                  selectedColor: AppColors.secondaryLight,
                  onSelected: (val) => setState(() => _didRecipeSucceed = true),
                ),
                const SizedBox(width: 10),
                ChoiceChip(
                  label: const Text('واجهت بعض الصعوبة'),
                  selected: !_didRecipeSucceed,
                  selectedColor: AppColors.dangerLight,
                  onSelected: (val) => setState(() => _didRecipeSucceed = false),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Photo upload placeholder
            InkWell(
              onTap: () {
                setState(() {
                  _photoAdded = !_photoAdded;
                });
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : const Color(0xFFFBF8F3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _photoAdded ? AppColors.secondary : AppColors.borderLight,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      _photoAdded ? Icons.check_circle_rounded : Icons.add_a_photo_outlined,
                      size: 36,
                      color: _photoAdded ? AppColors.secondary : AppColors.primary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _photoAdded ? 'تمت إضافة صورة طبقك الشهي بنجاح!' : '+ أضف صورة طبقك للذكرى أو المراجعة',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: _photoAdded ? AppColors.secondary : AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Deduct from Pantry switch
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.kitchen_rounded, color: AppColors.primary, size: 28),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'خصم المكونات من مطبخي تلقائياً',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'سيتم تحديث رصيد مطبخك وإزالة المكونات المستخدمة.',
                          style: TextStyle(fontSize: 12, color: AppColors.textSecondaryLight),
                        ),
                      ],
                    ),
                  ),
                  Switch.adaptive(
                    value: _deductIngredients,
                    activeTrackColor: AppColors.primary,
                    onChanged: (val) => setState(() => _deductIngredients = val),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: _finish,
              child: const Text('حفظ والعودة للرئيسية 🏠'),
            ),
          ],
        ),
      ),
    );
  }
}
