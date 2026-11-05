import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/text_normalizer.dart';
import '../../data/mock/ingredients_data.dart';
import '../../domain/models/ingredient.dart';
import '../providers/matching_provider.dart';
import '../providers/pantry_provider.dart';
import '../widgets/voice_input_sheet.dart';
import 'fridge_scanner_screen.dart';
import 'shopping_screen.dart';

class PantryScreen extends ConsumerStatefulWidget {
  final VoidCallback onViewRecipes;

  const PantryScreen({super.key, required this.onViewRecipes});

  @override
  ConsumerState<PantryScreen> createState() => _PantryScreenState();
}

class _PantryScreenState extends ConsumerState<PantryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'all';

  final List<Map<String, String>> _categories = [
    {'id': 'all', 'name': 'الكل'},
    {'id': 'vegetables', 'name': 'خضار وفواكه'},
    {'id': 'dairy', 'name': 'ألبان وبيض'},
    {'id': 'grains', 'name': 'حبوب ومعكرونة'},
    {'id': 'spices', 'name': 'بهارات وزيوت'},
    {'id': 'meat', 'name': 'لحوم ومأكولات بحرية'},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openCameraScanner() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FridgeScannerScreen()),
    );
  }

  void _openVoiceSheet() {
    VoiceInputSheet.show(context);
  }

  void _showAddIngredientOptions() {
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
                'إضافة مكونات إلى مطبخك',
                style: GoogleFonts.newsreader(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 14),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                  child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 20),
                ),
                title: const Text('تصوير الثلاجة / الخزانة بالذكاء الاصطناعي 📸', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('التعرف الفوري على كافة المكونات بالصورة'),
                onTap: () {
                  Navigator.pop(ctx);
                  _openCameraScanner();
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(color: AppColors.accentGold, shape: BoxShape.circle),
                  child: const Icon(Icons.mic_rounded, color: Colors.white, size: 20),
                ),
                title: const Text('الإملاء الصوتي السريع 🎙️', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('قل ما لديك وسيقوم التطبيق بفرزها'),
                onTap: () {
                  Navigator.pop(ctx);
                  _openVoiceSheet();
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.grey.shade300, shape: BoxShape.circle),
                  child: const Icon(Icons.edit_note_rounded, color: Colors.black87, size: 20),
                ),
                title: const Text('البحث والإضافة اليدوية 🔍', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('اختر من قائمة المكونات المتاحة'),
                onTap: () {
                  Navigator.pop(ctx);
                  _showManualSearchDialog();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showManualSearchDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        String query = '';
        return StatefulBuilder(
          builder: (context, setDlgState) {
            final filtered = IngredientsData.allIngredients.where((i) {
              if (query.isEmpty) return true;
              return i.name.contains(query) || i.synonyms.any((s) => s.contains(query));
            }).take(15).toList();

            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Text('إضافة مكوّن يدوياً 🧂'),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        hintText: 'ابحث عن اسم المكون...',
                        prefixIcon: Icon(Icons.search_rounded),
                      ),
                      onChanged: (v) => setDlgState(() => query = v),
                    ),
                    const SizedBox(height: 10),
                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: filtered.length,
                        itemBuilder: (context, idx) {
                          final item = filtered[idx];
                          final isInPantry = ref.watch(pantryProvider).contains(item.id);
                          return ListTile(
                            leading: Text(item.emoji, style: const TextStyle(fontSize: 22)),
                            title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                            trailing: IconButton(
                              icon: Icon(
                                isInPantry ? Icons.check_circle_rounded : Icons.add_circle_outline_rounded,
                                color: isInPantry ? AppColors.secondary : AppColors.primary,
                              ),
                              onPressed: () {
                                ref.read(pantryProvider.notifier).toggleIngredient(item.id);
                                setDlgState(() {});
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('إغلاق'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final pantryIds = ref.watch(pantryProvider);
    final matching = ref.watch(matchingProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Filter active items
    final activePantryItems = IngredientsData.allIngredients
        .where((ing) => pantryIds.contains(ing.id))
        .where((ing) {
          if (_selectedCategory == 'all') return true;
          if (_selectedCategory == 'vegetables') return ing.category == IngredientCategory.vegetables;
          if (_selectedCategory == 'dairy') return ing.category == IngredientCategory.dairyAndEggs;
          if (_selectedCategory == 'grains') return ing.category == IngredientCategory.grainsAndPasta;
          if (_selectedCategory == 'spices') return ing.category == IngredientCategory.spicesAndHerbs;
          if (_selectedCategory == 'meat') return ing.category == IngredientCategory.meatAndPoultry;
          return true;
        })
        .where((ing) {
          if (_searchQuery.trim().isEmpty) return true;
          final norm = TextNormalizer.normalize(_searchQuery);
          return TextNormalizer.matches(ing.name, norm) ||
              ing.synonyms.any((s) => TextNormalizer.matches(s, norm));
        })
        .toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Kitchen Overview & Pantry Health Bento Grid matching Stitch cac80ebd6f0e4336bd48231b847f26d9
                    Row(
                      children: [
                        // Card 1: Pantry Total
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.surfaceDark : AppColors.surfaceContainer,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('إجمالي المؤونة', style: GoogleFonts.manrope(fontSize: 10, color: AppColors.secondary, fontWeight: FontWeight.bold)),
                                    const Icon(Icons.shelves, size: 16, color: AppColors.secondary),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text('${pantryIds.length}', style: GoogleFonts.newsreader(fontSize: 22, fontWeight: FontWeight.bold)),
                                Text('مكونات مسجلة', style: GoogleFonts.manrope(fontSize: 10, color: AppColors.secondary)),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Card 2: Expiring soon (Tertiary container #FFDAD8)
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.tertiaryContainer : AppColors.tertiaryFixed,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('تنتهي قريباً', style: GoogleFonts.manrope(fontSize: 10, color: AppColors.tertiary, fontWeight: FontWeight.bold)),
                                    const Icon(Icons.hourglass_top_rounded, size: 16, color: AppColors.tertiary),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text('٤', style: GoogleFonts.newsreader(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.tertiary)),
                                Text('خلال 48 ساعة', style: GoogleFonts.manrope(fontSize: 10, color: AppColors.tertiary, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Card 3: Low Stock
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.surfaceDark : AppColors.surfaceContainer,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('أوشكت تنفد', style: GoogleFonts.manrope(fontSize: 10, color: AppColors.secondary, fontWeight: FontWeight.bold)),
                                    const Icon(Icons.inventory_2_outlined, size: 16, color: AppColors.secondary),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text('٨', style: GoogleFonts.newsreader(fontSize: 22, fontWeight: FontWeight.bold)),
                                Text('إعادة طلب قريباً', style: GoogleFonts.manrope(fontSize: 10, color: AppColors.secondary)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // 2. Recipe Matcher Banner matching Stitch
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withAlpha(50),
                            blurRadius: 14,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryContainer,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.auto_awesome, color: AppColors.primaryFixed, size: 14),
                                    const SizedBox(width: 4),
                                    Text(
                                      'مطابقة حسية بالذكاء الاصطناعي',
                                      style: GoogleFonts.manrope(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryFixed,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                'محدّث الآن',
                                style: GoogleFonts.manrope(color: AppColors.primaryFixedDim, fontSize: 10),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          Text(
                            '${matching.totalReadyCount > 0 ? matching.totalReadyCount : 14} وصفة جاهزة للطهي الآن',
                            style: GoogleFonts.newsreader(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            'ابتكر وجبة موسمية متكاملة من مخزونك الحالي دون الحاجة لزيارة متجر البقالة.',
                            style: GoogleFonts.manrope(
                              color: AppColors.surfaceContainerHigh.withAlpha(200),
                              fontSize: 12,
                              height: 1.4,
                            ),
                          ),

                          const SizedBox(height: 14),

                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.primary,
                              minimumSize: const Size(double.infinity, 46),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                            ),
                            icon: const Icon(Icons.soup_kitchen_rounded, size: 18),
                            label: const Text('طابق الوصفات من مؤونتي', style: TextStyle(fontWeight: FontWeight.bold)),
                            onPressed: widget.onViewRecipes,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 3. Search & Scanner Row
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.surfaceDark : AppColors.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.search_rounded, color: AppColors.secondary, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    controller: _searchController,
                                    decoration: const InputDecoration(
                                      hintText: 'ابحث في المؤونة، المصدر، أو التصنيف...',
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    onChanged: (v) => setState(() => _searchQuery = v),
                                  ),
                                ),
                                if (_searchQuery.isNotEmpty)
                                  IconButton(
                                    icon: const Icon(Icons.clear_rounded, size: 18),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() => _searchQuery = '');
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Camera / Barcode scanner button
                        InkWell(
                          onTap: _openCameraScanner,
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.surfaceDark : AppColors.surfaceContainer,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.barcode_reader, color: AppColors.primary, size: 22),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // 4. Category Filter Pills (Horizontal Scroll)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _categories.map((cat) {
                          final isSelected = _selectedCategory == cat['id'];
                          return Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: ChoiceChip(
                              label: Text(cat['name']!),
                              selected: isSelected,
                              selectedColor: AppColors.primary,
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : (isDark ? Colors.white70 : AppColors.secondary),
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                fontSize: 12,
                              ),
                              backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceContainer,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              onSelected: (_) {
                                setState(() => _selectedCategory = cat['id']!);
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 5. Items Feed Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'مؤونة المطبخ الحالية',
                              style: GoogleFonts.newsreader(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.surfaceDark : AppColors.surfaceContainerHigh,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${activePantryItems.length} مكونات',
                                style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary),
                              ),
                            ),
                          ],
                        ),
                        TextButton.icon(
                          style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                          icon: const Icon(Icons.swap_vert_rounded, size: 16),
                          label: const Text('الأقرب انتهاءً أولاً', style: TextStyle(fontSize: 11)),
                          onPressed: () {},
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // 6. Pantry Items List
                    if (activePantryItems.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 36.0),
                          child: Column(
                            children: [
                              Icon(Icons.kitchen_outlined, size: 48, color: Colors.grey.shade400),
                              const SizedBox(height: 10),
                              const Text('لا توجد مكونات تطابق الفلتر الحالي في مطبخك'),
                              const SizedBox(height: 8),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.add),
                                label: const Text('إضافة مكونات لمطبخي'),
                                onPressed: _showAddIngredientOptions,
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: activePantryItems.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 10),
                        itemBuilder: (context, idx) {
                          final item = activePantryItems[idx];
                          return Container(
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.surfaceDark : AppColors.surfaceContainerLowest,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    children: [
                                      // Item Emoji / Avatar container
                                      Container(
                                        width: 52,
                                        height: 52,
                                        decoration: BoxDecoration(
                                          color: isDark ? AppColors.cardDark : AppColors.surfaceContainerLow,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(item.emoji, style: const TextStyle(fontSize: 26)),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.name,
                                              style: GoogleFonts.newsreader(fontSize: 16, fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Text(
                                                  '${item.shelfLifeDays ?? 7} أيام صلاحية',
                                                  style: GoogleFonts.manrope(fontSize: 11, color: AppColors.secondary),
                                                ),
                                                const SizedBox(width: 6),
                                                Container(
                                                  width: 4,
                                                  height: 4,
                                                  decoration: const BoxDecoration(color: AppColors.secondary, shape: BoxShape.circle),
                                                ),
                                                const SizedBox(width: 6),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.primaryFixed,
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: Text(
                                                    'مخزون وافر',
                                                    style: GoogleFonts.manrope(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.primary),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
                                        onPressed: () {
                                          ref.read(pantryProvider.notifier).toggleIngredient(item.id);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                // Bottom info bar
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: isDark ? Colors.black.withAlpha(40) : AppColors.surfaceContainerLow.withAlpha(150),
                                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.check_circle_rounded, size: 14, color: AppColors.surfaceTint),
                                          const SizedBox(width: 4),
                                          Text(
                                            'مكان الحفظ: رف المؤونة / الثلاجة',
                                            style: GoogleFonts.manrope(fontSize: 10, color: AppColors.secondary),
                                          ),
                                        ],
                                      ),
                                      InkWell(
                                        onTap: widget.onViewRecipes,
                                        child: Row(
                                          children: [
                                            Text(
                                              'مطابقة ٣ وصفات',
                                              style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary),
                                            ),
                                            const Icon(Icons.chevron_left_rounded, size: 14, color: AppColors.primary),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                    const SizedBox(height: 18),

                    // 7. Zero Waste Insight Card matching Stitch
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceDark : AppColors.secondaryContainer,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.compost_rounded, color: AppColors.primary, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'تقليل هدر الطعام (Zero Waste) 🌱',
                                  style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'استخدام الفطر والأرز اليوم يرفع مؤشر استدامة مطبخك إلى صفر هدر هذا الأسبوع!',
                                  style: GoogleFonts.manrope(fontSize: 11, color: isDark ? AppColors.textSecondaryDark : AppColors.secondary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 80), // spacing for bottom dock
                  ],
                ),
              ),
            ),

            // 8. Sticky Mobile Action Deck at bottom
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.white.withAlpha(240),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(15),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 48),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('إضافة مكوّن', style: TextStyle(fontWeight: FontWeight.bold)),
                      onPressed: _showAddIngredientOptions,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        minimumSize: const Size(0, 48),
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      icon: const Icon(Icons.playlist_add_check_rounded),
                      label: const Text('القائمة الذكية', style: TextStyle(fontWeight: FontWeight.bold)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ShoppingScreen()),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
