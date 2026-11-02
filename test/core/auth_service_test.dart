import 'package:flutter_test/flutter_test.dart';
import 'package:smart_cook/core/config/app_config.dart';
import 'package:smart_cook/core/services/auth_service.dart';

void main() {
  late AuthService authService;
  late AppConfig config;

  setUp(() {
    config = AppConfig.dev();
    authService = AuthService(config);
  });

  tearDown(() {
    authService.dispose();
  });

  group('AuthService Tests', () {
    test('Default user starts as Guest mode', () {
      expect(authService.currentUser.isAnonymous, isTrue);
      expect(authService.isAuthenticated, isFalse);
      expect(authService.currentUser.displayName, equals('مستخدم ضيف'));
    });

    test('Sign in with email updates user state to authenticated', () async {
      final user = await authService.signInWithEmail('chef@smartcook.app', 'password123');

      expect(user.isAnonymous, isFalse);
      expect(user.email, equals('chef@smartcook.app'));
      expect(authService.isAuthenticated, isTrue);
      expect(authService.currentUser.email, equals('chef@smartcook.app'));
    });

    test('Sign out reverts user state to local Guest mode', () async {
      await authService.signInWithEmail('chef@smartcook.app', 'password123');
      expect(authService.isAuthenticated, isTrue);

      await authService.signOut();
      expect(authService.currentUser.isAnonymous, isTrue);
      expect(authService.isAuthenticated, isFalse);
    });

    test('deleteAccountAndRemoteData resets state to guest', () async {
      await authService.signInWithEmail('delete_me@smartcook.app', 'password123');
      expect(authService.isAuthenticated, isTrue);

      await authService.deleteAccountAndRemoteData();
      expect(authService.isAuthenticated, isFalse);
      expect(authService.currentUser.isAnonymous, isTrue);
    });
  });
}
