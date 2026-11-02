import 'dart:io';

/// معرّفات إعلانات Google AdMob (متوقفة افتراضياً إلى حين التفعيل من لوحة التحكم)
class AdMobConfig {
  AdMobConfig._();

  static const String androidBannerAdUnitId = '';
  static const String iosBannerAdUnitId = '';

  static const String androidInterstitialAdUnitId = '';
  static const String iosInterstitialAdUnitId = '';

  static const String androidRewardedAdUnitId = '';
  static const String iosRewardedAdUnitId = '';

  static String get bannerAdUnitId {
    if (Platform.isAndroid) return androidBannerAdUnitId;
    if (Platform.isIOS) return iosBannerAdUnitId;
    return '';
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) return androidInterstitialAdUnitId;
    if (Platform.isIOS) return iosInterstitialAdUnitId;
    return '';
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) return androidRewardedAdUnitId;
    if (Platform.isIOS) return iosRewardedAdUnitId;
    return '';
  }
}
