import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/admob_config.dart';

class RemoteAppConfigData {
  final bool adsEnabled;
  final String androidBannerId;
  final String androidInterstitialId;
  final String androidRewardedId;
  final int interstitialInterval;
  final bool maintenanceMode;
  final String minAppVersion;
  final String announcementMessage;
  final bool isAnnouncementActive;

  const RemoteAppConfigData({
    this.adsEnabled = true,
    this.androidBannerId = AdMobConfig.androidBannerAdUnitId,
    this.androidInterstitialId = AdMobConfig.androidInterstitialAdUnitId,
    this.androidRewardedId = AdMobConfig.androidRewardedAdUnitId,
    this.interstitialInterval = 3,
    this.maintenanceMode = false,
    this.minAppVersion = '1.0.0',
    this.announcementMessage = '',
    this.isAnnouncementActive = false,
  });

  factory RemoteAppConfigData.fromMap(Map<String, dynamic> map) {
    return RemoteAppConfigData(
      adsEnabled: map['ads_enabled'] ?? true,
      androidBannerId: map['android_banner_id'] ?? AdMobConfig.androidBannerAdUnitId,
      androidInterstitialId: map['android_interstitial_id'] ?? AdMobConfig.androidInterstitialAdUnitId,
      androidRewardedId: map['android_rewarded_id'] ?? AdMobConfig.androidRewardedAdUnitId,
      interstitialInterval: map['interstitial_interval'] ?? 3,
      maintenanceMode: map['maintenance_mode'] ?? false,
      minAppVersion: map['min_app_version'] ?? '1.0.0',
      announcementMessage: map['announcement_message'] ?? '',
      isAnnouncementActive: map['is_announcement_active'] ?? false,
    );
  }
}

class RemoteConfigService {
  RemoteConfigService._();

  static RemoteAppConfigData _currentConfig = const RemoteAppConfigData();
  static RemoteAppConfigData get current => _currentConfig;

  /// جلب الإعدادات عن بُعد من Supabase عند تشغيل التطبيق
  static Future<void> fetchConfig() async {
    try {
      final client = Supabase.instance.client;
      final response = await client
          .from('app_remote_config')
          .select()
          .eq('id', 'global_config')
          .maybeSingle();

      if (response != null) {
        _currentConfig = RemoteAppConfigData.fromMap(response);
        debugPrint('تم تحميل إعدادات التطبيق عن بُعد بنجاح من لوحة التحكم.');
      }
    } catch (e) {
      debugPrint('تعذر جلب الإعدادات عن بُعد، سيتم استخدام الإعدادات الافتراضية: $e');
    }
  }
}

