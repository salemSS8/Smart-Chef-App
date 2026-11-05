import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/models/recipe.dart';
import '../providers/matching_provider.dart';
import '../providers/pantry_provider.dart';
import '../providers/shopping_provider.dart';
import '../widgets/filters_bottom_sheet.dart';
import 'ai_inspire_screen.dart';
import 'recipe_detail_screen.dart';
import 'meal_planner_screen.dart';
import 'cookbooks_screen.dart';
import 'dietary_allergens_screen.dart';
import 'shopping_screen.dart';

class TodayScreen extends ConsumerStatefulWidget {
  final VoidCallback onNavigateToPantry;

  const TodayScreen({super.key, required this.onNavigateToPantry});

  @override
  ConsumerState<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends ConsumerState<TodayScreen> {
  FilterCriteria _currentFilter = const FilterCriteria();

  void _openFilters() {
    FiltersBottomSheet.show(
      context,
      initialCriteria: _currentFilter,
      onApply: (newCriteria) {
        setState(() {
          _currentFilter = newCriteria;
        });
      },
    );
  }

  void _openAiInspire() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AiInspireScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final matching = ref.watch(matchingProvider);
    final pantry = ref.watch(pantryProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Filter results if user applied filters
    final readyList = matching.readyRecipes.where((r) {
      if (_currentFilter.maxMinutes != null && r.recipe.totalMinutes > _currentFilter.maxMinutes!) {
        return false;
      }
      if (_currentFilter.cuisines.isNotEmpty && !_currentFilter.cuisines.contains(r.recipe.cuisine)) {
        return false;
      }
      return true;
    }).toList();

    final missingOneList = matching.missingOneRecipes.where((r) {
      if (_currentFilter.maxMinutes != null && r.recipe.totalMinutes > _currentFilter.maxMinutes!) {
        return false;
      }
      if (_currentFilter.cuisines.isNotEmpty && !_currentFilter.cuisines.contains(r.recipe.cuisine)) {
        return false;
      }
      return true;
    }).toList();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Header matching 03 mockup
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Filter & Shopping buttons
                  Row(
                    children: [
                      InkWell(
                        onTap: _openFilters,
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.surfaceDark : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: _currentFilter.maxMinutes != null || _currentFilter.cuisines.isNotEmpty
                                  ? AppColors.primary
                                  : AppColors.borderLight,
                              width: 1.5,
                            ),
                          ),
                          child: const Icon(Icons.tune_rounded, color: AppColors.textPrimaryLight, size: 22),
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ShoppingScreen()),
                          );
                        },
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.surfaceDark : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.borderLight, width: 1.5),
                          ),
                          child: const Icon(Icons.shopping_bag_outlined, color: AppColors.primary, size: 22),
                        ),
                      ),
                    ],
                  ),

                  // Greeting & Stats with Brand Avatar
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'مساء الخير',
                            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'لديك ${pantry.length} مكونات • ${matching.totalReadyCount > 0 ? matching.totalReadyCount : 18} وصفة جاهزة',
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withAlpha(30),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.asset(
                            'assets/image/icon-1024.png',
                            width: 44,
                            height: 44,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // Expiring Food Card matching 03 mockup
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2E241E) : const Color(0xFFFDF0E8),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFF39E75).withAlpha(120)),
                ),
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        // Scroll to or show recipes using milk
                      },
                      child: const Text(
                        'اعرضها',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'الحليب يحتاجك اليوم',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        SizedBox(height: 2),
                        Text(
                          '3 وصفات تستخدمه قبل أن ينتهي',
                          style: TextStyle(fontSize: 12, color: AppColors.textSecondaryLight),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.access_time_filled_rounded, color: AppColors.primary, size: 22),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Quick Editorial Hub
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildHubChip(
                      icon: Icons.calendar_month_rounded,
                      label: 'مخطط الوجبات 🗓️',
                      color: AppColors.primary,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const MealPlannerScreen()),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    _buildHubChip(
                      icon: Icons.menu_book_rounded,
                      label: 'كتيباتي 📚',
                      color: AppColors.accentGold,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const CookbooksScreen()),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    _buildHubChip(
                      icon: Icons.health_and_safety_rounded,
                      label: 'الحساسيات 🥗',
                      color: AppColors.accentTomato,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const DietaryAllergensScreen()),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    _buildHubChip(
                      icon: Icons.auto_awesome,
                      label: 'إلهام AI ✨',
                      color: AppColors.primary,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AiInspireScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // SECTION 1: جاهز الآن
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: widget.onNavigateToPantry,
                    child: const Text('عرض الكل', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                  ),
                  const Text(
                    'جاهز الآن',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Horizontal Cards matching 03 mockup
              SizedBox(
                height: 250,
                child: readyList.isEmpty
                    ? Center(
                        child: Text(
                          'أضف مكوناتك في المطبخ لتظهر الأطباق الجاهزة فوراً',
                          style: TextStyle(color: isDark ? Colors.white38 : Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: readyList.length,
                        itemBuilder: (context, index) {
                          final item = readyList[index];
                          return _buildReadyCard(item, isDark);
                        },
                      ),
              ),

              const SizedBox(height: 24),

              // SECTION 2: ينقصك مكوّن واحد
              const Align(
                alignment: AlignmentDirectional.centerEnd,
                child: Text(
                  'ينقصك مكوّن واحد',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 14),

              if (missingOneList.isNotEmpty)
                ...missingOneList.map((item) => _buildMissingOneCard(item, isDark))
              else
                Container(
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.center,
                  child: const Text('جميع الوصفات إما متوفرة بالكامل أو تحتاج مكونات إضافية'),
                ),

              const SizedBox(height: 20),

              // SECTION 3: ألهمني بالذكاء الاصطناعي (matching 03 mockup)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.primary.withAlpha(120), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withAlpha(isDark ? 20 : 10),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Button "جرّب"
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(80, 44),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _openAiInspire,
                      child: const Text('جرّب', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 14),

                    // Texts
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'ألهمني',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'طبق مبتكر من مكوناتك، مقترح بالذكاء الاصطناعي',
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Sparkle Icon
                    const Icon(Icons.auto_awesome, color: AppColors.primary, size: 28),
                  ],
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReadyCard(RecipeMatchResult match, bool isDark) {
    final recipe = match.recipe;
    final totalIng = recipe.ingredients.length;

    return Container(
      width: 200,
      margin: const EdgeInsetsDirectional.only(end: 14),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => RecipeDetailScreen(recipe: recipe)),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(isDark ? 30 : 8),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Image with "لديك X من X" badge
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: CachedNetworkImage(
                      imageUrl: recipe.heroImageUrl,
                      httpHeaders: const {'User-Agent': 'SmartCook/1.0 (Android; food-recipe-app)'},
                      height: 130,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(color: const Color(0xFFF7F2E8)),
                    ),
                  ),
                  PositionedDirectional(
                    bottom: 10,
                    start: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E6B42),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'لديك $totalIng من $totalIng',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      recipe.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${recipe.totalMinutes} د • ${recipe.difficulty} • ${recipe.servings} أفراد',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'موثّق • مجرّب',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E6B42),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMissingOneCard(RecipeMatchResult match, bool isDark) {
    final recipe = match.recipe;
    final missingName = match.missingIngredients.isNotEmpty ? match.missingIngredients.first.name : 'مكوّن';
    final substitute = match.missingIngredients.isNotEmpty && match.missingIngredients.first.substituteNote != null
        ? match.missingIngredients.first.substituteNote
        : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 30 : 6),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => RecipeDetailScreen(recipe: recipe)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Details on the left (RTL)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      recipe.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      alignment: WrapAlignment.end,
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        if (substitute != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE2F4EB),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'بديل: $substitute',
                              style: const TextStyle(color: Color(0xFF1E6B42), fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ),
                        InkWell(
                          onTap: () {
                            ref.read(shoppingProvider.notifier).addItem(
                              missingName,
                              fromRecipe: recipe.title,
                              ingredientId: match.missingIngredients.isNotEmpty
                                  ? match.missingIngredients.first.ingredientId
                                  : null,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('تمت إضافة $missingName إلى قائمة التسوق 🛒'),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFDEEEC),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFFE57373).withAlpha(120)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.add_shopping_cart_rounded, size: 12, color: Color(0xFFC0392B)),
                                const SizedBox(width: 4),
                                Text(
                                  'ينقصك: $missingName',
                                  style: const TextStyle(color: Color(0xFFC0392B), fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${recipe.totalMinutes} د • ${recipe.difficulty}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // Thumbnail on the right
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                  imageUrl: recipe.heroImageUrl,
                  httpHeaders: const {'User-Agent': 'SmartCook/1.0 (Android; food-recipe-app)'},
                  width: 76,
                  height: 76,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(color: const Color(0xFFF7F2E8)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHubChip({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderLight),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(8),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimaryLight),
            ),
          ],
        ),
      ),
    );
  }
}
