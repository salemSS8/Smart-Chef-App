import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/local/daos/sync_dao.dart';
import '../../data/local/database_provider.dart';
import '../network/network_connectivity_service.dart';
import '../utils/logger.dart';
import 'auth_service.dart';

enum SyncStatus {
  idle,
  syncing,
  synced,
  offline,
  error,
}

class SyncService {
  final SyncDao _syncDao;
  final NetworkConnectivityService _connectivity;
  final AuthService _authService;

  final StreamController<SyncStatus> _statusController =
      StreamController<SyncStatus>.broadcast();
  SyncStatus _currentStatus = SyncStatus.idle;
  StreamSubscription<bool>? _connSub;
  bool _isProcessing = false;

  SyncService({
    required SyncDao syncDao,
    required NetworkConnectivityService connectivity,
    required AuthService authService,
  })  : _syncDao = syncDao,
        _connectivity = connectivity,
        _authService = authService {
    _init();
  }

  void _init() {
    _connSub = _connectivity.watchIsConnected().listen((online) {
      if (online) {
        AppLogger.info('Connection restored. Triggering sync queue processing...');
        processSyncQueue();
      } else {
        _setStatus(SyncStatus.offline);
      }
    });
  }

  SyncStatus get status => _currentStatus;
  Stream<SyncStatus> get statusStream => _statusController.stream;

  void _setStatus(SyncStatus s) {
    _currentStatus = s;
    if (!_statusController.isClosed) {
      _statusController.add(s);
    }
  }


  /// Queue an offline mutation for synchronization
  Future<int> queueOperation({
    required String table,
    required String recordId,
    required String operation, // 'INSERT', 'UPDATE', 'DELETE'
    required Map<String, dynamic> payload,
  }) async {
    final entryId = await _syncDao.enqueueOperation(
      tableName: table,
      recordId: recordId,
      operation: operation,
      payload: jsonEncode(payload),
    );

    AppLogger.info('Enqueued sync mutation [$operation] for $table:$recordId (Queue ID: $entryId)');

    // Attempt instant processing if device is online
    final isOnline = await _connectivity.isConnected;
    if (isOnline) {
      unawaited(processSyncQueue());
    } else {
      _setStatus(SyncStatus.offline);
    }

    return entryId;
  }

  /// Process all pending operations in the sync queue (Last-Write-Wins)
  Future<void> processSyncQueue() async {
    if (_isProcessing) return;
    final isOnline = await _connectivity.isConnected;
    if (!isOnline) {
      _setStatus(SyncStatus.offline);
      return;
    }

    _isProcessing = true;
    _setStatus(SyncStatus.syncing);

    try {
      final pending = await _syncDao.getPendingOperations();
      if (pending.isEmpty) {
        _setStatus(SyncStatus.synced);
        _isProcessing = false;
        return;
      }

      AppLogger.info('Processing ${pending.length} pending sync items...');

      for (final item in pending) {
        try {
          // Last-Write-Wins: In Supabase, each mutation includes updatedAt timestamp
          // For demo/simulated or remote Supabase client:
          await _executeRemoteSync(item);

          // Mark as successfully synced in local Drift database
          await _syncDao.markSynced(item.id);
        } catch (itemErr) {
          AppLogger.warning('Failed to sync item ${item.id}: $itemErr');
          await _syncDao.incrementRetry(item.id, item.retryCount);
        }
      }

      // Cleanup completed items
      await _syncDao.clearCompleted();
      _setStatus(SyncStatus.synced);
    } catch (e, st) {
      AppLogger.error('Sync queue processing error: $e', error: e, stackTrace: st);
      _setStatus(SyncStatus.error);
    } finally {
      _isProcessing = false;
    }
  }

  Future<void> _executeRemoteSync(dynamic item) async {
    // Simulated remote sync or Supabase call
    // If authenticated, we upload data scoped to auth user ID
    final userId = _authService.currentUser.id;
    final payload = jsonDecode(item.payload as String) as Map<String, dynamic>;
    payload['user_id'] = userId;
    payload['synced_at'] = DateTime.now().toIso8601String();

    // Emulate ultra-fast non-blocking network I/O
    await Future.delayed(const Duration(milliseconds: 30));
  }

  void dispose() {
    try {
      _connSub?.cancel();
    } catch (_) {}
    if (!_statusController.isClosed) {
      _statusController.close();
    }
  }

}

/// Provider for SyncService
final syncServiceProvider = Provider<SyncService>((ref) {
  final syncDao = ref.watch(syncDaoProvider);
  final connectivity = ref.watch(networkConnectivityServiceProvider);
  final authService = ref.watch(authServiceProvider);

  final service = SyncService(
    syncDao: syncDao,
    connectivity: connectivity,
    authService: authService,
  );

  ref.onDispose(() => service.dispose());
  return service;
});

/// Reactive stream of sync status
final syncStatusStreamProvider = StreamProvider<SyncStatus>((ref) {
  final service = ref.watch(syncServiceProvider);
  return service.statusStream;
});
