import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Service to monitor device network connectivity in real-time.
class NetworkConnectivityService {
  final Connectivity _connectivity;

  NetworkConnectivityService([Connectivity? connectivity])
      : _connectivity = connectivity ?? Connectivity();

  /// Check immediate connectivity status
  Future<bool> get isConnected async {
    try {
      final results = await _connectivity.checkConnectivity();
      return _hasValidConnection(results);
    } catch (_) {
      return false;
    }
  }

  /// Observable stream of connectivity status (true if online, false if offline)
  Stream<bool> watchIsConnected() {
    try {
      return _connectivity.onConnectivityChanged.map(_hasValidConnection);
    } catch (_) {
      return const Stream.empty();
    }
  }


  bool _hasValidConnection(List<ConnectivityResult> results) {
    if (results.isEmpty) return false;
    return results.any((r) =>
        r == ConnectivityResult.mobile ||
        r == ConnectivityResult.wifi ||
        r == ConnectivityResult.ethernet);
  }
}

/// Provider for NetworkConnectivityService
final networkConnectivityServiceProvider = Provider<NetworkConnectivityService>((ref) {
  return NetworkConnectivityService();
});

/// Reactive stream of connectivity status
final isConnectedProvider = StreamProvider<bool>((ref) {
  final service = ref.watch(networkConnectivityServiceProvider);
  return service.watchIsConnected();
});
