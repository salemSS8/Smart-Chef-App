import 'dart:ui';
import 'package:flutter/material.dart';
import '../services/remote_log_service.dart';
import '../utils/logger.dart';
import '../../presentation/screens/error_screen.dart';

/// Central error handler that hooks into Flutter framework & async errors.
class GlobalErrorHandler {
  static void initialize() {
    // 1. Catch Flutter framework errors (e.g. widget build errors)
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      AppLogger.error(
        'Caught Framework Error: ${details.exceptionAsString()}',
        tag: 'FlutterError',
        error: details.exception,
        stackTrace: details.stack,
      );

      // ترحيل الخطأ إلى Supabase ولوحة التحكم
      RemoteLogService.reportError(
        details.exceptionAsString(),
        level: 'fatal',
        tag: 'FlutterFramework',
        error: details.exception,
        stackTrace: details.stack,
      );
    };

    // 2. Catch asynchronous errors outside the widget tree
    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      AppLogger.error(
        'Caught Unhandled Async Error: $error',
        tag: 'PlatformDispatcher',
        error: error,
        stackTrace: stack,
      );

      // ترحيل الخطأ إلى Supabase ولوحة التحكم
      RemoteLogService.reportError(
        error.toString(),
        level: 'error',
        tag: 'AsyncPlatform',
        error: error,
        stackTrace: stack,
      );
      return true; // Mark as handled to prevent sudden crash
    };

    // 3. Customize the widget red screen of death in production
    ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
      return ErrorScreen(
        errorMessage: errorDetails.exceptionAsString(),
      );
    };
  }
}
