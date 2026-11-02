/// تصنيفات المكونات في المطبخ
enum IngredientCategory {
  vegetables('خضروات', '🥕'),
  meatAndPoultry('لحوم ودواجن', '🍗'),
  dairyAndEggs('ألبان وبيض', '🧀'),
  grainsAndPasta('حبوب ونشويات', '🍚'),
  spicesAndHerbs('توابل وأعشاب', '🌿'),
  staplesAndOils('أساسيات وزيوت', '🫒'),
  cannedAndSauces('معلبات وصلصات', '🥫'),
  fruits('فواكه', '🍎');

  final String label;
  final String emoji;
  const IngredientCategory(this.label, this.emoji);
}

/// نموذج المكون الفردي مع المرادفات بالعاميات المختلفة
class Ingredient {
  final String id;
  final String name;
  final IngredientCategory category;
  final String emoji;
  final bool isStaple;
  final List<String> synonyms;
  final int? shelfLifeDays;

  const Ingredient({
    required this.id,
    required this.name,
    required this.category,
    required this.emoji,
    this.isStaple = false,
    this.synonyms = const [],
    this.shelfLifeDays,
  });

  /// فحص ما إذا كان اسم المكون أو أي من مرادفاته يطابق كلمة البحث
  bool matchesSearch(String normalizedQuery) {
    if (name.contains(normalizedQuery)) return true;
    for (final syn in synonyms) {
      if (syn.contains(normalizedQuery)) return true;
    }
    return false;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category': category.name,
    'emoji': emoji,
    'isStaple': isStaple,
    'synonyms': synonyms,
    'shelfLifeDays': shelfLifeDays,
  };

  factory Ingredient.fromJson(Map<String, dynamic> json) => Ingredient(
    id: json['id'] as String,
    name: json['name'] as String,
    category: IngredientCategory.values.firstWhere(
      (e) => e.name == json['category'],
      orElse: () => IngredientCategory.vegetables,
    ),
    emoji: json['emoji'] as String? ?? '🥕',
    isStaple: json['isStaple'] as bool? ?? false,
    synonyms: (json['synonyms'] as List<dynamic>?)?.cast<String>() ?? [],
    shelfLifeDays: json['shelfLifeDays'] as int?,
  );
}
