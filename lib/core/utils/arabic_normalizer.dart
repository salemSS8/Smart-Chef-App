/// Utility class for normalizing Arabic text, unifying hamzas,
/// removing diacritics, and extracting ingredient tokens from natural voice/text sentences.
class ArabicNormalizer {
  static final RegExp _diacritics = RegExp(r'[\u064B-\u065F\u0670]');
  static final RegExp _tatweel = RegExp(r'\u0640');
  static final RegExp _delimiters = RegExp(r'[\s,،.\-+/:;\n\r]+');

  /// Words to ignore when analyzing free-form voice or text sentences
  static const Set<String> _stopWords = {
    'عندي',
    'عندنا',
    'في',
    'الثلاجه',
    'المطبخ',
    'يوجد',
    'لدي',
    'مع',
    'من',
    'بدون',
    'ابي',
    'اريد',
    'طبخ',
    'اكله',
    'وجبه',
    'اليوم',
    'شو',
    'ايش',
    'ماذا',
    'اطبخ',
    'بشو',
    'فقط',
    'و',
  };

  /// Normalizes Arabic text for flexible matching and search.
  /// Unifies Alef variations (أ, إ, آ -> ا), Yaa (ى -> ي),
  /// Taa Marbouta (ة -> ه), and removes all diacritics & tatweel.
  static String normalize(String text) {
    if (text.isEmpty) return '';

    return text
        .replaceAll(_diacritics, '')
        .replaceAll(_tatweel, '')
        .replaceAll('إ', 'ا')
        .replaceAll('أ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ى', 'ي')
        .replaceAll('ة', 'ه')
        .replaceAll('ؤ', 'و')
        .replaceAll('ئ', 'ي')
        .trim()
        .toLowerCase();
  }

  /// Extracts potential ingredient tokens from a conversational Arabic sentence.
  /// Example: "عندي بيض وطماطم وبصل في الثلاجة" -> ['بيض', 'طماطم', 'بصل']
  static List<String> extractIngredientNames(String sentence) {
    if (sentence.trim().isEmpty) return [];

    final tokens = sentence.split(_delimiters);
    final results = <String>[];

    for (final rawToken in tokens) {
      var token = rawToken.trim();
      if (token.isEmpty) continue;

      // Strip leading 'و' conjunction if attached to a word of length > 2 (e.g. 'وبصل' -> 'بصل')
      if (token.startsWith('و') && token.length > 2) {
        token = token.substring(1);
      }

      final normalized = normalize(token);

      if (normalized.length > 1 && !_stopWords.contains(normalized)) {
        results.add(token);
      }
    }

    return results;
  }

  /// Check whether a search query matches a target candidate string
  static bool isMatch(String query, String target) {
    final normQuery = normalize(query);
    final normTarget = normalize(target);
    if (normQuery.isEmpty || normTarget.isEmpty) return false;
    return normTarget.contains(normQuery);
  }
}
