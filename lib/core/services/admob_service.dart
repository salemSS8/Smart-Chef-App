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
        debugPrint('Google Mobile Ads تم تهيئتها بنجاح.');
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

  /// عرض إعلان بيني (Interstitial) لمستخدمي الخطة المجانية
  static void showInterstitialAd({VoidCallback? onDismissed}) {
    if (!_isMobilePlatform) {
      onDismissed?.call();
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
              onDismissed?.call();
            },
          );
          ad.show();
        },
        onAdFailedToLoad: (error) {
          debugPrint('فشل تحميل الإعلان البيني: $error');
          onDismissed?.call();
        },
      ),
    );
  }

  /// عرض إعلان بمكافأة (Rewarded Ad) - مثال: لمشاهدة إعلان والحصول على ميزة ذكاء اصطناعي إضافية
  static void showRewardedAd({
    required Function(RewardItem) onUserEarnedReward,
    VoidCallback? onAdClosed,
  }) {
    if (!_isMobilePlatform) {
      onAdClosed?.call();
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
              onAdClosed?.call();
            },
          );
          ad.show(onUserEarnedReward: (adWithoutView, reward) {
            onUserEarnedReward(reward);
          });
        },
        onAdFailedToLoad: (error) {
          debugPrint('فشل تحميل الإعلان بمكافأة: $error');
          onAdClosed?.call();
        },
      ),
    );
  }

  static bool get _isMobilePlatform {
    return _isInitialized && !kIsWeb && (Platform.isAndroid || Platform.isIOS);
  }
}

