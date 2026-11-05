import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/creator_recipe_service.dart';
import '../../core/services/gemini_ai_service.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/models/recipe.dart';
import 'creator_submissions_screen.dart';

class RecipeCreatorScreen extends ConsumerStatefulWidget {
  final Recipe? initialRecipe; // للتعديل إذا تم تمرير وصفة موجودة

  const RecipeCreatorScreen({super.key, this.initialRecipe});

  @override
  ConsumerState<RecipeCreatorScreen> createState() => _RecipeCreatorScreenState();
}

class _RecipeCreatorScreenState extends ConsumerState<RecipeCreatorScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _caloriesController;
  late TextEditingController _prepTimeController;
  late TextEditingController _cookTimeController;
  late TextEditingController _servingsController;
  late TextEditingController _imageUrlController;

  String _selectedCuisine = 'خليجي';
  String _selectedDifficulty = 'متوسط';
  final List<String> _selectedTags = ['عشاء فاخر', 'طبخ منزلي'];

  // المكونات التفاعلية
  final List<Map<String, dynamic>> _ingredientsList = [
    {'name': 'سمك قاروص كامل', 'amount': '1 حبة (700 غرام)', 'role': IngredientRole.core},
    {'name': 'ليمون أصفر طازج', 'amount': '2 حبة شرائح', 'role': IngredientRole.important},
    {'name': 'زعتر بري وروزماري', 'amount': '4 أعواد', 'role': IngredientRole.important},
    {'name': 'زيت زيتون بكر ممتاز', 'amount': '3 ملاعق كبيرة', 'role': IngredientRole.staple},
  ];

  // خطوات الطهي التفاعلية مع المؤقتات
  final List<Map<String, dynamic>> _stepsList = [
    {'text': 'تنظيف السمك وعمل شقوق طولية مائلة بعمق 1 سم لتشرب التتبيلة.', 'timer': 0},
    {'text': 'حشو بطن السمكة بشرائح الليمون والزعتر والملح الخشن وزيت الزيتون.', 'timer': 0},
    {'text': 'الشواء في فرن محمى على 200 درجة مئوية حتى يصبح الجلد مقرمشاً.', 'timer': 25},
  ];

  bool _isRightsAgreed = true;
  bool _isAiEnhancing = false;
  bool _isSubmitting = false;

  final List<String> _cuisines = [
    'خليجي',
    'شامي',
    'مصري',
    'مغاربي',
    'يمني',
    'إيطالي',
    'فرنسي',
    'آسيوي',
    'مكسيكي',
    'عالمي',
  ];

  final List<String> _difficulties = ['سهل', 'متوسط', 'متقدم / شيف'];

  @override
  void initState() {
    super.initState();
    final r = widget.initialRecipe;
    _titleController = TextEditingController(text: r?.title ?? '');
    _descriptionController = TextEditingController(text: r?.description ?? '');
    _caloriesController = TextEditingController(text: '${r?.calories ?? 480}');
    _prepTimeController = TextEditingController(text: '${r?.prepMinutes ?? 15}');
    _cookTimeController = TextEditingController(text: '${r?.cookMinutes ?? 25}');
    _servingsController = TextEditingController(text: '${r?.servings ?? 4}');
    _imageUrlController = TextEditingController(
      text: r?.heroImageUrl ??
          'https://images.unsplash.com/photo-1534422298391-e4f8c172dddb?auto=format&fit=crop&w=800&q=80',
    );

    if (r != null) {
      _selectedCuisine = r.cuisine;
      _selectedDifficulty = r.difficulty;
      _ingredientsList.clear();
      for (final ing in r.ingredients) {
        _ingredientsList.add({
          'name': ing.name,
          'amount': ing.amount,
          'role': ing.role,
        });
      }
      _stepsList.clear();
      for (final step in r.steps) {
        _stepsList.add({
          'text': step.text,
          'timer': (step.timerSeconds != null) ? (step.timerSeconds! ~/ 60) : 0,
        });
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _caloriesController.dispose();
    _prepTimeController.dispose();
    _cookTimeController.dispose();
    _servingsController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  // إضافة مكون جديد
  void _addIngredientDialog() {
    final nameCtrl = TextEditingController();
    final amountCtrl = TextEditingController(text: 'حسب الرغبة');
    var role = IngredientRole.important;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDlgState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('إضافة مكوّن جديد 🧂', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'اسم المكون (مثال: بصل، زعفران)'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: amountCtrl,
                decoration: const InputDecoration(labelText: 'الكمية (مثال: 2 ملعقة، 500 غرام)'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<IngredientRole>(
                initialValue: role,
                decoration: const InputDecoration(labelText: 'أهمية المكون في الطبق'),
                items: IngredientRole.values.map((r) {
                  return DropdownMenuItem(value: r, child: Text(r.label));
                }).toList(),
                onChanged: (val) {
                  if (val != null) setDlgState(() => role = val);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if (nameCtrl.text.trim().isNotEmpty) {
                  setState(() {
                    _ingredientsList.add({
                      'name': nameCtrl.text.trim(),
                      'amount': amountCtrl.text.trim(),
                      'role': role,
                    });
                  });
                  Navigator.pop(ctx);
                }
              },
              child: const Text('إضافة'),
            ),
          ],
        ),
      ),
    );
  }

  // إضافة خطوة جديدة
  void _addStepDialog() {
    final textCtrl = TextEditingController();
    final timerCtrl = TextEditingController(text: '0');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('إضافة خطوة تحضير 👨‍🍳', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'شرح الخطوة بدقة تحريرية...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: timerCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'مؤقت الخطوة بالدقائق (0 إن لم يتطلب وقتاً)',
                prefixIcon: Icon(Icons.timer_outlined),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              if (textCtrl.text.trim().isNotEmpty) {
                final mins = int.tryParse(timerCtrl.text.trim()) ?? 0;
                setState(() {
                  _stepsList.add({
                    'text': textCtrl.text.trim(),
                    'timer': mins,
                  });
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text('إضافة الخطوة'),
          ),
        ],
      ),
    );
  }

  // تحسين الذكاء الاصطناعي بواسطة Gemini
  Future<void> _enhanceWithAi() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى كتابة اسم الطبق أولاً ليتمكن الذكاء الاصطناعي من تحسينه')),
      );
      return;
    }

    setState(() => _isAiEnhancing = true);
    try {
      final ingredientsNames = _ingredientsList.map((e) => e['name'].toString()).toList();
      final geminiService = ref.read(geminiAiServiceProvider);
      final generated = await geminiService.generateRecipeFromPantry(
        pantryIngredients: ingredientsNames,
        cuisinePreference: _selectedCuisine,
      );

      if (mounted) {
        setState(() {
          if (_descriptionController.text.trim().isEmpty) {
            _descriptionController.text = generated.description;
          }
          // دمج خطوات ونصائح الشيف
          for (final step in generated.steps) {
            if (!_stepsList.any((s) => s['text'] == step.text)) {
              _stepsList.add({
                'text': step.text,
                'timer': (step.timerSeconds != null) ? (step.timerSeconds! ~/ 60) : 0,
              });
            }
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppColors.primary,
            content: Text('✨ قام استوديو الذكاء الاصطناعي بتنقيح الخطوات وإضافة إرشادات الشيف!'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تعذر استدعاء الذكاء الاصطناعي: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isAiEnhancing = false);
    }
  }

  // تجميع الوصفة وحفظها / إرسالها
  Future<void> _submitRecipe({required bool isDraft}) async {
    if (!isDraft && !_formKey.currentState!.validate()) {
      return;
    }

    if (!isDraft && !_isRightsAgreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى الموافقة على إقرار حقوق النشر وأصالة المحتوى')),
      );
      return;
    }

    if (_ingredientsList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إضافة مكون واحد على الأقل للوصفة')),
      );
      return;
    }

    if (_stepsList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إضافة خطوة طهي واحدة على الأقل')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final recipeId = widget.initialRecipe?.id ?? 'user_${DateTime.now().millisecondsSinceEpoch}';

      final builtIngredients = _ingredientsList.asMap().entries.map((entry) {
        final idx = entry.key;
        final map = entry.value;
        return RecipeIngredient(
          ingredientId: 'ing_${recipeId}_$idx',
          name: map['name'] as String,
          role: map['role'] as IngredientRole,
          amount: map['amount'] as String,
        );
      }).toList();

      final builtSteps = _stepsList.asMap().entries.map((entry) {
        final idx = entry.key;
        final map = entry.value;
        final timerMins = map['timer'] as int? ?? 0;
        return RecipeStep(
          stepNo: idx + 1,
          text: map['text'] as String,
          timerSeconds: timerMins > 0 ? timerMins * 60 : null,
        );
      }).toList();

      final recipe = Recipe(
        id: recipeId,
        title: _titleController.text.trim().isNotEmpty ? _titleController.text.trim() : 'وصفة بدون عنوان',
        description: _descriptionController.text.trim(),
        cuisine: _selectedCuisine,
        difficulty: _selectedDifficulty,
        prepMinutes: int.tryParse(_prepTimeController.text) ?? 15,
        cookMinutes: int.tryParse(_cookTimeController.text) ?? 25,
        servings: int.tryParse(_servingsController.text) ?? 4,
        calories: int.tryParse(_caloriesController.text) ?? 450,
        heroImageUrl: _imageUrlController.text.trim(),
        tags: _selectedTags,
        verified: false,
        ingredients: builtIngredients,
        steps: builtSteps,
      );

      final status = isDraft ? 'draft' : 'pending_review';
      final ok = await CreatorRecipeService.submitRecipe(recipe: recipe, status: status);

      if (mounted) {
        if (ok) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (ctx) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              title: Row(
                children: [
                  Icon(
                    isDraft ? Icons.save_rounded : Icons.check_circle_rounded,
                    color: isDraft ? AppColors.accentGold : AppColors.primary,
                    size: 30,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    isDraft ? 'تم حفظ المسودة 📝' : 'تم إرسال الوصفة بنجاح! 🚀',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              content: Text(
                isDraft
                    ? 'تم حفظ وصفتك في المسودات المحلية، يمكنك استكمالها في أي وقت.'
                    : 'تم إرسال الوصفة بنجاح إلى قاعدة البيانات المشتركة (Supabase) وستظهر في لوحة تحكم المشرف (Dashboard) لمراجعتها واعتمادها للنشر العالمي!',
                style: const TextStyle(height: 1.5),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx); // Close dialog
                    Navigator.pop(context); // Close creator screen
                  },
                  child: const Text('العودة للرئيسية'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const CreatorSubmissionsScreen()),
                    );
                  },
                  child: const Text('متابعة حالة الوصفات 📋'),
                ),
              ],
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('حدث خطأ أثناء حفظ الوصفة. يرجى المحاولة ثانية')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ غير متوقع: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('استوديو ابتكار الوصفات 👨‍🍳', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.bookmark_border_rounded, size: 20),
            label: const Text('مسودة'),
            onPressed: _isSubmitting ? null : () => _submitRecipe(isDraft: true),
          ),
          IconButton(
            icon: const Icon(Icons.list_alt_rounded),
            tooltip: 'وصفاتي المقدمة',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreatorSubmissionsScreen()),
              );
            },
          ),
        ],
      ),
      body: _isSubmitting
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.primary),
                  SizedBox(height: 16),
                  Text('جاري إرسال الوصفة ومزامنتها مع الخادم والداشبورد...'),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // بنر استوديو الذكاء الاصطناعي (AI Studio)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, Color(0xFF093425)],
                          begin: AlignmentDirectional.topStart,
                          end: AlignmentDirectional.bottomEnd,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withAlpha(40),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(25),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.auto_awesome, color: AppColors.accentGold, size: 28),
                          ),
                          const SizedBox(width: 14),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'مساعد الشيف بالذكاء الاصطناعي ✨',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'تنقيح صياغة الخطوات واقتراح بهارات وتوافق النكهات العالمية',
                                  style: TextStyle(color: Colors.white70, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accentGold,
                              foregroundColor: AppColors.darkBackground,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: _isAiEnhancing ? null : _enhanceWithAi,
                            child: _isAiEnhancing
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                                  )
                                : const Text('استعن بـ AI', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // غلاف الوصفة 16:9
                    const Text('صورة غلاف الوصفة 📸', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              _imageUrlController.text.trim().isNotEmpty
                                  ? _imageUrlController.text.trim()
                                  : 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=800&q=80',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: AppColors.secondaryCream,
                                child: const Center(
                                  child: Icon(Icons.image_not_supported_rounded, size: 40, color: AppColors.secondary),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 12,
                              left: 12,
                              right: 12,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withAlpha(150),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Text('نسبة 16:9 تحريرية', style: TextStyle(color: Colors.white, fontSize: 12)),
                                  ),
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: AppColors.primary,
                                      elevation: 0,
                                    ),
                                    icon: const Icon(Icons.edit_rounded, size: 16),
                                    label: const Text('تغيير الرابط'),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: const Text('رابط صورة الوصفة'),
                                          content: TextField(
                                            controller: _imageUrlController,
                                            decoration: const InputDecoration(hintText: 'https://...'),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                setState(() {});
                                                Navigator.pop(ctx);
                                              },
                                              child: const Text('حفظ'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // تفاصيل الوصفة الأساسية
                    const Text('المعلومات والقصة التحريرية ✍️', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'عنوان الوصفة المبتكرة *',
                        hintText: 'مثال: سمك قاروص مشوي بالأعشاب والليمون المعتق',
                        prefixIcon: Icon(Icons.restaurant_menu_rounded),
                      ),
                      validator: (val) => val == null || val.trim().isEmpty ? 'عنوان الوصفة مطلوب' : null,
                    ),

                    const SizedBox(height: 14),

                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'قصة الطبق وملاحظات الشيف',
                        hintText: 'احتفال ببساطة المطبخ الساحلي مع لمسات من زيت الزيتون البكر...',
                        prefixIcon: Icon(Icons.auto_stories_rounded),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // شبكة المقاييس
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: _selectedCuisine,
                            decoration: const InputDecoration(labelText: 'المطبخ 🌍'),
                            items: _cuisines.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                            onChanged: (v) => setState(() => _selectedCuisine = v!),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: _selectedDifficulty,
                            decoration: const InputDecoration(labelText: 'الصعوبة 🎯'),
                            items: _difficulties.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                            onChanged: (v) => setState(() => _selectedDifficulty = v!),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _prepTimeController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'تحضير (دقيقة)',
                              prefixIcon: Icon(Icons.timer_outlined),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            controller: _cookTimeController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'طهي (دقيقة)',
                              prefixIcon: Icon(Icons.microwave_outlined),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            controller: _servingsController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'الحصص',
                              prefixIcon: Icon(Icons.people_outline_rounded),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // مخطط المكونات (Ingredient Blueprint)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('مخطط المكونات (Blueprint) 🥦', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(color: AppColors.primary),
                          ),
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('إضافة مكوّن'),
                          onPressed: _addIngredientDialog,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _ingredientsList.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 8),
                      itemBuilder: (ctx, idx) {
                        final item = _ingredientsList[idx];
                        final role = item['role'] as IngredientRole;
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceCream,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.borderLight),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: role == IngredientRole.core
                                      ? AppColors.accentTomato
                                      : (role == IngredientRole.important ? AppColors.accentGold : AppColors.primary),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['name'],
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                    ),
                                    Text(
                                      '${role.label} • ${item['amount']}',
                                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
                                onPressed: () {
                                  setState(() => _ingredientsList.removeAt(idx));
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 28),

                    // خطوات الطهي (Culinary Sequence)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('خطوات الطهي والمؤقتات ⏱️', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(color: AppColors.primary),
                          ),
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('إضافة خطوة'),
                          onPressed: _addStepDialog,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _stepsList.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 10),
                      itemBuilder: (ctx, idx) {
                        final step = _stepsList[idx];
                        final timer = step['timer'] as int? ?? 0;
                        return Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.borderLight),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 14,
                                backgroundColor: AppColors.primary,
                                child: Text('${idx + 1}', style: const TextStyle(color: Colors.white, fontSize: 12)),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(step['text'], style: const TextStyle(fontSize: 14, height: 1.4)),
                                    if (timer > 0) ...[
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          const Icon(Icons.alarm_rounded, color: AppColors.accentTomato, size: 16),
                                          const SizedBox(width: 4),
                                          Text(
                                            'مؤقت تفاعلي: $timer دقيقة',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: AppColors.accentTomato,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close_rounded, size: 18, color: Colors.grey),
                                onPressed: () {
                                  setState(() => _stepsList.removeAt(idx));
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 28),

                    // إقرار الحقوق والأصالة
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryCream,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: CheckboxListTile(
                        value: _isRightsAgreed,
                        contentPadding: EdgeInsets.zero,
                        activeColor: AppColors.primary,
                        title: const Text(
                          'أتعهد بأن هذه الوصفة أصلية من ابتكاري ومطابقة للمعايير التحريرية وحقوق النشر لـ Smart Cook.',
                          style: TextStyle(fontSize: 13, height: 1.4, fontWeight: FontWeight.bold),
                        ),
                        subtitle: const Text(
                          'تخضع كافة الوصفات للمراجعة البشرية من الإدارة قبل ظهورها للجمهور العالمي.',
                          style: TextStyle(fontSize: 11, color: AppColors.textSecondaryLight),
                        ),
                        onChanged: (v) => setState(() => _isRightsAgreed = v ?? false),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // زر الإرسال للمراجعة والداشبورد
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: _isSubmitting ? null : () => _submitRecipe(isDraft: false),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.send_rounded, size: 20),
                            SizedBox(width: 10),
                            Text(
                              'إرسال للمراجعة والاعتماد التحريري 🚀',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
    );
  }
}
