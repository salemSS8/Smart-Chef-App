import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import '../services/remote_log_service.dart';

/// Centralized application logger with formatting, environment toggling, and remote sync.
class AppLogger {
  static bool _enabled = true;

  static void init({required bool isLoggingEnabled}) {
    _enabled = isLoggingEnabled;
  }

  static void debug(String message, {String tag = 'DEBUG', Object? error}) {
    if (!_enabled || !kDebugMode) return;
    developer.log('🔍 [$tag] $message', name: tag, error: error);
  }

  static void info(String message, {String tag = 'INFO'}) {
    if (!_enabled) return;
    developer.log('ℹ️ [$tag] $message', name: tag);
  }

  static void warning(String message, {String tag = 'WARN', Object? error}) {
    developer.log('⚠️ [$tag] $message', name: tag, error: error);
  }

  static void error(
    String message, {
    String tag = 'ERROR',
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      '🚨 [$tag] $message',
      name: tag,
      error: error,
      stackTrace: stackTrace,
    );

    // ترحيل الخطأ إلى Supabase تلقائياً لمدير المنصة
    RemoteLogService.reportError(
      message,
      level: 'error',
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
