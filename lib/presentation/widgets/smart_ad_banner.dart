import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../core/services/admob_service.dart';
import '../../core/services/remote_config_service.dart';
import '../../core/services/subscription_service.dart';

/// ويدجت ذكي لعرض إعلانات البانر: يختفي تلقائياً وبشكل فوري لمشتركي باقة Pro
class SmartAdBanner extends ConsumerStatefulWidget {
  const SmartAdBanner({super.key});

  @override
  ConsumerState<SmartAdBanner> createState() => _SmartAdBannerState();
}

class _SmartAdBannerState extends ConsumerState<SmartAdBanner> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadBanner();
  }

  void _loadBanner() {
    _bannerAd = AdMobService.createBannerAd(
      onAdLoaded: (ad) {
        if (mounted) {
          setState(() => _isAdLoaded = true);
        }
      },
      onAdFailedToLoad: (ad, error) {
        ad.dispose();
        if (mounted) {
          setState(() {
            _bannerAd = null;
            _isAdLoaded = false;
          });
        }
      },
    );

    _bannerAd?.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final subscriptionState = ref.watch(subscriptionProvider);

    // إذا قام المدير بإيقاف الإعلانات من لوحة التحكم عن بُعد، أو كان المستخدم مشتركاً في Pro
    if (!RemoteConfigService.current.adsEnabled || subscriptionState.isPro) {
      return const SizedBox.shrink();
    }

    if (!_isAdLoaded || _bannerAd == null) {
      return const SizedBox.shrink();
    }

    return Container(
      alignment: Alignment.center,
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: AdWidget(ad: _bannerAd!),
    );
  }
}

