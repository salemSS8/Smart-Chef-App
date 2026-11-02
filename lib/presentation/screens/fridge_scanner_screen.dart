import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../providers/pantry_provider.dart';

class FridgeScannerScreen extends ConsumerStatefulWidget {
  const FridgeScannerScreen({super.key});

  @override
  ConsumerState<FridgeScannerScreen> createState() => _FridgeScannerScreenState();
}

class _FridgeScannerScreenState extends ConsumerState<FridgeScannerScreen> {
  // Detected ingredients
  final List<Map<String, dynamic>> _detectedItems = [
    {'id': 'ing_eggs', 'name': 'بيض', 'confirmed': true},
    {'id': 'ing_tomato', 'name': 'طماطم', 'confirmed': true},
    {'id': 'ing_cucumber', 'name': 'خيار', 'confirmed': true},
    {'id': 'ing_carrot', 'name': 'جزر', 'confirmed': true},
    {'id': 'ing_cheese_mozzarella', 'name': 'جبنة', 'confirmed': true},
    {'id': 'ing_milk', 'name': 'حليب', 'confirmed': true},
  ];

  bool _isYogurtAmbiguous = true;
  bool _yogurtAdded = false;

  void _addDetectedToPantry() {
    final idsToAdd = _detectedItems
        .where((item) => item['confirmed'] == true)
        .map((item) => item['id'] as String)
        .toList();

    if (_yogurtAdded) {
      idsToAdd.add('ing_yogurt');
    }

    ref.read(pantryProvider.notifier).addMultiple(idsToAdd);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تمت إضافة ${idsToAdd.length} مكونات إلى مطبخك بنجاح! 🥕'),
        backgroundColor: AppColors.secondary,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final totalCount = _detectedItems.where((i) => i['confirmed']).length + (_yogurtAdded ? 1 : 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('تصوير الثلاجة 📷'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Viewfinder Camera simulation with bounding boxes
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF7F2E8),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: const Color(0xFFD8CCBA)),
              ),
              child: Stack(
                children: [
                  // Center guidance
                  const Center(
                    child: Text(
                      'لقطة الرف (الصورة تُحذف بعد المعالجة فوراً)',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),

                  // Bounding Box 1: طماطم
                  PositionedDirectional(
                    top: 20,
                    start: 24,
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.secondary, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.secondary,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'طماطم',
                            style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Bounding Box 2: بيض
                  PositionedDirectional(
                    top: 15,
                    end: 24,
                    child: Container(
                      width: 90,
                      height: 80,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.secondary, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.secondary,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'بيض',
                            style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Bounding Box 3: غير متأكد
                  Positioned(
                    bottom: 20,
                    left: 100,
                    right: 100,
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.primary, width: 2, style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'غير متأكد',
                            style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Results Header
            Text(
              'وجدنا $totalCount مكونات',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'راجعها قبل الإضافة. اللمس يحذف أي مكوّن خاطئ.',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondaryLight),
            ),

            const SizedBox(height: 14),

            // Confirmed detected chips
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ..._detectedItems.map((item) {
                  final isConf = item['confirmed'] as bool;
                  return FilterChip(
                    avatar: Icon(
                      isConf ? Icons.check_circle_rounded : Icons.cancel_rounded,
                      size: 16,
                      color: isConf ? AppColors.secondary : Colors.grey,
                    ),
                    label: Text(item['name']),
                    selected: isConf,
                    selectedColor: AppColors.secondaryLight,
                    onSelected: (val) {
                      setState(() {
                        item['confirmed'] = val;
                      });
                    },
                  );
                }),
                if (_yogurtAdded)
                  FilterChip(
                    avatar: const Icon(Icons.check_circle_rounded, size: 16, color: AppColors.secondary),
                    label: const Text('زبادي'),
                    selected: true,
                    selectedColor: AppColors.secondaryLight,
                    onSelected: (_) {
                      setState(() {
                        _yogurtAdded = false;
                      });
                    },
                  ),
              ],
            ),

            const SizedBox(height: 20),

            // Ambiguity confirmation card
            if (_isYogurtAmbiguous)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primaryLight, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(isDark ? 30 : 8),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'هل هذا زبادي؟ 🥛',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'لسنا متأكدين من العبوة المغلقة في الرف الأوسط.',
                      style: TextStyle(fontSize: 13, color: AppColors.textSecondaryLight),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _yogurtAdded = true;
                                _isYogurtAmbiguous = false;
                              });
                            },
                            child: const Text('نعم، زبادي'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _isYogurtAmbiguous = false;
                              });
                            },
                            child: const Text('لا، شيء آخر'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 24),

            // Add button
            ElevatedButton(
              onPressed: _addDetectedToPantry,
              child: Text('أضف $totalCount مكونات إلى مطبخي'),
            ),

            const SizedBox(height: 10),
            const Center(
              child: Text(
                'لا نحتفظ بالصورة بعد انتهاء التعرف',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondaryLight),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
