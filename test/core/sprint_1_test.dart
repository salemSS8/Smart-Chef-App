import 'package:flutter_test/flutter_test.dart';
import 'package:smart_cook/core/config/app_config.dart';
import 'package:smart_cook/core/config/environment.dart';
import 'package:smart_cook/core/errors/failures.dart';
import 'package:smart_cook/core/router/route_names.dart';

void main() {
  group('Sprint 1 - Environment & AppConfig Tests', () {
    test('Environment enum properties are correct', () {
      expect(Environment.dev.isDev, isTrue);
      expect(Environment.dev.isProd, isFalse);
      expect(Environment.prod.isProd, isTrue);
      expect(Environment.staging.isStaging, isTrue);
    });

    test('AppConfig.dev produces correct development defaults', () {
      final config = AppConfig.dev();
      expect(config.environment, Environment.dev);
      expect(config.enableLogging, isTrue);
      expect(config.useMockDataFallback, isTrue);
      expect(config.appTitle, contains('Dev'));
    });

    test('AppConfig.prod produces correct production defaults', () {
      final config = AppConfig.prod();
      expect(config.environment, Environment.prod);
      expect(config.enableLogging, isFalse);
      expect(config.useMockDataFallback, isFalse);
      expect(config.appTitle, contains('Smart Cook'));
    });
  });

  group('Sprint 1 - RouteNames Tests', () {
    test('Route path helpers generate valid URL paths', () {
      expect(RouteNames.recipeDetailPath('rec_123'), '/recipe/rec_123');
      expect(RouteNames.cookModePath('rec_456'), '/cook-mode/rec_456');
    });

    test('All tab route paths are distinct', () {
      final tabRoutes = [
        RouteNames.home,
        RouteNames.today,
        RouteNames.pantry,
        RouteNames.discover,
        RouteNames.shopping,
        RouteNames.settings,
      ];
      expect(tabRoutes.toSet().length, 6);
    });
  });

  group('Sprint 1 - Failure & Error Classes Tests', () {
    test('Failures retain messages and optional error codes', () {
      const failure = DatabaseFailure('Failed to open database', 'DB_LOCKED');
      expect(failure.message, 'Failed to open database');
      expect(failure.code, 'DB_LOCKED');
      expect(failure.toString(), contains('DatabaseFailure'));

      const serverFailure = ServerFailure('HTTP 500');
      expect(serverFailure.message, 'HTTP 500');
      expect(serverFailure.code, isNull);
    });
  });
}
