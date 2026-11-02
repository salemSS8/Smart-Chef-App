import 'dart:io';

/// إعدادات ومفاتيح الربط مع منصة RevenueCat لإدارة اشتراكات Google Play و App Store
class RevenueCatConfig {
  RevenueCatConfig._();

  /// المفتاح العام التجريبي لـ Android (يُستبدل بمفتاحك من لوحة تحكم RevenueCat)
  static const String googleApiKey = 'goog_sample_key_placeholder';

  /// المفتاح العام التجريبي لـ iOS
  static const String appleApiKey = 'appl_sample_key_placeholder';

  /// المعرّف الموحد للصلاحية البرمجية (Entitlement ID) المخصص للمشتركين
  static const String proEntitlementId = 'pro';

  /// جلب المفتاح المناسب لنظام التشغيل الحالي
  static String get apiKey {
    if (Platform.isAndroid) {
      return googleApiKey;
    } else if (Platform.isIOS) {
      return appleApiKey;
    }
    return '';
  }
}

