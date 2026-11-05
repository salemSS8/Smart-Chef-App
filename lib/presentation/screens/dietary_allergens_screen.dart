import 'package:flutter/material.dart';
import '../../core/services/dietary_service.dart';
import '../../core/theme/app_colors.dart';

class DietaryAllergensScreen extends StatefulWidget {
  const DietaryAllergensScreen({super.key});

  @override
  State<DietaryAllergensScreen> createState() => _DietaryAllergensScreenState();
}

class _DietaryAllergensScreenState extends State<DietaryAllergensScreen> {
  late Set<String> _selectedAllergens;
  late Set<String> _selectedDiets;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _selectedAllergens = Set.from(DietaryService.activeAllergens);
    _selectedDiets = Set.from(DietaryService.activeDiets);
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    await DietaryService.savePreferences(
      allergens: _selectedAllergens,
      diets: _selectedDiets,
    );
    if (mounted) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.primary,
          content: Text('تم حفظ تفضيلات الحساسية والنظام الغذائي ومزامنتها بنجاح! ✨'),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الحساسيات والنظام الغذائي 🥗', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // بنر توضيحي لحماية الصحة
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceCream,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: const Row(
                children: [
                  Icon(Icons.health_and_safety_rounded, color: AppColors.primary, size: 32),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'تخصيص الخوارزمية وصحة الأسرة',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'سيقوم التطبيق تلقائياً بتنبيهك واستبعاد المكونات الضارة بك وبناء قوائم تناسب نظامك الصحي.',
                          style: TextStyle(fontSize: 12, color: AppColors.textSecondaryLight, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // قسم مسببات الحساسية
            const Text(
              'مسببات الحساسية الممنوعة ⚠️',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 6),
            const Text(
              'حدد المكونات التي تعاني أنت أو أحد أفراد عائلتك من حساسية تجاهها:',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondaryLight),
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: DietaryService.supportedAllergens.map((allergen) {
                final isSelected = _selectedAllergens.contains(allergen.id);
                return FilterChip(
                  avatar: Text(allergen.icon),
                  label: Text(allergen.nameAr),
                  selected: isSelected,
                  selectedColor: AppColors.dangerLight,
                  checkmarkColor: AppColors.danger,
                  labelStyle: TextStyle(
                    color: isSelected ? AppColors.danger : AppColors.textPrimaryLight,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 13,
                  ),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: isSelected ? AppColors.danger : AppColors.borderLight),
                  ),
                  onSelected: (val) {
                    setState(() {
                      if (val) {
                        _selectedAllergens.add(allergen.id);
                      } else {
                        _selectedAllergens.remove(allergen.id);
                      }
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 32),

            // قسم الأنظمة الغذائية التحريرية
            const Text(
              'الأنظمة والتفضيلات الغذائية 🥑',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 6),
            const Text(
              'اختر أسلوب حياتك الغذائي لتفضيل الوصفات المطابقة له في اقتراحات اليوم واكتشف:',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondaryLight),
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: DietaryService.supportedDiets.map((diet) {
                final isSelected = _selectedDiets.contains(diet.id);
                return FilterChip(
                  avatar: Text(diet.icon),
                  label: Text(diet.nameAr),
                  selected: isSelected,
                  selectedColor: AppColors.primaryLight,
                  checkmarkColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: isSelected ? AppColors.primary : AppColors.textPrimaryLight,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 13,
                  ),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: isSelected ? AppColors.primary : AppColors.borderLight),
                  ),
                  onSelected: (val) {
                    setState(() {
                      if (val) {
                        _selectedDiets.add(diet.id);
                      } else {
                        _selectedDiets.remove(diet.id);
                      }
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 40),

            // زر الحفظ والمزامنة
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                icon: _isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Icon(Icons.check_rounded),
                label: Text(
                  _isSaving ? 'جاري الحفظ والمزامنة...' : 'حفظ التفضيلات ومزامنة الملف 💾',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                onPressed: _isSaving ? null : _save,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

