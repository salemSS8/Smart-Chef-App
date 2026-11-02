import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/gemini_ai_service.dart';
import '../../core/theme/app_colors.dart';
import '../../data/mock/ingredients_data.dart';
import '../../domain/models/recipe.dart';
import '../providers/favorites_provider.dart';
import '../providers/pantry_provider.dart';
import 'cook_mode_screen.dart';

class AiInspireScreen extends ConsumerStatefulWidget {
  const AiInspireScreen({super.key});

  @override
  ConsumerState<AiInspireScreen> createState() => _AiInspireScreenState();
}

class _AiInspireScreenState extends ConsumerState<AiInspireScreen> {
  bool _isGenerating = false;
  bool? _userFeedback; // true for up, false for down

  // Sample AI generated recipe
  late Recipe _generatedRecipe;

  @override
  void initState() {
    super.initState();
    _createAiRecipe();
  }

  void _createAiRecipe() {
    final pantry = ref.read(pantryProvider);
    final hasChicken = pantry.contains('ing_chicken_breast');
    final hasEggs = pantry.contains('ing_eggs');

    if (hasChicken) {
      _generatedRecipe = const Recipe(
        id: 'ai_chicken_skillet',
        title: 'طاجن الدجاج المبتكر بالخضار المسبكة',
        description: 'وصفة سريعة ابتكرها الذكاء الاصطناعي لتجمع بين قطع الدجاج المتبلة مع البصل والطماطم والبطاطس في مقلاة واحدة.',
        cuisine: 'ابتكار ذكي',
        difficulty: 'سهل',
        prepMinutes: 10,
        cookMinutes: 20,
        servings: 3,
        calories: 390,
        heroImageUrl: 'https://images.unsplash.com/photo-1598515214211-89d3c73ae83b?auto=format&fit=crop&w=800&q=80',
        tags: ['ابتكار ذكي', 'سريع', 'دجاج'],
        verified: false,
        ingredients: [
          RecipeIngredient(
            ingredientId: 'ing_chicken_breast',
            name: 'صدور دجاج',
            role: IngredientRole.core,
            amount: '400 غرام',
            displayText: 'قطع دجاج مقطعة مكعبات',
          ),
          RecipeIngredient(
            ingredientId: 'ing_potato',
            name: 'بطاطس',
            role: IngredientRole.important,
            amount: '2 حبة',
            displayText: 'بطاطس مقطعة مكعبات صغيرة',
          ),
          RecipeIngredient(
            ingredientId: 'ing_tomato',
            name: 'طماطم',
            role: IngredientRole.important,
            amount: '2 حبة',
            displayText: 'طماطم مفرومة مع عصيرها',
          ),
          RecipeIngredient(
            ingredientId: 'ing_onion',
            name: 'بصل',
            role: IngredientRole.important,
            amount: '1 حبة',
            displayText: 'بصلة مقطعة شرائح',
          ),
          RecipeIngredient(
            ingredientId: 'ing_oil_vegetable',
            name: 'زيت نباتي',
            role: IngredientRole.staple,
            amount: 'ملعقتان كبيرتان',
          ),
        ],
        steps: [
          RecipeStep(
            stepNo: 1,
            text: 'في مقلاة ساخنة، شوّح البصل والبطاطس في الزيت لمدة 5 دقائق حتى تبدأ أطراف البطاطس بالتحمير.',
            timerSeconds: 300,
          ),
          RecipeStep(
            stepNo: 2,
            text: 'أضف قطع الدجاج والبهارات المتوفرة لديك، وقلّب حتى يتغير لون الدجاج تماماً.',
            timerSeconds: 360,
          ),
          RecipeStep(
            stepNo: 3,
            text: 'أضف الطماطم ونصف كوب ماء دافئ، غطّ المقلاة واتركها على نار هادئة حتى ينضج الدجاج والبطاطس بالكامل.',
            timerSeconds: 600,
          ),
        ],
      );
    } else if (hasEggs) {
      _generatedRecipe = const Recipe(
        id: 'ai_egg_vegetable_bake',
        title: 'صينية البيض الذهبي بالخضار والجبن',
        description: 'ابتكار خفيف لعشاء شهي يجمع البيض المخفوق مع الخضار المشوحة ورشة جبن ذائبة.',
        cuisine: 'ابتكار ذكي',
        difficulty: 'سهل جداً',
        prepMinutes: 5,
        cookMinutes: 10,
        servings: 2,
        calories: 260,
        heroImageUrl: 'https://images.unsplash.com/photo-1525351484163-7529414344d8?auto=format&fit=crop&w=800&q=80',
        tags: ['ابتكار ذكي', 'عشاء', 'سريع', 'بيض'],
        verified: false,
        ingredients: [
          RecipeIngredient(
            ingredientId: 'ing_eggs',
            name: 'بيض',
            role: IngredientRole.core,
            amount: '4 حبات',
            displayText: '4 حبات بيض مخفوقة',
          ),
          RecipeIngredient(
            ingredientId: 'ing_bell_pepper',
            name: 'فلفل رومي',
            role: IngredientRole.important,
            amount: '1 حبة',
            displayText: 'فلفل رومي مفروم ناعم',
          ),
          RecipeIngredient(
            ingredientId: 'ing_cheese_mozzarella',
            name: 'جبن موزاريلا',
            role: IngredientRole.optional,
            amount: 'نصف كوب',
            displayText: 'جبن مبشور للوجه',
          ),
        ],
        steps: [
          RecipeStep(
            stepNo: 1,
            text: 'شوّح الفلفل الرومي في مقلاة مدهونة بقليل من الزيت لمدة دقيقتين.',
            timerSeconds: 120,
          ),
          RecipeStep(
            stepNo: 2,
            text: 'اسكب البيض المخفوق ورش الجبن على الوجه، غطّ المقلاة على نار هادئة لـ 6 دقائق حتى تتماسك.',
            timerSeconds: 360,
          ),
        ],
      );
    } else {
      _generatedRecipe = const Recipe(
        id: 'ai_quick_veggie_saute',
        title: 'طبق الخضار السريع بزيت الزيتون والليمون',
        description: 'وصفة نباتية منعشة محضرة من الخضار المتاحة في مطبخك بنكهة زيت الزيتون والليمون.',
        cuisine: 'ابتكار ذكي',
        difficulty: 'سهل',
        prepMinutes: 5,
        cookMinutes: 10,
        servings: 2,
        calories: 190,
        heroImageUrl: 'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=800&q=80',
        tags: ['نباتي', 'سريع', 'خضار'],
        verified: false,
        ingredients: [
          RecipeIngredient(
            ingredientId: 'ing_tomato',
            name: 'طماطم',
            role: IngredientRole.core,
            amount: '2 حبة',
          ),
          RecipeIngredient(
            ingredientId: 'ing_cucumber',
            name: 'خيار',
            role: IngredientRole.core,
            amount: '2 حبة',
          ),
          RecipeIngredient(
            ingredientId: 'ing_olive_oil',
            name: 'زيت زيتون',
            role: IngredientRole.staple,
            amount: 'ملعقة كبيرة',
          ),
        ],
        steps: [
          RecipeStep(
            stepNo: 1,
            text: 'قطّع الخضار إلى مكعبات متساوية واخلطها مع رشة ملح وزيت الزيتون.',
          ),
        ],
      );
    }
  }

