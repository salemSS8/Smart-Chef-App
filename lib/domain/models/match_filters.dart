/// Model representing filter criteria applied during recipe matching.
class MatchFilters {
  final int? maxMinutes;
  final int? maxDifficulty; // 1=Easy, 2=Medium, 3=Hard
  final List<String> selectedCuisines;
  final List<String> mealTypes; // 'إفطار', 'غداء', 'عشاء', 'سريع', etc.
  final Set<String> allergensToExclude;
  final Set<String> dietFlags; // 'keto', 'vegan', 'vegetarian', 'low_carb'
  final bool assumeStaples;
  final bool onlyReadyNow;
  final int maxMissing;

  const MatchFilters({
    this.maxMinutes,
    this.maxDifficulty,
    this.selectedCuisines = const [],
    this.mealTypes = const [],
    this.allergensToExclude = const {},
    this.dietFlags = const {},
    this.assumeStaples = true,
    this.onlyReadyNow = false,
    this.maxMissing = 3,
  });

  MatchFilters copyWith({
    int? maxMinutes,
    int? maxDifficulty,
    List<String>? selectedCuisines,
    List<String>? mealTypes,
    Set<String>? allergensToExclude,
    Set<String>? dietFlags,
    bool? assumeStaples,
    bool? onlyReadyNow,
    int? maxMissing,
  }) {
    return MatchFilters(
      maxMinutes: maxMinutes ?? this.maxMinutes,
      maxDifficulty: maxDifficulty ?? this.maxDifficulty,
      selectedCuisines: selectedCuisines ?? this.selectedCuisines,
      mealTypes: mealTypes ?? this.mealTypes,
      allergensToExclude: allergensToExclude ?? this.allergensToExclude,
      dietFlags: dietFlags ?? this.dietFlags,
      assumeStaples: assumeStaples ?? this.assumeStaples,
      onlyReadyNow: onlyReadyNow ?? this.onlyReadyNow,
      maxMissing: maxMissing ?? this.maxMissing,
    );
  }

  /// Clean default filters
  static const MatchFilters defaultFilters = MatchFilters();
}
