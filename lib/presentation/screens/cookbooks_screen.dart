import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../providers/favorites_provider.dart';
import '../providers/matching_provider.dart';
import 'cook_mode_screen.dart';
import 'recipe_detail_screen.dart';

class CookbooksScreen extends ConsumerStatefulWidget {
  const CookbooksScreen({super.key});

  @override
  ConsumerState<CookbooksScreen> createState() => _CookbooksScreenState();
}

class _CookbooksScreenState extends ConsumerState<CookbooksScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // مجموعات وكتيبات مخصصة
  final List<Map<String, dynamic>> _customCookbooks = [
    {
      'title': 'أطباق خليجية أصيلة 🇸🇦',
      'count': 6,
      'image': 'https://images.unsplash.com/photo-1541518763669-27fef04b14ea?auto=format&fit=crop&w=600&q=80',
      'tag': 'خليجي',
    },
    {
      'title': 'عشاء سريع في 15 دقيقة ⏱️',
      'count': 8,
      'image': 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=600&q=80',
      'tag': 'سريع',
    },
    {
      'title': 'أطباق صحية وكيتو 🥑',
      'count': 5,
      'image': 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=600&q=80',
      'tag': 'صحي',
    },
    {
      'title': 'مقبلات وسلطات منعشة 🥗',
      'count': 4,
      'image': 'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=600&q=80',
      'tag': 'سلطات',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _createNewCookbookDialog() {
    final titleCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('إنشاء كتيب وصفات جديد 📚', style: TextStyle(fontWeight: FontWeight.bold)),
        content: TextField(
          controller: titleCtrl,
          decoration: const InputDecoration(
            labelText: 'اسم الكتيب (مثال: أكلات رمضان، فطور الجمعة)',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              if (titleCtrl.text.trim().isNotEmpty) {
                setState(() {
                  _customCookbooks.add({
                    'title': titleCtrl.text.trim(),
                    'count': 0,
                    'image': 'https://images.unsplash.com/photo-1498837167922-ddd27525d352?auto=format&fit=crop&w=600&q=80',
                    'tag': 'مخصص',
                  });
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text('إنشاء'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allRecipes = ref.watch(recipesProvider);
    final favoriteIds = ref.watch(favoritesProvider);
    final favoriteRecipes = allRecipes.where((r) => favoriteIds.contains(r.id)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('كتيباتي والمفضلة 📚', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.create_new_folder_outlined),
            tooltip: 'إنشاء كتيب جديد',
            onPressed: _createNewCookbookDialog,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondaryLight,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          tabs: [
            Tab(text: 'المفضلة (${favoriteRecipes.length}) 💖'),
            Tab(text: 'الكتيبات المخصصة (${_customCookbooks.length}) 📂'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: المفضلة
          favoriteRecipes.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: const BoxDecoration(
                            color: AppColors.secondaryCream,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.favorite_border_rounded, size: 56, color: AppColors.accentTomato),
                        ),
                        const SizedBox(height: 20),
                        const Text('لا توجد وصفات مفضلة بعد', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        const Text(
                          'اضغط على رمز القلب في أي وصفة لحفظها هنا والوصول إليها بسرعة حتى بدون إنترنت.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 13, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: favoriteRecipes.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, idx) {
                    final recipe = favoriteRecipes[idx];
                    return Card(
                      elevation: 0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: const BorderSide(color: AppColors.borderLight),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            recipe.heroImageUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: 60,
                              height: 60,
                              color: AppColors.secondaryCream,
                              child: const Icon(Icons.restaurant, color: AppColors.secondary),
                            ),
                          ),
                        ),
                        title: Text(recipe.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        subtitle: Text('${recipe.cuisine} • ${recipe.cookMinutes} دقيقة • ${recipe.difficulty}'),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            minimumSize: Size.zero,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => CookModeScreen(recipe: recipe)),
                            );
                          },
                          child: const Text('طهي 🍳', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => RecipeDetailScreen(recipe: recipe)),
                          );
                        },
                      ),
                    );
                  },
                ),

          // Tab 2: الكتيبات والمجموعات المخصصة
          GridView.builder(
            padding: const EdgeInsets.all(20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 0.85,
            ),
            itemCount: _customCookbooks.length + 1,
            itemBuilder: (context, idx) {
              if (idx == _customCookbooks.length) {
                return InkWell(
                  onTap: _createNewCookbookDialog,
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceCream,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.primary, style: BorderStyle.solid, width: 1.5),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_circle_outline_rounded, color: AppColors.primary, size: 36),
                          SizedBox(height: 10),
                          Text(
                            '+ كتيب جديد',
                            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              final book = _customCookbooks[idx];
              return Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                  side: const BorderSide(color: AppColors.borderLight),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Image.network(
                        book['image'],
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(color: AppColors.secondaryCream),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            book['title'],
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${book['count']} وصفة متوفرة',
                            style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
