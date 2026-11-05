import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
  bool _deductIngredients = true;
  bool _pantryDetailsExpanded = false;
  final Set<String> _activeFlavorChips = {'crispy', 'balanced', 'repeat'};
  final TextEditingController _notesController = TextEditingController();

  final List<String> _ratingTexts = [
    'يحتاج لتعديل في المقادير • تجربة أولى',
    'مقبول • يحتاج لضبط النكهة',
    'جيد ولذيذ • عشاء عائلي مرضٍ',
    'شهي جداً • طبق مميز أحبه الجميع',
    'استثنائي ومبهر • إتقان تام وتوازن فائق ✨',
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

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

    // العودة الآمنة إلى الشاشة الرئيسية بدون أي شاشة سوداء
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final usedIngredients = widget.recipe.ingredients
        .where((i) => i.role != IngredientRole.staple)
        .toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: _finish,
          tooltip: 'إغلاق والعودة للرئيسية',
        ),
        centerTitle: true,
        title: Text(
          'إنجاز الطهي',
          style: GoogleFonts.cairo(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isDark ? AppColors.textPrimaryDark : AppColors.primary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          children: [
            // 1. Culinary Victory Header Pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : AppColors.secondaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.workspace_premium_rounded, size: 16, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Text(
                    'إنجاز طهوي استثنائي مكتمل 🎉',
                    style: GoogleFonts.cairo(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.accentGold : AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Recipe Headline
            Text(
              widget.recipe.title,
              textAlign: TextAlign.center,
              style: GoogleFonts.newsreader(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.primary,
                height: 1.25,
              ),
            ),

            const SizedBox(height: 6),

            // Subtitle Timing Pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.surfaceTint,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'أُنجزت في ${widget.recipe.cookMinutes + widget.recipe.prepMinutes} دقيقة • وتيرة وإتقان دقيق',
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // 2. Dish Showcase Hero Card (4:3 Aspect Ratio)
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 4 / 3,
                    child: CachedNetworkImage(
                      imageUrl: widget.recipe.heroImageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(color: AppColors.secondaryCream),
                      errorWidget: (context, url, error) => Container(
                        color: AppColors.secondaryCream,
                        child: const Icon(Icons.restaurant_rounded, size: 48, color: AppColors.secondary),
                      ),
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
                            Colors.black.withAlpha(20),
                            Colors.transparent,
                            Colors.black.withAlpha(180),
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                  ),
                  // Top Pill
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(230),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.people_outline_rounded, size: 14, color: AppColors.primary),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.recipe.servings} حصص عائلية',
                            style: GoogleFonts.manrope(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Bottom Verdict
                  Positioned(
                    bottom: 12,
                    left: 12,
                    right: 12,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'تقييم مائدة الشيف',
                              style: GoogleFonts.cairo(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white70,
                              ),
                            ),
                            Text(
                              'نكهة عطرية وقوام مثالي',
                              style: GoogleFonts.newsreader(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.camera_alt_rounded, size: 14, color: AppColors.primary),
                              const SizedBox(width: 4),
                              Text(
                                'صورة للطبق',
                                style: GoogleFonts.cairo(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // 3. 3-Bento Culinary Performance Stats
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.analytics_rounded, size: 18, color: AppColors.surfaceTint),
                          const SizedBox(width: 6),
                          Text(
                            'مؤشرات الأداء الطهوي',
                            style: GoogleFonts.newsreader(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primaryFixed,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'تقنية المستوى ٤',
                          style: GoogleFonts.manrope(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      // Stat 1: Time
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkBackground : AppColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'الوقت الفعلي',
                                style: GoogleFonts.cairo(fontSize: 10, color: AppColors.secondary),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${widget.recipe.cookMinutes} د',
                                style: GoogleFonts.newsreader(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                              Text(
                                'وتيرة مثالية',
                                style: GoogleFonts.manrope(fontSize: 9, color: AppColors.surfaceTint, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Stat 2: Precision
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkBackground : AppColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'دقة الإتقان',
                                style: GoogleFonts.cairo(fontSize: 10, color: AppColors.secondary),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '٩٦٪',
                                style: GoogleFonts.newsreader(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                              Text(
                                'نضج متزن',
                                style: GoogleFonts.manrope(fontSize: 9, color: AppColors.surfaceTint, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Stat 3: Zero Waste
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkBackground : AppColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'حفظ الهدر',
                                style: GoogleFonts.cairo(fontSize: 10, color: AppColors.secondary),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '٠.٣ كجم',
                                style: GoogleFonts.newsreader(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                              Text(
                                'استغلال أمثل',
                                style: GoogleFonts.manrope(fontSize: 9, color: AppColors.surfaceTint, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 4. Pantry Inventory Sync & Auto-Depletion Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          color: AppColors.secondaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.sync_alt_rounded, size: 18, color: AppColors.primary),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'مزامنة وخصم المؤونة المستخدمة',
                              style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${usedIngredients.length} مكونات سيتم تحديث رصيدها في مطبخك',
                              style: GoogleFonts.cairo(fontSize: 11, color: AppColors.secondary),
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
                  if (_deductIngredients) ...[
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () => setState(() => _pantryDetailsExpanded = !_pantryDetailsExpanded),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            _pantryDetailsExpanded ? 'إخفاء التفاصيل' : 'عرض المكونات المخصومة',
                            style: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
                          Icon(
                            _pantryDetailsExpanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                            size: 16,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                    if (_pantryDetailsExpanded) ...[
                      const SizedBox(height: 8),
                      ...usedIngredients.map((item) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkBackground : AppColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(item.name, style: GoogleFonts.cairo(fontSize: 11)),
                              Text('- ${item.amount}', style: GoogleFonts.manrope(fontSize: 11, color: AppColors.secondary)),
                            ],
                          ),
                        );
                      }),
                    ],
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 5. Chef Tasting Journal & Stars
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'مذكرة التذوق ورأي الشيف',
                    style: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.secondary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'كيف كانت نتيجة الطبق معك اليوم؟',
                    style: GoogleFonts.newsreader(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  // 5 Golden Saffron Stars
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      final starNum = index + 1;
                      return IconButton(
                        icon: Icon(
                          starNum <= _starRating ? Icons.star_rounded : Icons.star_outline_rounded,
                          color: AppColors.accentGold,
                          size: 34,
                        ),
                        onPressed: () => setState(() => _starRating = starNum),
                      );
                    }),
                  ),
                  Text(
                    _ratingTexts[_starRating - 1],
                    style: GoogleFonts.cairo(fontSize: 11, color: AppColors.secondary, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 14),

                  // Flavor Tags
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      _buildFlavorChip('crispy', 'قرمشة متقنة'),
                      _buildFlavorChip('balanced', 'نكهة متوازنة'),
                      _buildFlavorChip('spiced', 'بهار عطري غني'),
                      _buildFlavorChip('repeat', 'سأطهوه مجدداً'),
                      _buildFlavorChip('family', 'أعجب العائلة'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 6. Action Dock
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              icon: const Icon(Icons.auto_stories_rounded, size: 18),
              label: Text(
                'حفظ في سجل الطهي والعودة للرئيسية 📖',
                style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              onPressed: _finish,
            ),

            const SizedBox(height: 10),

            TextButton.icon(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.secondary,
                minimumSize: const Size(double.infinity, 44),
              ),
              icon: const Icon(Icons.home_outlined, size: 18),
              label: Text(
                'العودة للشاشة الرئيسية بدون حفظ',
                style: GoogleFonts.cairo(fontSize: 13),
              ),
              onPressed: _finish,
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFlavorChip(String key, String label) {
    final isSelected = _activeFlavorChips.contains(key);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () {
        setState(() {
          if (isSelected) {
            _activeFlavorChips.remove(key);
          } else {
            _activeFlavorChips.add(key);
          }
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : (isDark ? AppColors.surfaceDark : AppColors.surfaceContainerLow),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.cairo(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.white : (isDark ? Colors.white70 : AppColors.secondary),
          ),
        ),
      ),
    );
  }
}
