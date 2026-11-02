import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/sync_queue_table.dart';

part 'sync_dao.g.dart';

@DriftAccessor(tables: [SyncQueue])
class SyncDao extends DatabaseAccessor<AppDatabase> with _$SyncDaoMixin {
  SyncDao(super.db);

  /// Fetch all pending unsynced operations
  Future<List<SyncQueueData>> getPendingOperations() {
    return (select(syncQueue)
          ..where((tbl) => tbl.isSynced.equals(false))
          ..orderBy([(tbl) => OrderingTerm(expression: tbl.createdAt)]))
        .get();
  }

  /// Add new offline mutation to sync queue
  Future<int> enqueueOperation({
    required String tableName,
    required String recordId,
    required String operation,
    required String payload,
  }) {
    return into(syncQueue).insert(
      SyncQueueCompanion.insert(
        targetTable: tableName,
        recordId: recordId,
        operation: operation,
        payload: payload,
        createdAt: DateTime.now(),
      ),
    );
  }

  /// Mark queue entry as synced
  Future<int> markSynced(int id) {
    return (update(syncQueue)..where((tbl) => tbl.id.equals(id))).write(
      const SyncQueueCompanion(isSynced: Value(true)),
    );
  }

  /// Increment retry count on failure
  Future<void> incrementRetry(int id, int currentRetries) {
    return (update(syncQueue)..where((tbl) => tbl.id.equals(id))).write(
      SyncQueueCompanion(retryCount: Value(currentRetries + 1)),
    );
  }

  /// Delete completed synced items
  Future<int> clearCompleted() {
    return (delete(syncQueue)..where((tbl) => tbl.isSynced.equals(true))).go();
  }
}
