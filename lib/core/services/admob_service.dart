import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/admob_config.dart';
import 'remote_config_service.dart';

class AdMobService {
  AdMobService._();

  static bool _isInitialized = false;

  /// الحصول على رابط Monetag المباشر (قابل للتغيير عن بُعد من الداش بورد إذا بدأ بـ http)
  static String get activeMonetagUrl {
    final remoteVal = RemoteConfigService.current.androidBannerId.trim();
    if (remoteVal.startsWith('http://') || remoteVal.startsWith('https://')) {
      return remoteVal;
    }
    return AdMobConfig.monetagDirectLinkUrl;
  }

  /// فتح إعلان Monetag المباشر (Smart Cook App - Zone 12174795) داخل متصفح التطبيق المدمج
  static Future<void> openMonetagDirectAd() async {
    if (!RemoteConfigService.current.adsEnabled) return;
    try {
      final uri = Uri.parse(activeMonetagUrl);
      final openedInApp = await launchUrl(
        uri,
        mode: LaunchMode.inAppBrowserView,
      );
      if (!openedInApp) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('خطأ في فتح رابط Monetag الإعلاني: $e');
    }
  }

  /// تهيئة حزمة إعلانات الهاتف المحمول
  static Future<void> initialize() async {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      try {
        await MobileAds.instance.initialize();
        _isInitialized = true;
        debugPrint('Mobile Ads تم تهيئتها بنجاح.');
      } catch (e) {
        debugPrint('خطأ في تهيئة Mobile Ads: $e');
      }
    }
  }

  /// إنشاء إعلان بانر جاهز للتحميل
  static BannerAd? createBannerAd({
    required Function(Ad) onAdLoaded,
    required Function(Ad, LoadAdError) onAdFailedToLoad,
  }) {
    if (!_isMobilePlatform) return null;

    final adUnitId = AdMobConfig.bannerAdUnitId;
    if (adUnitId.isEmpty) return null;

    return BannerAd(
      adUnitId: adUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad: onAdFailedToLoad,
      ),
    );
  }

  /// عرض إعلان بيني (Interstitial) لمستخدمي الخطة المجانية
  static void showInterstitialAd({VoidCallback? onDismissed}) {
    if (!RemoteConfigService.current.adsEnabled) {
      onDismissed?.call();
      return;
    }

    if (!_isMobilePlatform) {
      openMonetagDirectAd().whenComplete(() => onDismissed?.call());
      return;
    }

    InterstitialAd.load(
      adUnitId: AdMobConfig.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              onDismissed?.call();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              openMonetagDirectAd().whenComplete(() => onDismissed?.call());
            },
          );
          ad.show();
        },
        onAdFailedToLoad: (error) {
          debugPrint('تحويل تلقائي إلى Monetag Direct Link بعد تعذر AdMob: $error');
          openMonetagDirectAd().whenComplete(() => onDismissed?.call());
        },
      ),
    );
  }

  /// عرض إعلان بمكافأة (Rewarded Ad) مع دعم Monetag التلقائي
  static void showRewardedAd({
    required Function(RewardItem) onUserEarnedReward,
    VoidCallback? onAdClosed,
  }) {
    if (!_isMobilePlatform) {
      openMonetagDirectAd().then((_) {
        onUserEarnedReward(RewardItem(1, 'monetag_reward'));
        onAdClosed?.call();
      });
      return;
    }

    RewardedAd.load(
      adUnitId: AdMobConfig.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              onAdClosed?.call();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              openMonetagDirectAd().then((_) {
                onUserEarnedReward(RewardItem(1, 'monetag_reward'));
                onAdClosed?.call();
              });
            },
          );
          ad.show(onUserEarnedReward: (adWithoutView, reward) {
            onUserEarnedReward(reward);
          });
        },
        onAdFailedToLoad: (error) {
          debugPrint('تشغيل إعلان مكافأة Monetag المباشر: $error');
          openMonetagDirectAd().then((_) {
            onUserEarnedReward(RewardItem(1, 'monetag_reward'));
            onAdClosed?.call();
          });
        },
      ),
    );
  }

  static bool get _isMobilePlatform {
    return _isInitialized && !kIsWeb && (Platform.isAndroid || Platform.isIOS);
  }
}
