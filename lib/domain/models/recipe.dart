/// درجة أهمية المكون في الوصفة (كما تم تحديده في وثيقة الخوارزمية 07)
enum IngredientRole {
  core('أساسي'),          // يعرّف الطبق (مثلاً: الدجاج في الكبسة)
  important('مهم'),        // يؤثر كثيراً (بصل، طماطم، بهارات معينة)
  optional('اختياري'),     // تحسين إضافي (مكسرات أو بقدونس للتزيين)
  staple('أساسي مفترض');  // ماء، ملح، زيت (يُفترض وجوده في أي مطبخ)

  final String label;
  const IngredientRole(this.label);
}

/// مكون ضمن وصفة محددة
class RecipeIngredient {
  final String ingredientId;
  final String name;
  final IngredientRole role;
  final String amount;
  final String? displayText;
  final String? substituteNote; // مثل: "يمكن استبدال الكريمة بالحليب + قليل من الزبدة"

  const RecipeIngredient({
    required this.ingredientId,
    required this.name,
    required this.role,
    required this.amount,
    this.displayText,
    this.substituteNote,
  });

  Map<String, dynamic> toJson() => {
    'ingredientId': ingredientId,
    'name': name,
    'role': role.name,
    'amount': amount,
    'displayText': displayText,
    'substituteNote': substituteNote,
  };

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) => RecipeIngredient(
    ingredientId: json['ingredientId'] as String,
    name: json['name'] as String,
    role: IngredientRole.values.firstWhere(
      (e) => e.name == json['role'],
      orElse: () => IngredientRole.important,
    ),
    amount: json['amount'] as String,
    displayText: json['displayText'] as String?,
    substituteNote: json['substituteNote'] as String?,
  );
}

/// خطوة طهي ضمن الوصفة
class RecipeStep {
  final int stepNo;
  final String text;
  final int? timerSeconds; // للمؤقت التفاعلي أثناء وضع الطهي
  final String? tip;

  const RecipeStep({
    required this.stepNo,
    required this.text,
    this.timerSeconds,
    this.tip,
  });

  Map<String, dynamic> toJson() => {
    'stepNo': stepNo,
    'text': text,
    'timerSeconds': timerSeconds,
    'tip': tip,
  };

  factory RecipeStep.fromJson(Map<String, dynamic> json) => RecipeStep(
    stepNo: json['stepNo'] as int,
    text: json['text'] as String,
    timerSeconds: json['timerSeconds'] as int?,
    tip: json['tip'] as String?,
  );
}

/// نموذج الوصفة الكاملة
class Recipe {
  final String id;
  final String title;
  final String description;
  final String cuisine; // خليجي، شامي، مصري، مغاربي، عالمي
  final String difficulty; // سهل، متوسط، متقدم
  final int prepMinutes;
  final int cookMinutes;
  final int servings;
  final int calories;
  final String heroImageUrl;
  final List<String> tags;
  final bool verified;
  final List<RecipeIngredient> ingredients;
  final List<RecipeStep> steps;

  const Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.cuisine,
    required this.difficulty,
    required this.prepMinutes,
    required this.cookMinutes,
    required this.servings,
    required this.calories,
    required this.heroImageUrl,
    required this.tags,
    this.verified = true,
    required this.ingredients,
    required this.steps,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'cuisine': cuisine,
    'difficulty': difficulty,
    'prep_minutes': prepMinutes,
    'cook_minutes': cookMinutes,
    'servings': servings,
    'calories': calories,
    'hero_image_url': heroImageUrl,
    'tags': tags,
    'verified': verified,
    'ingredients': ingredients.map((e) => e.toJson()).toList(),
    'steps': steps.map((e) => e.toJson()).toList(),
  };

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
    id: json['id'] as String,
    title: json['title'] as String,
    description: (json['description'] as String?) ?? '',
    cuisine: (json['cuisine'] as String?) ?? 'خليجي',
    difficulty: (json['difficulty'] as String?) ?? 'سهل',
    prepMinutes: (json['prep_minutes'] ?? json['prepMinutes'] ?? 15) as int,
    cookMinutes: (json['cook_minutes'] ?? json['cookMinutes'] ?? 30) as int,
    servings: (json['servings'] ?? 4) as int,
    calories: (json['calories'] ?? 400) as int,
    heroImageUrl: (json['hero_image_url'] ?? json['heroImageUrl'] ?? '') as String,
    tags: (json['tags'] as List?)?.map((e) => e.toString()).toList() ?? const [],
    verified: (json['verified'] as bool?) ?? true,
    ingredients: (json['ingredients'] as List?)
            ?.map((e) => RecipeIngredient.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList() ??
        const [],
    steps: (json['steps'] as List?)
            ?.map((e) => RecipeStep.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList() ??
        const [],
  );

  int get totalMinutes => prepMinutes + cookMinutes;

  /// حساب حالة المطابقة بناءً على المكونات المتوفرة لدى المستخدم
  RecipeMatchResult evaluateMatch(Set<String> userPantryIds) {
    int totalCore = 0;
    int availableCore = 0;
    int totalImportant = 0;
    int availableImportant = 0;

    final List<RecipeIngredient> missingIngredients = [];
    final List<RecipeIngredient> availableIngredients = [];

    for (final item in ingredients) {
      // المكونات المفترضة (ملح، ماء، زيت) نعتبرها متوفرة دائماً
      final isAvailable = item.role == IngredientRole.staple || userPantryIds.contains(item.ingredientId);

      if (isAvailable) {
        availableIngredients.add(item);
        if (item.role == IngredientRole.core) {
          totalCore++;
          availableCore++;
        } else if (item.role == IngredientRole.important) {
          totalImportant++;
          availableImportant++;
        }
      } else {
        missingIngredients.add(item);
        if (item.role == IngredientRole.core) {
          totalCore++;
        } else if (item.role == IngredientRole.important) {
          totalImportant++;
        }
      }
    }

    final double coreRatio = totalCore == 0 ? 1.0 : (availableCore / totalCore);
    final double importantRatio = totalImportant == 0 ? 1.0 : (availableImportant / totalImportant);

    // نسبة التغطية الكلية (مرجحة: 65% للأساسي، 35% للمهم)
    final double score = (coreRatio * 0.65) + (importantRatio * 0.35);

    // عدد العناصر الهامة والأساسية الناقصة
    final int missingKeyCount = (totalCore - availableCore) + (totalImportant - availableImportant);

    return RecipeMatchResult(
      recipe: this,
      score: score,
      coreRatio: coreRatio,
      importantRatio: importantRatio,
      missingCount: missingKeyCount,
      missingIngredients: missingIngredients,
      availableIngredients: availableIngredients,
      isFullyReady: missingKeyCount == 0 && coreRatio == 1.0,
      isMissingOne: missingKeyCount == 1,
    );
  }
}

/// نتيجة فحص تطابق الوصفة
class RecipeMatchResult {
  final Recipe recipe;
  final double score; // من 0.0 إلى 1.0
  final double coreRatio;
  final double importantRatio;
  final int missingCount;
  final List<RecipeIngredient> missingIngredients;
  final List<RecipeIngredient> availableIngredients;
  final bool isFullyReady;
  final bool isMissingOne;

  const RecipeMatchResult({
    required this.recipe,
    required this.score,
    required this.coreRatio,
    required this.importantRatio,
    required this.missingCount,
    required this.missingIngredients,
    required this.availableIngredients,
    required this.isFullyReady,
    required this.isMissingOne,
  });

  int get matchPercentage => (score * 100).round().clamp(0, 100);
}
