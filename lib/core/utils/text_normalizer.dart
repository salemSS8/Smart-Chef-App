/// أدوات تطبيع وتوحيد النصوص العربية لتحسين البحث السريع عبر اللهجات
class TextNormalizer {
  static final RegExp _diacriticsRegex = RegExp(r'[\u064B-\u0652\u0670\u0640]');

  /// تطبيع النص العربي: إزالة التشكيل، توحيد الهمزات والتاء المربوطة والألف المقصورة
  static String normalize(String text) {
    if (text.isEmpty) return '';

    String result = text.trim().toLowerCase();

    // إزالة التشكيل والتطويل (ـ)
    result = result.replaceAll(_diacriticsRegex, '');

    // توحيد الألفات (أ، إ، آ، ٱ -> ا)
    result = result.replaceAll(RegExp(r'[أإآٱ]'), 'ا');

    // توحيد التاء المربوطة والهاء (ة -> ه)
    result = result.replaceAll('ة', 'ه');

    // توحيد الياء والألف المقصورة (ى -> ي)
    result = result.replaceAll('ى', 'ي');

    return result;
  }

  /// فحص ما إذا كان النص يحتوي على الاستعلام بعد التطبيع
  static bool matches(String source, String query) {
    final normSource = normalize(source);
    final normQuery = normalize(query);
    return normSource.contains(normQuery);
  }
}
