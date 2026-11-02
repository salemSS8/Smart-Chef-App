import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../config/admob_config.dart';

class AdMobService {
  AdMobService._();

  static bool _isInitialized = false;

  /// تهيئة حزمة إعلانات جوجل للهاتف المحمول
  static Future<void> initialize() async {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      try {
        await MobileAds.instance.initialize();
        _isInitialized = true;
      } catch (e) {
        debugPrint('خطأ في تهيئة Google Mobile Ads: $e');
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

  /// عرض إعلان بيني (Interstitial)
  static void showInterstitialAd({VoidCallback? onDismissed}) {
    final adUnitId = AdMobConfig.interstitialAdUnitId;
    if (!_isMobilePlatform || adUnitId.isEmpty) {
      onDismissed?.call();
      return;
    }

    InterstitialAd.load(
      adUnitId: adUnitId,
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
              onDismissed?.call();
            },
          );
          ad.show();
        },
        onAdFailedToLoad: (error) {
          onDismissed?.call();
        },
      ),
    );
  }

  /// عرض إعلان بمكافأة (Rewarded Ad)
  static void showRewardedAd({
    required Function(RewardItem) onUserEarnedReward,
    VoidCallback? onAdClosed,
  }) {
    final adUnitId = AdMobConfig.rewardedAdUnitId;
    if (!_isMobilePlatform || adUnitId.isEmpty) {
      onAdClosed?.call();
      return;
    }

    RewardedAd.load(
      adUnitId: adUnitId,
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
              onAdClosed?.call();
            },
          );
          ad.show(onUserEarnedReward: (adWithoutView, reward) {
            onUserEarnedReward(reward);
          });
        },
        onAdFailedToLoad: (error) {
          onAdClosed?.call();
        },
      ),
    );
  }

  static bool get _isMobilePlatform {
    return _isInitialized && !kIsWeb && (Platform.isAndroid || Platform.isIOS);
  }
}
