import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'environment.dart';

/// Centralized configuration class tailored per environment flavor.
class AppConfig {
  final Environment environment;
  final String appTitle;
  final String supabaseUrl;
  final String supabaseAnonKey;
  final bool enableLogging;
  final bool useMockDataFallback;
  final String geminiApiKey;
  final String geminiModel;

  const AppConfig({
    required this.environment,
    required this.appTitle,
    required this.supabaseUrl,
    required this.supabaseAnonKey,
    required this.enableLogging,
    required this.useMockDataFallback,
    required this.geminiApiKey,
    this.geminiModel = 'gemini-3.5-flash-lite',
  });

  static AppConfig? _instance;
  static AppConfig get instance => _instance ?? AppConfig.dev();

  static bool get isInitialized => _instance != null;

  static void initialize(AppConfig config) {
    _instance = config;
  }

  static const String _defaultGeminiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: 'GEMINI_CLOUD_PROXY_KEY',
  );

  factory AppConfig.dev() {
    return const AppConfig(
      environment: Environment.dev,
      appTitle: 'طاهي ذكي (Dev)',
      supabaseUrl: 'https://duwiaouvjktgwazvifoq.supabase.co',
      supabaseAnonKey: 'sb_publishable_TRpTM5xhfZdi-xZLp_cCGQ_mradZcUo',
      enableLogging: true,
      useMockDataFallback: true,
      geminiApiKey: _defaultGeminiKey,
      geminiModel: 'gemini-3.5-flash-lite',
    );
  }

  factory AppConfig.staging() {
    return const AppConfig(
      environment: Environment.staging,
      appTitle: 'طاهي ذكي (Staging)',
      supabaseUrl: 'https://duwiaouvjktgwazvifoq.supabase.co',
      supabaseAnonKey: 'sb_publishable_TRpTM5xhfZdi-xZLp_cCGQ_mradZcUo',
      enableLogging: true,
      useMockDataFallback: false,
      geminiApiKey: _defaultGeminiKey,
      geminiModel: 'gemini-3.5-flash-lite',
    );
  }

  factory AppConfig.prod() {
    return const AppConfig(
      environment: Environment.prod,
      appTitle: 'طاهي ذكي - Smart Cook',
      supabaseUrl: 'https://duwiaouvjktgwazvifoq.supabase.co',
      supabaseAnonKey: 'sb_publishable_TRpTM5xhfZdi-xZLp_cCGQ_mradZcUo',
      enableLogging: false,
      useMockDataFallback: false,
      geminiApiKey: _defaultGeminiKey,
      geminiModel: 'gemini-3.5-flash-lite',
    );
  }
}

/// Riverpod provider to inject and access configuration across the app
final appConfigProvider = Provider<AppConfig>((ref) {
  return AppConfig.instance;
});
