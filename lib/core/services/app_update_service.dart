import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_colors.dart';
import 'remote_config_service.dart';

class AppUpdateInfo {
  final bool hasUpdate;
  final String installedVersion;
  final String latestVersion;
  final bool isMandatory;
  final String downloadUrl;
  final String? releaseTitle;
  final String? releaseNotes;

  const AppUpdateInfo({
    required this.hasUpdate,
    required this.installedVersion,
    required this.latestVersion,
    required this.isMandatory,
    required this.downloadUrl,
    this.releaseTitle,
    this.releaseNotes,
  });
}

/// خدمة فحص التحديثات الذاتية وتسجيل الأجهزة (بديل متجر Google Play)
/// مرتبطة مباشرة بموقع البورتفوليو (BASHNDDOF-Profile-next) و GitHub Releases
class AppUpdateService {
  AppUpdateService._();

  static const String currentAppVersion = '1.0.0';
  static const String appSlug = 'smart-cook';
  static const String portfolioBaseUrl = 'https://bashnddof.vercel.app';
  static const String githubReleasesFallbackUrl =
      'https://github.com/salemSS8/Smart-Chef-App/releases/latest';

  static const String _deviceIdPrefKey = 'smart_cook_telemetry_device_id';
  static bool _hasCheckedThisSession = false;

