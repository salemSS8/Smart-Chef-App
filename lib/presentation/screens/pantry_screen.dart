import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/text_normalizer.dart';
import '../../data/mock/ingredients_data.dart';
import '../../domain/models/ingredient.dart';
import '../providers/matching_provider.dart';
import '../providers/pantry_provider.dart';
import '../widgets/voice_input_sheet.dart';
import 'fridge_scanner_screen.dart';

class PantryScreen extends ConsumerStatefulWidget {
  final VoidCallback onViewRecipes;

  const PantryScreen({super.key, required this.onViewRecipes});

  @override
  ConsumerState<PantryScreen> createState() => _PantryScreenState();
}

class _PantryScreenState extends ConsumerState<PantryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _staplesEnabled = true;

  // Common quick ingredients shown in mockup
  final List<Map<String, String>> _commonSuggestions = [
    {'id': 'ing_onion', 'name': '+ بصل'},
    {'id': 'ing_rice_basmati', 'name': '+ أرز'},
    {'id': 'ing_potato', 'name': '+ بطاطس'},
    {'id': 'ing_cheese_mozzarella', 'name': '+ جبنة'},
    {'id': 'ing_garlic', 'name': '+ ثوم'},
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

  @override
  Widget build(BuildContext context) {
    final pantryIds = ref.watch(pantryProvider);
    final matching = ref.watch(matchingProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Filter ingredients if user searches
    final searchFiltered = _searchQuery.isEmpty
        ? <Ingredient>[]
        : IngredientsData.allIngredients.where((ing) {
            final normQuery = TextNormalizer.normalize(_searchQuery);
            final matchesName = TextNormalizer.matches(ing.name, normQuery);
            final matchesSyn = ing.synonyms.any((syn) => TextNormalizer.matches(syn, normQuery));
            return matchesName || matchesSyn;
          }).toList();

    // The user's active pantry items
    final activePantryItems = IngredientsData.allIngredients
        .where((ing) => pantryIds.contains(ing.id))
        .toList();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Title & Staples Badge (matching 02 mockup)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              _staplesEnabled = !_staplesEnabled;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(_staplesEnabled
                                    ? 'الأساسيات مفعّلة (ملح، زيت، ماء)'
                                    : 'تم تعطيل الأساسيات المفترضة'),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: _staplesEnabled ? const Color(0xFFE2F4EB) : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _staplesEnabled ? 'الأساسيات مفعّلة: ملح، زيت، ماء' : 'الأساسيات معطلة',
                              style: TextStyle(
                                color: _staplesEnabled ? const Color(0xFF1E6B42) : Colors.grey.shade700,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const Text(
                          'مطبخي',
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Search input + Mic + Camera buttons (matching 02 mockup)
                    Row(
                      children: [
                        // Camera Button
                        InkWell(
                          onTap: _openCameraScanner,
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.surfaceDark : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.primary, width: 1.5),
                            ),
                            child: const Icon(Icons.camera_alt_outlined, color: AppColors.primary, size: 24),
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Mic Button (terracotta solid)
                        InkWell(
                          onTap: _openVoiceSheet,
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(Icons.mic_rounded, color: Colors.white, size: 24),
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Search Input
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'ابحث أو قل ما لديك...',
                              suffixIcon: const Icon(Icons.search_rounded, color: Colors.grey),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              filled: true,
                              fillColor: isDark ? AppColors.surfaceDark : Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                              ),
                            ),
                            onChanged: (val) {
                              setState(() {
                                _searchQuery = val.trim();
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                    // Live search dropdown results if user is typing
                    if (_searchQuery.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.surfaceDark : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.borderLight),
                        ),
                        child: searchFiltered.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(12),
                                child: Text('لم نجد «$_searchQuery». جرّب اسم مكوّن آخر.'),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'نتائج البحث لـ «$_searchQuery»:',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: searchFiltered.map((ing) {
                                      final isSelected = pantryIds.contains(ing.id);
                                      return ActionChip(
                                        avatar: Text(ing.emoji),
                                        label: Text(ing.name),
                                        backgroundColor: isSelected ? AppColors.secondaryLight : null,
                                        onPressed: () {
                                          ref.read(pantryProvider.notifier).toggleIngredient(ing.id);
                                          _searchController.clear();
                                          setState(() {
                                            _searchQuery = '';
                                          });
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                      ),
                    ],

                    const SizedBox(height: 20),

                    // Section: شائع في مطابخ مثل مطبخك
                    const Text(
                      'شائع في مطابخ مثل مطبخك',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _commonSuggestions.map((item) {
                        final id = item['id']!;
                        final isAlreadyAdded = pantryIds.contains(id);
                        return ActionChip(
                          label: Text(
                            isAlreadyAdded ? '✓ ${item['name']!.replaceAll('+', '').trim()}' : item['name']!,
                            style: TextStyle(
                              color: isAlreadyAdded ? AppColors.secondary : AppColors.textPrimaryLight,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          backgroundColor: isAlreadyAdded ? AppColors.secondaryLight : Colors.white,
                          side: BorderSide(
                            color: isAlreadyAdded ? AppColors.secondary : AppColors.borderLight,
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          onPressed: () {
                            ref.read(pantryProvider.notifier).toggleIngredient(id);
                          },
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 24),

                    // Section: لديك الآن (X)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'اضغط مطولاً للحذف',
                          style: TextStyle(fontSize: 12, color: AppColors.textSecondaryLight),
                        ),
                        Text(
                          'لديك الآن (${activePantryItems.length})',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // 3-Column Grid matching 02 mockup
                    activePantryItems.isEmpty
                        ? Container(
                            padding: const EdgeInsets.all(28),
                            alignment: Alignment.center,
                            child: const Column(
                              children: [
                                Text('🥕', style: TextStyle(fontSize: 40)),
                                SizedBox(height: 10),
                                Text(
                                  'مطبخك فارغ حالياً',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'أضف مكوناتك من الاقتراحات أعلاه أو بالصوت والكاميرا',
                                  style: TextStyle(color: Colors.grey, fontSize: 13),
                                ),
                              ],
                            ),
                          )
                        : GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: activePantryItems.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 0.82,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemBuilder: (context, index) {
                              final ing = activePantryItems[index];
                              final isExpiring = ing.id == 'ing_milk'; // Milk warning in mockup

                              return InkWell(
                                onLongPress: () {
                                  ref.read(pantryProvider.notifier).toggleIngredient(ing.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('تم حذف ${ing.name} من مطبخك')),
                                  );
                                },
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: isDark ? AppColors.surfaceDark : Colors.white,
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                      color: isExpiring
                                          ? AppColors.primary
                                          : (isDark ? AppColors.borderDark : const Color(0xFF266749)),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Circle avatar
                                      Container(
                                        width: 52,
                                        height: 52,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF7F1E7),
                                          shape: BoxShape.circle,
                                          border: Border.all(color: const Color(0xFFE4D7C5)),
                                        ),
                                        child: Center(
                                          child: Text(ing.emoji, style: const TextStyle(fontSize: 26)),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        ing.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        isExpiring ? 'ينتهي غدًا' : (ing.synonyms.isNotEmpty ? ing.synonyms.first : 'متوفر'),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: isExpiring ? FontWeight.bold : FontWeight.normal,
                                          color: isExpiring ? AppColors.primary : AppColors.textSecondaryLight,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),

                    const SizedBox(height: 16),

                    // Hint Banner (matching 02 mockup)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6EFE5),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info_outline_rounded, color: AppColors.textSecondaryLight, size: 20),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'اكتب «بندو» لتظهر «بندورة / طماطم». نفهم لهجتك.',
                              style: TextStyle(fontSize: 13, color: AppColors.textPrimaryLight),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),

            // Bottom Sticky Reward Button: شاهد X وصفة يمكنك طهيها >
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.white,
                border: Border(top: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight)),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: widget.onViewRecipes,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.arrow_back_ios_rounded, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'شاهد ${matching.totalReadyCount > 0 ? matching.totalReadyCount : 18} وصفة يمكنك طهيها',
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
