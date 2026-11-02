import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/arabic_normalizer.dart';
import '../../data/mock/recipes_data.dart';
import '../providers/pantry_provider.dart';
import '../widgets/recipe_card.dart';

class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({super.key});

  @override
  ConsumerState<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends ConsumerState<DiscoverScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedCuisine;

  final List<String> _cuisines = [
    'خليجي',
    'شامي',
    'مصري / شامي',
    'عربي مشترك',
    'إيطالي / عالمي',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pantryIds = ref.watch(pantryProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final filteredRecipes = RecipesData.allRecipes.where((recipe) {
      if (_selectedCuisine != null && recipe.cuisine != _selectedCuisine) {
        return false;
      }
      if (_searchQuery.trim().isNotEmpty) {
        final matchesTitle = ArabicNormalizer.isMatch(_searchQuery, recipe.title);
        final matchesTags = recipe.tags.any((t) => ArabicNormalizer.isMatch(_searchQuery, t));
        final matchesCuisine = ArabicNormalizer.isMatch(_searchQuery, recipe.cuisine);
        if (!matchesTitle && !matchesTags && !matchesCuisine) {
          return false;
        }
      }
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('اكتشف الوصفات ✨'),
      ),
      body: Column(
        children: [
          // Search Field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'ابحث عن اسم طبق، كبسة، شكشوكة، معكرونة...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  ),
                ),
              ),
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
            ),
          ),

          // Cuisine Filters
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FilterChip(
                    label: const Text('جميع المطابخ'),
                    selected: _selectedCuisine == null,
                    onSelected: (_) {
                      setState(() {
                        _selectedCuisine = null;
                      });
                    },
                  ),
                ),
                ..._cuisines.map((c) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: FilterChip(
                      label: Text(c),
                      selected: _selectedCuisine == c,
                      onSelected: (val) {
                        setState(() {
                          _selectedCuisine = val ? c : null;
                        });
                      },
                    ),
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Recipe Results List
          Expanded(
            child: filteredRecipes.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off_rounded, size: 50, color: Colors.grey),
                        SizedBox(height: 12),
                        Text(
                          'لم يتم العثور على أطباق مطابقة للبحث',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredRecipes.length,
                    itemBuilder: (context, index) {
                      final recipe = filteredRecipes[index];
                      final matchResult = recipe.evaluateMatch(pantryIds);
                      return RecipeCard(
                        matchResult: matchResult,
                        isHorizontal: false,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
