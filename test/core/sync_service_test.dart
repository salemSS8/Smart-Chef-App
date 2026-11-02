import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_cook/core/config/app_config.dart';
import 'package:smart_cook/core/network/network_connectivity_service.dart';
import 'package:smart_cook/core/services/auth_service.dart';
import 'package:smart_cook/core/services/sync_service.dart';
import 'package:smart_cook/data/local/app_database.dart';

class FakeConnectivityService extends NetworkConnectivityService {
  bool online;
  FakeConnectivityService(this.online);

  @override
  Future<bool> get isConnected async => online;

  @override
  Stream<bool> watchIsConnected() => Stream.value(online);
}

void main() {
  late AppDatabase db;
  late AuthService authService;
  late FakeConnectivityService connectivity;
  late SyncService syncService;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    authService = AuthService(AppConfig.dev());
    connectivity = FakeConnectivityService(true);
    syncService = SyncService(
      syncDao: db.syncDao,
      connectivity: connectivity,
      authService: authService,
    );
  });

  tearDown(() async {
    syncService.dispose();
    authService.dispose();
    await db.close();
  });

  group('SyncService & Queue Tests', () {
    test('Queue operation enqueues mutation in Drift SyncDao', () async {
      final queueId = await syncService.queueOperation(
        table: 'pantry_items',
        recordId: 'ing_tomato',
        operation: 'INSERT',
        payload: {'ingredient_id': 'ing_tomato', 'quantity': 2},
      );

      expect(queueId, isPositive);
      await Future.delayed(const Duration(milliseconds: 60));
    });


    test('processSyncQueue processes pending items and marks them synced', () async {
      await db.syncDao.enqueueOperation(
        tableName: 'shopping_items',
        recordId: 'item_1',
        operation: 'INSERT',
        payload: '{"custom_name": "حليب"}',
      );

      var pending = await db.syncDao.getPendingOperations();
      expect(pending.length, equals(1));

      // Process the queue
      await syncService.processSyncQueue();

      // Completed items are cleared by syncService
      pending = await db.syncDao.getPendingOperations();
      expect(pending.isEmpty, isTrue);
      expect(syncService.status, equals(SyncStatus.synced));
    });

    test('Offline status halts processing and preserves queue', () async {
      connectivity.online = false;

      await syncService.queueOperation(
        table: 'pantry_items',
        recordId: 'ing_onion',
        operation: 'DELETE',
        payload: {'ingredient_id': 'ing_onion'},
      );

      // Attempt processing while offline
      await syncService.processSyncQueue();

      expect(syncService.status, equals(SyncStatus.offline));
      final pending = await db.syncDao.getPendingOperations();
      expect(pending.length, equals(1));
    });
  });
}
