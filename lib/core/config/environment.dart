/// Enum representing the running application environment.
enum Environment {
  dev,
  staging,
  prod;

  bool get isDev => this == Environment.dev;
  bool get isStaging => this == Environment.staging;
  bool get isProd => this == Environment.prod;

  String get nameArabic {
    switch (this) {
      case Environment.dev:
        return 'بيئة التطوير';
      case Environment.staging:
        return 'بيئة الفحص والتكامل';
      case Environment.prod:
        return 'بيئة الإنتاج';
    }
  }
}
