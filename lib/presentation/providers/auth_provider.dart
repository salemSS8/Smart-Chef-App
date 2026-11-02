import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/auth_service.dart';

/// Provider exposing current authenticated or guest user state
class AuthNotifier extends Notifier<AuthUser> {
  StreamSubscription<AuthUser?>? _sub;

  @override
  AuthUser build() {
    final service = ref.watch(authServiceProvider);
    _sub?.cancel();
    _sub = service.authStateChanges.listen((user) {
      if (user != null) {
        state = user;
      }
    });
    ref.onDispose(() => _sub?.cancel());
    return service.currentUser;
  }

  Future<AuthUser> signInWithEmail(String email, String password) async {
    final service = ref.read(authServiceProvider);
    final user = await service.signInWithEmail(email, password);
    state = user;
    return user;
  }

  Future<AuthUser> signUpWithEmail(String email, String password) async {
    final service = ref.read(authServiceProvider);
    final user = await service.signUpWithEmail(email, password);
    state = user;
    return user;
  }

  Future<void> signInAnonymously() async {
    final service = ref.read(authServiceProvider);
    final user = await service.signInAnonymously();
    state = user;
  }

  Future<void> signOut() async {
    final service = ref.read(authServiceProvider);
    await service.signOut();
    state = service.currentUser;
  }

  Future<void> deleteAccountAndUserData() async {
    final service = ref.read(authServiceProvider);
    await service.deleteAccountAndRemoteData();
    state = service.currentUser;
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthUser>(AuthNotifier.new);