  /// الحصول على معرف فريد وثابت للجهاز لتتبع الأجهزة النشطة والتحديثات
  static Future<String> _getOrCreateDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString(_deviceIdPrefKey);
    if (deviceId == null || deviceId.isEmpty) {
      final rand = Random().nextInt(900000) + 100000;
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      deviceId = 'sc_${Platform.operatingSystem}_${timestamp}_$rand';
      await prefs.setString(_deviceIdPrefKey, deviceId);
    }
    return deviceId;
  }

  /// مقارنة رقمي إصدار (مثل 1.0.0 و 1.0.1)
  static bool _isVersionOutdated(String installed, String latest) {
    final cleanInstalled = installed.trim().replaceFirst(RegExp(r'^[vV]'), '');
    final cleanLatest = latest.trim().replaceFirst(RegExp(r'^[vV]'), '');

    final iParts =
        cleanInstalled.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    final lParts =
        cleanLatest.split('.').map((e) => int.tryParse(e) ?? 0).toList();

    final maxLen = max(iParts.length, lParts.length);
    for (int i = 0; i < maxLen; i++) {
      final iVal = i < iParts.length ? iParts[i] : 0;
      final lVal = i < lParts.length ? lParts[i] : 0;
      if (lVal > iVal) return true;
      if (lVal < iVal) return false;
    }
    return false;
  }

  /// الاتصال بسيرفر BASHNDDOF-Profile-next لفحص التحديثات وتسجيل الجهاز النشط
  static Future<AppUpdateInfo?> checkUpdate() async {
    if (kIsWeb) return null;

    try {
      final deviceId = await _getOrCreateDeviceId();
      final osVersion = Platform.operatingSystemVersion;
      final deviceModel = Platform.operatingSystem.toUpperCase();

      final uri = Uri.parse(
        '$portfolioBaseUrl/api/mobile-apps/check-update'
        '?slug=$appSlug'
        '&version=$currentAppVersion'
        '&deviceId=${Uri.encodeComponent(deviceId)}'
        '&deviceModel=${Uri.encodeComponent(deviceModel)}'
        '&osVersion=${Uri.encodeComponent(osVersion)}',
      );

      final client = HttpClient()
        ..connectionTimeout = const Duration(seconds: 8);
      final request = await client.getUrl(uri);
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');
      final response = await request.close();

      if (response.statusCode == 200) {
        final body = await response.transform(utf8.decoder).join();
        final data = jsonDecode(body) as Map<String, dynamic>;

        final latestVersion =
            (data['latestVersion'] as String?) ?? currentAppVersion;
        final hasUpdate = (data['hasUpdate'] as bool?) ??
            _isVersionOutdated(currentAppVersion, latestVersion);
        final isMandatory = (data['isMandatory'] as bool?) ?? false;

        final relativeDownload = data['downloadUrl'] as String?;
        final directApkUrl = data['apkUrl'] as String?;
        final resolvedDownloadUrl =
            (relativeDownload != null && relativeDownload.isNotEmpty)
                ? '$portfolioBaseUrl$relativeDownload'
                : (directApkUrl ??
                    '$portfolioBaseUrl/api/mobile-apps/download?slug=$appSlug');

        client.close();
        return AppUpdateInfo(
          hasUpdate: hasUpdate,
          installedVersion: currentAppVersion,
          latestVersion: latestVersion,
          isMandatory: isMandatory,
          downloadUrl: resolvedDownloadUrl,
          releaseTitle: data['releaseTitle'] as String?,
          releaseNotes: (data['releaseNotesAr'] as String?) ??
              (data['releaseNotes'] as String?),
        );
      }
      client.close();
    } catch (e) {
      debugPrint('AppUpdateService check warning: $e');
    }

    // Fallback: Check Supabase RemoteConfig minAppVersion
    final minRemoteVersion = RemoteConfigService.current.minAppVersion;
    if (_isVersionOutdated(currentAppVersion, minRemoteVersion)) {
      return AppUpdateInfo(
        hasUpdate: true,
        installedVersion: currentAppVersion,
        latestVersion: minRemoteVersion,
        isMandatory: true,
        downloadUrl: '$portfolioBaseUrl/api/mobile-apps/download?slug=$appSlug',
        releaseTitle: 'تحديث هام لتطبيق طاهي ذكي ($minRemoteVersion)',
        releaseNotes:
            'يتوفر إصدار جديد يتضمن تحسينات هامة ووصفات جديدة. يرجى التحديث للمتابعة.',
      );
    }

    return const AppUpdateInfo(
      hasUpdate: false,
      installedVersion: currentAppVersion,
      latestVersion: currentAppVersion,
      isMandatory: false,
      downloadUrl: '$portfolioBaseUrl/api/mobile-apps/download?slug=$appSlug',
    );
  }

  /// فحص التحديثات تلقائياً عند فتح التطبيق وإظهار نافذة التحديث إذا توفر إصدار أحدث
  static Future<void> checkForUpdatesOnStartup(BuildContext context) async {
    if (_hasCheckedThisSession) return;
    _hasCheckedThisSession = true;

    final info = await checkUpdate();
    if (info != null && info.hasUpdate && context.mounted) {
      await showUpdateDialog(context, info);
    }
  }

  /// نافذة تحديث أنيقة تدعم التحميل المباشر لملف الـ APK
  static Future<void> showUpdateDialog(
    BuildContext context,
    AppUpdateInfo info,
  ) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: !info.isMandatory,
      builder: (ctx) {
        return PopScope(
          canPop: !info.isMandatory,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
            contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.system_update_rounded,
                    color: AppColors.primary,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'تحديث جديد متاح!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'الإصدار ${info.latestVersion} (الحالي: ${info.installedVersion})',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (info.releaseTitle != null &&
                    info.releaseTitle!.trim().isNotEmpty) ...[
                  Text(
                    info.releaseTitle!,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                Text(
                  (info.releaseNotes != null &&
                          info.releaseNotes!.trim().isNotEmpty)
                      ? info.releaseNotes!
                      : 'يتوفر إصدار أحدث من تطبيق طاهي ذكي مع ميزات محسّنة وأداء أسرع. قم بتحميل ملف الـ APK وتثبيته مباشرة.',
                  style: const TextStyle(fontSize: 13, height: 1.5),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final uri = Uri.parse(info.downloadUrl);
                      final launched = await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      );
                      if (!launched) {
                        await launchUrl(
                          Uri.parse(githubReleasesFallbackUrl),
                          mode: LaunchMode.externalApplication,
                        );
                      }
                    },
                    icon: const Icon(Icons.download_rounded, size: 20),
                    label: const Text(
                      'تحميل التحديث الآن (APK)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
                if (!info.isMandatory) ...[
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('تذكيري لاحقاً'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

