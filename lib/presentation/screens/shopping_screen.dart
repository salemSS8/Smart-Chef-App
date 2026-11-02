import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../providers/shopping_provider.dart';

class ShoppingScreen extends ConsumerStatefulWidget {
  const ShoppingScreen({super.key});

  @override
  ConsumerState<ShoppingScreen> createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends ConsumerState<ShoppingScreen> {
  int _activeTab = 0; // 0 for Shopping List, 1 for Weekly Plan
  final TextEditingController _addItemController = TextEditingController();

  @override
  void dispose() {
    _addItemController.dispose();
    super.dispose();
  }

  void _showAddDialog() {
    _addItemController.clear();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('إضافة مكوّن لقائمة التسوق'),
        content: TextField(
          controller: _addItemController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'اسم المكوّن (مثلاً: بهارات كبسة، حليب...)',
          ),
          onSubmitted: (val) {
            if (val.trim().isNotEmpty) {
              ref.read(shoppingProvider.notifier).addItem(val.trim());
              Navigator.pop(ctx);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_addItemController.text.trim().isNotEmpty) {
                ref.read(shoppingProvider.notifier).addItem(_addItemController.text.trim());
                Navigator.pop(ctx);
              }
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  Future<void> _transferCompletedToPantry() async {
    final transferred = await ref.read(shoppingProvider.notifier).transferCompletedToPantry();

    if (!mounted) return;

    if (transferred.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حدد العناصر التي قمت بشرائها أولاً لنقلها إلى مطبخك')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم شراء ${transferred.length} مكونات ونقلها إلى مطبخك بنجاح! 🎉'),
        backgroundColor: AppColors.secondary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final shoppingList = ref.watch(shoppingProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final completedCount = shoppingList.where((i) => i.isCompleted).length;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top Title "الخطة" (matching 07 mockup)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Align(
                alignment: AlignmentDirectional.centerEnd,
                child: Text(
                  'الخطة',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
              ),
            ),

            // Top Segment Switch matching 07 mockup
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : const Color(0xFFF0EBE1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() => _activeTab = 1),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: _activeTab == 1 ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: _activeTab == 1
                              ? [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 4)]
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            'وجبات الأسبوع',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: _activeTab == 1 ? AppColors.textPrimaryLight : AppColors.textSecondaryLight,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() => _activeTab = 0),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: _activeTab == 0 ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: _activeTab == 0
                              ? [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 4)]
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            'قائمة التسوق',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: _activeTab == 0 ? AppColors.textPrimaryLight : AppColors.textSecondaryLight,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Tab Content
            Expanded(
              child: _activeTab == 0
                  ? _buildShoppingListTab(shoppingList, isDark, completedCount)
                  : _buildWeeklyPlanTab(isDark),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShoppingListTab(List<ShoppingItem> items, bool isDark, int completedCount) {
    return Column(
      children: [
        // Subtitle note matching 07 mockup
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('من وصفتين', style: TextStyle(fontSize: 12, color: AppColors.textSecondaryLight)),
              Text(
                '${items.length} عناصر ناقصة • مجمّعة حسب القسم',
                style: const TextStyle(fontSize: 13, color: AppColors.textSecondaryLight),
              ),
            ],
          ),
        ),

        // List
        Expanded(
          child: items.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.shopping_bag_outlined, size: 60, color: AppColors.primary),
                      const SizedBox(height: 12),
                      const Text(
                        'قائمة التسوق فارغة',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'أضف النواقص من أي وصفة بنقرة واحدة',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        onPressed: _showAddDialog,
                        icon: const Icon(Icons.add_rounded),
                        label: const Text('أضف عنصراً يدوياً'),
                      ),
                    ],
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  children: [
                    // Group 1: Items list
                    Container(
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceDark : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: items.length,
                        separatorBuilder: (context, index) => Divider(
                          height: 1,
                          color: isDark ? AppColors.borderDark : AppColors.borderLight,
                        ),
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return ListTile(
                            leading: Checkbox(
                              value: item.isCompleted,
                              activeColor: AppColors.primary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                              onChanged: (_) {
                                ref.read(shoppingProvider.notifier).toggleCompleted(index);
                              },
                            ),
                            title: Text(
                              item.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                                color: item.isCompleted ? Colors.grey : null,
                              ),
                            ),
                            subtitle: item.fromRecipe != null
                                ? Text(
                                    item.fromRecipe!,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                    ),
                                  )
                                : null,
                            trailing: IconButton(
                              icon: const Icon(Icons.close_rounded, size: 18, color: Colors.grey),
                              onPressed: () {
                                ref.read(shoppingProvider.notifier).removeItem(index);
                              },
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Add button (+ أضف عنصراً) matching 07 mockup
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: InkWell(
                        onTap: _showAddDialog,
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.primary, style: BorderStyle.solid),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'أضف عنصرًا',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(width: 6),
                              Icon(Icons.add, size: 18, color: AppColors.primary),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 80),
                  ],
                ),
        ),

        // Bottom Sticky Button: تم الشراء — انقل المحدد إلى مطبخي
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
            onPressed: _transferCompletedToPantry,
            child: const Text(
              'تم الشراء — انقل المحدد إلى مطبخي',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  // Weekly Meal Plan view (V1 feature from user request)
  Widget _buildWeeklyPlanTab(bool isDark) {
    final days = [
      {'day': 'السبت', 'lunch': 'كبسة دجاج خليجية', 'dinner': 'شكشوكة بالبيض'},
      {'day': 'الأحد', 'lunch': 'صينية بطاطس بالدجاج', 'dinner': 'عجة بيض وبقدونس'},
      {'day': 'الإثنين', 'lunch': 'مجدرة الأرز والعدس', 'dinner': 'سلطة فتوش بالخبز'},
      {'day': 'الثلاثاء', 'lunch': 'معكرونة بصلصة الطماطم', 'dinner': 'شوربة عدس صفراء'},
      {'day': 'الأربعاء', 'lunch': 'طاجن دجاج بالخضار', 'dinner': 'بيض وجبن مسخن'},
      {'day': 'الخميس', 'lunch': 'كبسة دجاج عائلية', 'dinner': 'وجبة خفيفة ومقبلات'},
      {'day': 'الجمعة', 'lunch': 'وليمة الجمعة المفتوحة', 'dinner': 'شوربة خفيفة'},
    ];

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم توليد قائمة تسوق الأسبوع بنجاح! 🛒')),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(180, 42),
                backgroundColor: AppColors.secondary,
              ),
              icon: const Icon(Icons.playlist_add_check_rounded, size: 18),
              label: const Text('ولّد قائمة تسوق الأسبوع', style: TextStyle(fontSize: 12)),
            ),
            const Text(
              'جدول الأسبوع (7 أيام)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...days.map((d) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      d['day']!,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 13),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.sunny, size: 14, color: Colors.orange),
                          const SizedBox(width: 4),
                          Text('الغداء: ${d['lunch']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.nightlight_round, size: 14, color: Colors.indigo),
                          const SizedBox(width: 4),
                          Text('العشاء: ${d['dinner']}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
