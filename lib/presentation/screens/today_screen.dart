import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/services/auth_service.dart';
import '../../core/theme/app_colors.dart';
import '../../data/mock/recipes_data.dart';
import '../providers/matching_provider.dart';
import '../providers/pantry_provider.dart';
import '../widgets/filters_bottom_sheet.dart';
import 'cook_mode_screen.dart';
import 'recipe_detail_screen.dart';
import 'notifications_screen.dart';

class TodayScreen extends ConsumerStatefulWidget {
  final VoidCallback onNavigateToPantry;

  const TodayScreen({super.key, required this.onNavigateToPantry});

  @override
  ConsumerState<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends ConsumerState<TodayScreen> {
  FilterCriteria _currentFilter = const FilterCriteria();
  final Set<String> _bookmarkedRecipeIds = {};

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

  void _toggleBookmark(String id) {
    setState(() {
      if (_bookmarkedRecipeIds.contains(id)) {
        _bookmarkedRecipeIds.remove(id);
      } else {
        _bookmarkedRecipeIds.add(id);
      }
    });
  }

  void _showLanguageSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceContainerLowest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'اختيار لغة التطبيق 🌍',
                style: GoogleFonts.newsreader(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Text('🇸🇦', style: TextStyle(fontSize: 24)),
                title: const Text('العربية (RTL) - الافتراضي', style: TextStyle(fontWeight: FontWeight.bold)),
                trailing: const Icon(Icons.check_circle_rounded, color: AppColors.primary),
                onTap: () => Navigator.pop(ctx),
              ),
              ListTile(
                leading: const Text('🇬🇧', style: TextStyle(fontSize: 24)),
                title: const Text('English (LTR)'),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('واجهة اللغة الإنجليزية قيد المزامنة الدولية')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final matching = ref.watch(matchingProvider);
    final pantry = ref.watch(pantryProvider);
    final activeUser = AuthService.activeUser;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Filter recipes based on pantry matching
    final filteredReady = matching.readyRecipes.where((r) {
      if (_currentFilter.maxMinutes != null && r.recipe.totalMinutes > _currentFilter.maxMinutes!) return false;
      if (_currentFilter.cuisines.isNotEmpty && !_currentFilter.cuisines.contains(r.recipe.cuisine)) return false;
      return true;
    }).toList();

    final filteredMissingOne = matching.missingOneRecipes.where((r) {
      if (_currentFilter.maxMinutes != null && r.recipe.totalMinutes > _currentFilter.maxMinutes!) return false;
      if (_currentFilter.cuisines.isNotEmpty && !_currentFilter.cuisines.contains(r.recipe.cuisine)) return false;
      return true;
    }).toList();

    final filteredPartial = matching.partialRecipes.where((r) {
      if (_currentFilter.maxMinutes != null && r.recipe.totalMinutes > _currentFilter.maxMinutes!) return false;
      if (_currentFilter.cuisines.isNotEmpty && !_currentFilter.cuisines.contains(r.recipe.cuisine)) return false;
      return true;
    }).toList();

    final allMatchedResults = [
      ...filteredReady,
      ...filteredMissingOne,
      ...filteredPartial,
    ];

    final displayRecipes = allMatchedResults.isNotEmpty
        ? allMatchedResults.map((m) => m.recipe).take(6).toList()
        : RecipesData.allRecipes.take(4).toList();

    final topMatchScore = allMatchedResults.isNotEmpty
        ? (allMatchedResults.first.score * 100).round()
        : 85;

    final activeCookingRecipe = displayRecipes.first;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Mirrored Sub-Header Bar (RTL context) matching Stitch 7587abbe77e247bb90fe48fe0c9962b8
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Brand Logo + Title
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withAlpha(30),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.eco_rounded,
                            color: AppColors.primaryFixed,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'سمارت كوك',
                              style: GoogleFonts.newsreader(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : AppColors.primary,
                                height: 1.1,
                              ),
                            ),
                            Text(
                              'دار المطبخ الذكي والأصيل',
                              style: GoogleFonts.manrope(
                                fontSize: 11,
                                color: isDark ? AppColors.textSecondaryDark : AppColors.secondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Actions: Language Pill + Notification with Badge + Profile Avatar
                    Row(
                      children: [
                        // Language selector pill
                        InkWell(
                          onTap: _showLanguageSelector,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            height: 36,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.surfaceDark : AppColors.surfaceContainerHigh,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.translate_rounded, size: 15, color: AppColors.primary),
                                const SizedBox(width: 4),
                                Text(
                                  'العربية (AR)',
                                  style: GoogleFonts.manrope(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white : AppColors.textPrimaryLight,
                                  ),
                                ),
                                const Icon(Icons.arrow_drop_down, size: 16, color: AppColors.secondary),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Notification icon with unread red badge
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                            );
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Stack(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: isDark ? AppColors.surfaceDark : AppColors.surfaceContainerLow,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.notifications_outlined,
                                  size: 20,
                                  color: isDark ? Colors.white70 : AppColors.textSecondaryLight,
                                ),
                              ),
                              Positioned(
                                top: 7,
                                right: 7,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: AppColors.danger,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Chef Profile Avatar
                        Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.person_rounded, color: Colors.white, size: 18),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 2. Editorial Greeting & Cooking Streak Banner matching Stitch
              Container(
                margin: const EdgeInsets.only(top: 6, bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.calendar_today_rounded, size: 14, color: AppColors.secondary),
                            const SizedBox(width: 6),
                            Text(
                              'صباح الطهي • ٨:١٥ ص',
                              style: GoogleFonts.manrope(
                                fontSize: 12,
                                color: isDark ? AppColors.textSecondaryDark : AppColors.secondary,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.surfaceDark : AppColors.secondaryContainer,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('🔥', style: TextStyle(fontSize: 12)),
                              const SizedBox(width: 4),
                              Text(
                                '١٤ يوماً من الطهي المستمر',
                                style: GoogleFonts.manrope(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? AppColors.accentGold : AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'أهلاً بك، ${activeUser.displayName ?? "الشيف الذكي"} 👨‍🍳',
                      style: GoogleFonts.newsreader(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.primary,
                        height: 1.2,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      'المؤونة جاهزة، والهواء يحمل نفحات الزعفران والأعشاب الطازجة. إليك ملهمات طهي اليوم.',
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              // 3. Live Simmering Card (الطهي الجاري) matching Stitch design
              Container(
                margin: const EdgeInsets.only(bottom: 24),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withAlpha(60),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Live status + Timer Pill
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: AppColors.primaryFixed,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'طهي حي مستمر الآن',
                              style: GoogleFonts.manrope(
                                color: AppColors.primaryFixed,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.hourglass_top_rounded, color: AppColors.primaryFixed, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                '٠٤:٢٧',
                                style: GoogleFonts.manrope(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Text(
                      activeCookingRecipe.title,
                      style: GoogleFonts.newsreader(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      'إضافة مرق الخضار الدافئ مغرفة تلو الأخرى مع التقليب الهادئ...',
                      style: GoogleFonts.manrope(
                        color: AppColors.primaryFixedDim,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Progress Track
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'الخطوة ٣ من ٦ (المرحلة الذهبية)',
                          style: GoogleFonts.manrope(color: AppColors.primaryFixed, fontSize: 11),
                        ),
                        Text(
                          '٦٥٪',
                          style: GoogleFonts.manrope(color: AppColors.primaryFixed, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: const LinearProgressIndicator(
                        value: 0.65,
                        backgroundColor: AppColors.primaryContainer,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryFixed),
                        minHeight: 6,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Bottom Row: Status + Continue Cooking CTA
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.local_fire_department_rounded, color: AppColors.primaryFixed, size: 18),
                            const SizedBox(width: 6),
                            Text(
                              'حرارة متوسطة: ٩٥° مئوية',
                              style: GoogleFonts.manrope(color: AppColors.primaryFixedDim, fontSize: 11),
                            ),
                          ],
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          icon: const Text('متابعة الطهي', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          label: const Icon(Icons.arrow_back_rounded, size: 16),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CookModeScreen(recipe: activeCookingRecipe),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 4. Live Pantry Match Section (وصفات توافق مؤونتك)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            'وصفات توافق مؤونتك',
                            style: GoogleFonts.newsreader(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppColors.primary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.surfaceDark : AppColors.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '$topMatchScore٪',
                            style: GoogleFonts.manrope(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: _openFilters,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.surfaceDark : AppColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.tune_rounded, size: 13, color: AppColors.primary),
                              const SizedBox(width: 3),
                              Text(
                                'تصفية',
                                style: GoogleFonts.cairo(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      InkWell(
                        onTap: widget.onNavigateToPantry,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'عرض الكل',
                              style: GoogleFonts.manrope(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            const Icon(Icons.chevron_left_rounded, size: 16, color: AppColors.primary),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                'مقترحات مصممة وفق ما يتوفر في ثلاجتك الآن',
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.secondary,
                ),
              ),

              const SizedBox(height: 14),

              // Recipe Cards Feed matching Stitch Card design
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: displayRecipes.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, idx) {
                  final recipe = displayRecipes[idx];
                  final isBookmarked = _bookmarkedRecipeIds.contains(recipe.id);

                  return Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark ? AppColors.borderDark : AppColors.borderLight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(isDark ? 30 : 6),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => RecipeDetailScreen(recipe: recipe)),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 16:9 Image with Scrim & Top Pills
                          AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                CachedNetworkImage(
                                  imageUrl: recipe.heroImageUrl,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(color: AppColors.secondaryCream),
                                  errorWidget: (context, url, error) => Container(
                                    color: AppColors.secondaryCream,
                                    child: const Icon(Icons.restaurant_rounded, color: AppColors.secondary),
                                  ),
                                ),
                                // Dark bottom gradient scrim
                                Positioned.fill(
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withAlpha(160),
                                        ],
                                        stops: const [0.5, 1.0],
                                      ),
                                    ),
                                  ),
                                ),

                                // Top Right: Dynamic Ingredients Matching Pill
                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: Builder(
                                    builder: (context) {
                                      final match = recipe.evaluateMatch(pantry);
                                      final isAllReady = match.isFullyReady;
                                      final isMissingOne = match.isMissingOne;

                                      return Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: isAllReady
                                              ? AppColors.primaryFixed
                                              : (isMissingOne ? AppColors.secondaryContainer : Colors.white.withAlpha(235)),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              isAllReady
                                                  ? Icons.check_circle_rounded
                                                  : (isMissingOne ? Icons.error_outline_rounded : Icons.inventory_2_outlined),
                                              size: 14,
                                              color: isAllReady
                                                  ? AppColors.primary
                                                  : (isMissingOne ? AppColors.tertiary : AppColors.primary),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              isAllReady
                                                  ? 'جاهزة للطهي الآن (${match.availableIngredients.length}/${recipe.ingredients.length})'
                                                  : (isMissingOne
                                                      ? 'ينقصك مكوّن واحد فقط'
                                                      : '${match.availableIngredients.length} من ${recipe.ingredients.length} متوفرة (${(match.score * 100).round()}%)'),
                                              style: GoogleFonts.manrope(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: isAllReady
                                                    ? AppColors.primary
                                                    : (isMissingOne ? AppColors.tertiary : AppColors.primary),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),

                                // Top Left: Bookmark Button
                                Positioned(
                                  top: 10,
                                  left: 10,
                                  child: InkWell(
                                    onTap: () => _toggleBookmark(recipe.id),
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withAlpha(200),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                                        size: 18,
                                        color: isBookmarked ? AppColors.accentGold : AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ),

                                // Bottom Row on Photo: Time & Difficulty
                                Positioned(
                                  bottom: 8,
                                  left: 12,
                                  right: 12,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.schedule_rounded, size: 14, color: Colors.white),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${recipe.totalMinutes} دقيقة',
                                            style: GoogleFonts.manrope(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Icon(Icons.restaurant_rounded, size: 14, color: Colors.white),
                                          const SizedBox(width: 4),
                                          Text(
                                            recipe.difficulty,
                                            style: GoogleFonts.manrope(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Card Body
                          Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${recipe.cuisine} • وجبة رئيسية',
                                      style: GoogleFonts.manrope(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.surfaceTint,
                                      ),
                                    ),
                                    Text(
                                      '${recipe.calories} سعرة حرارية',
                                      style: GoogleFonts.manrope(
                                        fontSize: 11,
                                        color: AppColors.secondary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  recipe.title,
                                  style: GoogleFonts.newsreader(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white : AppColors.textPrimaryLight,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  recipe.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.manrope(
                                    fontSize: 12,
                                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // Bottom Card Row: Ingredient Bubbles & CTA
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Wrap(
                                      spacing: 4,
                                      children: recipe.ingredients.take(3).map((ing) {
                                        return Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: isDark ? AppColors.cardDark : AppColors.surfaceContainerHigh,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            ing.name,
                                            style: GoogleFonts.manrope(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),

                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.surfaceContainerHigh,
                                        foregroundColor: AppColors.primary,
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                        elevation: 0,
                                      ),
                                      icon: const Icon(Icons.play_arrow_rounded, size: 16),
                                      label: const Text('بدء التحضير', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (_) => CookModeScreen(recipe: recipe)),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 28),

              // 5. Curated Terroirs / Global Culinary Traditions (أقاليم الطهي الأصيلة)
              Text(
                'أقاليم الطهي الأصيلة 🌍',
                style: GoogleFonts.newsreader(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.primary,
                ),
              ),
              Text(
                'رحلات تذوق موسمية عبر جغرافيا النكهات الأصيلة',
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.secondary,
                ),
              ),

              const SizedBox(height: 12),

              // Terroir 1: الشامي والمتوسطي
              _buildTerroirCard(
                title: 'المطبخ الشامي والمتوسطي',
                subtitle: '٢٤ وصفة موثقة • توابل الأرض والزيتون والزعتر البري',
                tag: 'شاميات ومتوسطيات',
                icon: Icons.local_florist_rounded,
                imageUrl: 'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=600&q=80',
                isDark: isDark,
              ),

              const SizedBox(height: 10),

              // Terroir 2: الياباني الموسمي
              _buildTerroirCard(
                title: 'المطبخ الياباني الموسمي (واشوكو)',
                subtitle: '١٨ وصفة معتمدة • مرق الداشي واليوزو والتناغم الهادئ',
                tag: 'فلسفة التناغم الياباني',
                icon: Icons.waves_rounded,
                imageUrl: 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?auto=format&fit=crop&w=600&q=80',
                isDark: isDark,
              ),

              const SizedBox(height: 24),

              // 6. Quick Kitchen Pantry Summary (إدارة وتحديث مؤونة المطبخ)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.kitchen_rounded, color: AppColors.primaryFixed, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'إدارة وتحديث مؤونة المطبخ',
                            style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${pantry.length} مكوناً مسجلاً • ٣ مكونات تنتهي صلاحيتها قريباً',
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              color: isDark ? AppColors.textSecondaryDark : AppColors.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_left_rounded, color: AppColors.primary),
                      onPressed: widget.onNavigateToPantry,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTerroirCard({
    required String title,
    required String subtitle,
    required String tag,
    required IconData icon,
    required String imageUrl,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 80,
              height: 80,
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, size: 14, color: AppColors.surfaceTint),
                    const SizedBox(width: 4),
                    Text(
                      tag,
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.surfaceTint,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  style: GoogleFonts.newsreader(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.primary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
