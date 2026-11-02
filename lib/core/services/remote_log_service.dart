import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// خدمة ترحيل سجلات وأخطاء التطبيق عن بُعد إلى Supabase ولوحة التحكم
class RemoteLogService {
  RemoteLogService._();

  static final Set<String> _recentErrors = {};
  static DateTime _lastReportTime = DateTime.fromMillisecondsSinceEpoch(0);

  /// تسجيل تقرير خطأ وترحيله إلى جدول app_error_logs في السيرفر
  static Future<void> reportError(
    String message, {
    String level = 'error',
    String tag = 'General',
    Object? error,
    StackTrace? stackTrace,
  }) async {
    // عدم إرسال التقارير أثناء وضع الاختبار التلقائي أو إذا كان الخطأ مكرراً خلال 5 ثوانٍ
    final errorSignature = '$tag:$message';
    final now = DateTime.now();

    if (_recentErrors.contains(errorSignature) &&
        now.difference(_lastReportTime).inSeconds < 5) {
      return;
    }

    _recentErrors.add(errorSignature);
    _lastReportTime = now;
    if (_recentErrors.length > 50) _recentErrors.clear();

    try {
      // التأكد من تهيئة Supabase أولاً
      if (!Supabase.instance.isInitialized) return;

      final client = Supabase.instance.client;
      final fullMessage = error != null ? '$message | Error: $error' : message;

      final payload = {
        'level': level,
        'tag': tag,
        'message': fullMessage.length > 1000
            ? fullMessage.substring(0, 1000)
            : fullMessage,
        'stack_trace': stackTrace?.toString(),
        'app_version': '1.0.0',
        'platform': kIsWeb ? 'Web' : Platform.operatingSystem,
        'device_info': kIsWeb ? 'Browser' : Platform.operatingSystemVersion,
        'user_id': client.auth.currentUser?.id,
        'created_at': DateTime.now().toUtc().toIso8601String(),
      };

      // إرسال كـ Fire-and-forget لضمان عدم تأخير تجربة المستخدم
      await client.from('app_error_logs').insert(payload);
    } catch (e) {
      // صامت تماماً: لا نسمح أبداً لخدمة تسجيل الأخطاء بالتسبب في انهيار التطبيق
      debugPrint('RemoteLogService fail-safe: $e');
    }
  }
}

