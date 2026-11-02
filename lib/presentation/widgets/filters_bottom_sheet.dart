import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class FilterCriteria {
  final int? maxMinutes;
  final Set<String> cuisines;
  final String? mealType;
  final bool noNuts;
  final bool noGluten;
  final bool isVegan;

  const FilterCriteria({
    this.maxMinutes,
    this.cuisines = const {},
    this.mealType,
    this.noNuts = false,
    this.noGluten = false,
    this.isVegan = false,
  });

  FilterCriteria copyWith({
    int? maxMinutes,
    Set<String>? cuisines,
    String? mealType,
    bool? noNuts,
    bool? noGluten,
    bool? isVegan,
  }) {
    return FilterCriteria(
      maxMinutes: maxMinutes ?? this.maxMinutes,
      cuisines: cuisines ?? this.cuisines,
      mealType: mealType ?? this.mealType,
      noNuts: noNuts ?? this.noNuts,
      noGluten: noGluten ?? this.noGluten,
      isVegan: isVegan ?? this.isVegan,
    );
  }
}

class FiltersBottomSheet extends StatefulWidget {
  final FilterCriteria initialCriteria;
  final Function(FilterCriteria) onApply;

  const FiltersBottomSheet({
    super.key,
    required this.initialCriteria,
    required this.onApply,
  });

  static Future<void> show(
    BuildContext context, {
    required FilterCriteria initialCriteria,
    required Function(FilterCriteria) onApply,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FiltersBottomSheet(
        initialCriteria: initialCriteria,
        onApply: onApply,
      ),
    );
  }

  @override
  State<FiltersBottomSheet> createState() => _FiltersBottomSheetState();
}

class _FiltersBottomSheetState extends State<FiltersBottomSheet> {
  int? _maxMinutes;
  late Set<String> _selectedCuisines;
  String? _mealType;
  bool _noNuts = false;
  bool _noGluten = false;
  bool _isVegan = false;

  @override
  void initState() {
    super.initState();
    _maxMinutes = widget.initialCriteria.maxMinutes;
    _selectedCuisines = Set<String>.from(widget.initialCriteria.cuisines);
    _mealType = widget.initialCriteria.mealType;
    _noNuts = widget.initialCriteria.noNuts;
    _noGluten = widget.initialCriteria.noGluten;
    _isVegan = widget.initialCriteria.isVegan;
  }

  void _reset() {
    setState(() {
      _maxMinutes = null;
      _selectedCuisines.clear();
      _mealType = null;
      _noNuts = false;
      _noGluten = false;
      _isVegan = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.only(
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top drag bar
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Title & Reset
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: _reset,
                      child: const Text(
                        'إعادة ضبط',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const Text(
                      'الفلاتر',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Section: الوقت
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text('الوقت', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  spacing: 8,
                  children: [
                    _buildTimeChip('أقل من 15 د', 15),
                    _buildTimeChip('أقل من 30 د', 30),
                    _buildTimeChip('أقل من ساعة', 60),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Section: المطبخ
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text('المطبخ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildCuisineChip('خليجي'),
                    _buildCuisineChip('شامي'),
                    _buildCuisineChip('مصري'),
                    _buildCuisineChip('مغاربي'),
                    _buildCuisineChip('عالمي'),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Section: الوجبة
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text('الوجبة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  spacing: 8,
                  children: [
                    _buildMealChip('فطور'),
                    _buildMealChip('غداء'),
                    _buildMealChip('عشاء'),
                    _buildMealChip('سحور'),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Section: الحمية والحساسية (صارمة)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'الحمية والحساسية (صارمة)',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(height: 8),
                      CheckboxListTile(
                        value: _noNuts,
                        activeColor: AppColors.primary,
                        contentPadding: EdgeInsets.zero,
                        title: const Text('بدون مكسرات'),
                        onChanged: (val) => setState(() => _noNuts = val ?? false),
                      ),
                      const Divider(height: 1),
                      CheckboxListTile(
                        value: _noGluten,
                        activeColor: AppColors.primary,
                        contentPadding: EdgeInsets.zero,
                        title: const Text('بدون جلوتين'),
                        onChanged: (val) => setState(() => _noGluten = val ?? false),
                      ),
                      const Divider(height: 1),
                      CheckboxListTile(
                        value: _isVegan,
                        activeColor: AppColors.primary,
                        contentPadding: EdgeInsets.zero,
                        title: const Text('نباتي'),
                        onChanged: (val) => setState(() => _isVegan = val ?? false),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Apply button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: () {
                    final criteria = FilterCriteria(
                      maxMinutes: _maxMinutes,
                      cuisines: _selectedCuisines,
                      mealType: _mealType,
                      noNuts: _noNuts,
                      noGluten: _noGluten,
                      isVegan: _isVegan,
                    );
                    widget.onApply(criteria);
                    Navigator.pop(context);
                  },
                  child: const Text('طبّق الفلاتر'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeChip(String label, int minutes) {
    final isSel = _maxMinutes == minutes;
    return ChoiceChip(
      label: Text(label),
      selected: isSel,
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSel ? Colors.white : AppColors.textPrimaryLight,
        fontWeight: FontWeight.bold,
      ),
      onSelected: (val) {
        setState(() {
          _maxMinutes = val ? minutes : null;
        });
      },
    );
  }

  Widget _buildCuisineChip(String cuisine) {
    final isSel = _selectedCuisines.contains(cuisine);
    return FilterChip(
      label: Text(cuisine),
      selected: isSel,
      selectedColor: AppColors.primary,
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(
        color: isSel ? Colors.white : AppColors.textPrimaryLight,
        fontWeight: FontWeight.bold,
      ),
      onSelected: (val) {
        setState(() {
          if (val) {
            _selectedCuisines.add(cuisine);
          } else {
            _selectedCuisines.remove(cuisine);
          }
        });
      },
    );
  }

  Widget _buildMealChip(String meal) {
    final isSel = _mealType == meal;
    return ChoiceChip(
      label: Text(meal),
      selected: isSel,
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSel ? Colors.white : AppColors.textPrimaryLight,
        fontWeight: FontWeight.bold,
      ),
      onSelected: (val) {
        setState(() {
          _mealType = val ? meal : null;
        });
      },
    );
  }
}
