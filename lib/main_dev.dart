import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/config/app_config.dart';
import 'core/errors/error_handler.dart';
import 'core/services/admob_service.dart';
import 'core/services/remote_config_service.dart';
import 'core/utils/logger.dart';
import 'main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Development Configuration
  AppConfig.initialize(AppConfig.dev());
  AppLogger.init(isLoggingEnabled: true);
  GlobalErrorHandler.initialize();
  AppLogger.info('🚀 Launching Smart Cook in DEV mode');

  // Initialize Supabase backend connection
  try {
    await Supabase.initialize(
      url: AppConfig.instance.supabaseUrl,
      publishableKey: AppConfig.instance.supabaseAnonKey,
    );
    await RemoteConfigService.fetchConfig();
  } catch (e) {
    AppLogger.error('Failed to initialize Supabase: $e');
  }

  // Initialize Google Mobile Ads safely
  await AdMobService.initialize();

  runApp(
    const ProviderScope(
      child: SmartCookApp(),
    ),
  );
}