  Future<void> _regenerate() async {
    setState(() {
      _isGenerating = true;
      _userFeedback = null;
    });

    try {
      final pantryIds = ref.read(pantryProvider);
      final ingredientNames = pantryIds.map((id) {
        final matches = IngredientsData.allIngredients.where((i) => i.id == id);
        return matches.isNotEmpty ? matches.first.name : id;
      }).toList();

      final aiService = ref.read(geminiAiServiceProvider);
      final recipe = await aiService.generateRecipeFromPantry(
        pantryIngredients: ingredientNames,
      );

      if (mounted) {
        setState(() {
          _generatedRecipe = recipe;
          _isGenerating = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تعذر التوليد عبر الإنترنت حالياً، تم عرض وصفة مقترحة.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isFav = ref.watch(favoritesProvider).contains(_generatedRecipe.id);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ألهمني بالذكاء الاصطناعي ✨'),
      ),
      body: _isGenerating
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: AppColors.primary),
                  const SizedBox(height: 20),
                  Text(
                    'يبتكر الذكاء الاصطناعي طبقاً جديداً من مكوناتك...',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    _generatedRecipe.title,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  // Transparency Badge (Mandatory requirement)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.amber.shade900.withAlpha(40) : Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.amber.shade400, width: 1.2),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.auto_awesome, color: Colors.amber, size: 22),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'مقترحة بالذكاء الاصطناعي — غير مُجرَّبة',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Colors.brown,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                'تنبيه سلامة: تأكد من طهي اللحوم والدواجن جيداً حتى تمام النضج والتأكد من ملاءمة المكونات لنظامك.',
                                style: TextStyle(fontSize: 12, color: Colors.brown),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),
                  Text(
                    _generatedRecipe.description,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Ingredients
                  const Text('المكونات المطلوبة:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ..._generatedRecipe.ingredients.map((ing) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle_outline_rounded, size: 18, color: AppColors.secondary),
                          const SizedBox(width: 8),
                          Text(ing.displayText ?? '${ing.name} (${ing.amount})', style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 20),

                  // Steps
                  const Text('طريقة الإعداد:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ..._generatedRecipe.steps.map((st) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: AppColors.primary,
                            child: Text('${st.stepNo}', style: const TextStyle(color: Colors.white, fontSize: 11)),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(st.text, style: const TextStyle(fontSize: 14, height: 1.4)),
                          ),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 24),

                  // Feedback Section (Using icons NOT emojis as strictly specified!)
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'ما رأيك بهذا الاقتراح؟',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                _userFeedback == true ? Icons.thumb_up_alt_rounded : Icons.thumb_up_alt_outlined,
                                color: _userFeedback == true ? AppColors.secondary : Colors.grey,
                              ),
                              tooltip: 'أعجبني',
                              onPressed: () {
                                setState(() {
                                  _userFeedback = true;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('شكراً لملاحظتك! سنقترح وصفات مشابهة.')),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                _userFeedback == false ? Icons.thumb_down_alt_rounded : Icons.thumb_down_alt_outlined,
                                color: _userFeedback == false ? AppColors.danger : Colors.grey,
                              ),
                              tooltip: 'لم يعجبني',
                              onPressed: () {
                                setState(() {
                                  _userFeedback = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('شكراً لملاحظتك! سنتجنب هذا النمط.')),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Actions
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _regenerate,
                          icon: const Icon(Icons.refresh_rounded),
                          label: const Text('أعد التوليد'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            ref.read(favoritesProvider.notifier).toggleFavorite(_generatedRecipe.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(isFav ? 'تم الحذف من المفضلة' : 'تم حفظ الوصفة في مفضلتك 💾'),
                              ),
                            );
                          },
                          icon: Icon(isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded, color: isFav ? Colors.red : null),
                          label: Text(isFav ? 'محفوظة' : 'احفظ الوصفة'),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CookModeScreen(recipe: _generatedRecipe),
                        ),
                      );
                    },
                    icon: const Icon(Icons.soup_kitchen_rounded),
                    label: const Text('ابدأ الطهي الآن 🍳'),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
    );
  }
}
