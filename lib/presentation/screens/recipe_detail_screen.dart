import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/models/recipe.dart';
import '../providers/favorites_provider.dart';
import '../providers/pantry_provider.dart';
import '../providers/shopping_provider.dart';
import 'cook_mode_screen.dart';

class RecipeDetailScreen extends ConsumerStatefulWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  ConsumerState<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends ConsumerState<RecipeDetailScreen> {
  late int _servings;

  @override
  void initState() {
    super.initState();
    _servings = widget.recipe.servings;
  }

  void _incrementServings() {
    setState(() {
      _servings++;
    });
  }

  void _decrementServings() {
    if (_servings > 1) {
      setState(() {
        _servings--;
      });
    }
  }

  String _scaleAmount(String rawAmount, double multiplier) {
    if ((multiplier - 1.0).abs() < 0.01) return rawAmount;
    final regex = RegExp(r'^(\d+(?:\.\d+)?)\s*(.*)$');
    final match = regex.firstMatch(rawAmount.trim());
    if (match != null) {
      final numVal = double.tryParse(match.group(1)!);
      if (numVal != null) {
        final scaled = numVal * multiplier;
        final formatted = (scaled % 1 == 0) ? scaled.toInt().toString() : scaled.toStringAsFixed(1);
        final rest = match.group(2) ?? '';
        return '$formatted $rest'.trim();
      }
    }
    return rawAmount;
  }

  @override
  Widget build(BuildContext context) {
    final recipe = widget.recipe;
    final pantryIds = ref.watch(pantryProvider);
    final matchResult = recipe.evaluateMatch(pantryIds);
    final isFav = ref.watch(favoritesProvider).contains(recipe.id);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final servingsMultiplier = _servings / recipe.servings;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header Image matching 04 mockup
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textPrimaryLight, size: 18),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      color: isFav ? Colors.red : AppColors.textPrimaryLight,
                      size: 20,
                    ),
                    onPressed: () {
                      ref.read(favoritesProvider.notifier).toggleFavorite(recipe.id);
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: recipe.heroImageUrl,
                    httpHeaders: const {'User-Agent': 'SmartCook/1.0 (Android; food-recipe-app)'},
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(color: const Color(0xFFF7F2E8)),
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.primaryLight,
                      child: const Icon(Icons.restaurant, size: 50, color: AppColors.primary),
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withAlpha(60),
                          Colors.transparent,
                          Colors.black.withAlpha(120),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content body
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Verified Badge (matching 04 mockup)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          recipe.title,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (recipe.verified)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD8F2E4),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Row(
                            children: [
                              Text(
                                'موثّق',
                                style: TextStyle(
                                  color: Color(0xFF1E6B42),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.check, size: 14, color: Color(0xFF1E6B42)),
                            ],
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Subtitle info
                  Text(
                    '${recipe.totalMinutes} دقيقة   •   ${recipe.difficulty}   •   ${(recipe.calories * servingsMultiplier).round()} سعرة تقريباً',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Allergy Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDF8F2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'لا يحتوي مسببات حساسية شائعة',
                      style: TextStyle(
                        color: Color(0xFF1E6B42),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),

                  // Servings adjuster matching 04 mockup
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          _buildServingBtn(icon: Icons.add, onTap: _incrementServings),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Text(
                              '$_servings أفراد',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                          _buildServingBtn(icon: Icons.remove, onTap: _decrementServings),
                        ],
                      ),
                      const Text(
                        'المكونات',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // Ingredients List (Checkmark/Cross)
                  ...recipe.ingredients.map((ing) {
                    final isAvailable = ing.role == IngredientRole.staple ||
                        pantryIds.contains(ing.ingredientId);

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                isAvailable ? Icons.check : Icons.close,
                                color: isAvailable ? const Color(0xFF1E6B42) : const Color(0xFFC0392B),
                                size: 18,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  ing.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: isAvailable ? FontWeight.bold : FontWeight.w600,
                                    color: isAvailable
                                        ? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)
                                        : const Color(0xFFC0392B),
                                  ),
                                ),
                              ),
                              Text(
                                _scaleAmount(ing.amount, servingsMultiplier),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: servingsMultiplier != 1.0 ? FontWeight.bold : FontWeight.normal,
                                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                ),
                              ),
                            ],
                          ),
                          if (ing.substituteNote != null && !isAvailable) ...[
                            const SizedBox(height: 4),
                            Padding(
                              padding: const EdgeInsetsDirectional.only(start: 28),
                              child: Text(
                                'بديل مقبول: ${ing.substituteNote}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF266749),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(height: 4),
                          Divider(
                            height: 1,
                            color: isDark ? AppColors.borderDark : AppColors.borderLight,
                          ),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 20),

                  // Outlined button: + أضف الناقص إلى قائمة التسوق
                  if (matchResult.missingIngredients.isNotEmpty)
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary, width: 1.5),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {
                        ref.read(shoppingProvider.notifier).addMissingIngredients(
                              matchResult.missingIngredients,
                              recipe.title,
                            );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('تمت إضافة النواقص إلى قائمة التسوق بنجاح 🛒'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add_rounded, size: 20),
                      label: const Text('أضف الناقص إلى قائمة التسوق', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),

                  const SizedBox(height: 24),

                  // Steps preview
                  const Text('طريقة التحضير الخطوة بخطوة:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),

                  ...recipe.steps.map((st) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceDark : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: AppColors.primary,
                            child: Text('${st.stepNo}', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(st.text, style: const TextStyle(fontSize: 14, height: 1.5)),
                          ),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),

      // Sticky Bottom Button: ابدأ الطهي
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          border: Border(
            top: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
        ),
        child: SafeArea(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 54),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CookModeScreen(recipe: recipe),
                ),
              );
            },
            child: const Text('ابدأ الطهي', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }

  Widget _buildServingBtn({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: Icon(icon, size: 20, color: AppColors.textPrimaryLight),
      ),
    );
  }
}
