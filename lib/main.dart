import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/config/app_config.dart';
import 'core/errors/error_handler.dart';
import 'core/router/app_router.dart';
import 'core/services/admob_service.dart';
import 'core/services/remote_config_service.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/logger.dart';
import 'presentation/providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // If running directly without main_dev or main_prod, initialize dev config as fallback
  if (!AppConfig.isInitialized) {
    AppConfig.initialize(AppConfig.dev());
    AppLogger.init(isLoggingEnabled: true);
  }

  // Hook global framework and async error handlers
  GlobalErrorHandler.initialize();

  // Initialize Supabase backend connection
  try {
    await Supabase.initialize(
      url: AppConfig.instance.supabaseUrl,
      publishableKey: AppConfig.instance.supabaseAnonKey,
    );
    // Fetch remote config dynamically from dashboard
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

class SmartCookApp extends ConsumerWidget {
  const SmartCookApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final appConfig = ref.watch(appConfigProvider);
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: appConfig.appTitle,
      debugShowCheckedModeBanner: appConfig.environment.isDev,
      routerConfig: router,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,

      // Arabic RTL localization by default
      locale: const Locale('ar', 'SA'),
      supportedLocales: const [
        Locale('ar', 'SA'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
