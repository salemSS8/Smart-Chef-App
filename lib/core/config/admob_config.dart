import 'dart:io';

/// معرّفات إعلانات التطبيق (Monetag Direct Link + Google AdMob)
class AdMobConfig {
  AdMobConfig._();

  // رابط Monetag المباشر المخصص لتطبيق Smart Cook App (يعمل على APK خارج المتجر)
  static const String monetagDirectLinkUrl = 'https://uplcm.com/4/12174795';
  static const String monetagBannerZoneId = '12174847';

  // معرّفات إعلانات البانر التجريبية الرسمية من Google (احتياطي عند الرفع على Google Play)
  static const String androidBannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';
  static const String iosBannerAdUnitId = 'ca-app-pub-3940256099942544/2934735716';

  // معرّفات الإعلانات البينية (Interstitial Ads)
  static const String androidInterstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712';
  static const String iosInterstitialAdUnitId = 'ca-app-pub-3940256099942544/4411468910';

  // معرّفات إعلانات الفيديو بمكافأة (Rewarded Ads)
  static const String androidRewardedAdUnitId = 'ca-app-pub-3940256099942544/5224354917';
  static const String iosRewardedAdUnitId = 'ca-app-pub-3940256099942544/1712485313';

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
