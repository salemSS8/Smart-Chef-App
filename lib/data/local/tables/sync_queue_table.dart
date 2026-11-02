import 'package:drift/drift.dart';

/// Table storing offline mutations queue to synchronize with Supabase backend.
class SyncQueue extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get targetTable => text().named('table_name')(); // 'pantry_items', 'favorites', 'shopping_items', etc.
  TextColumn get recordId => text()();
  TextColumn get operation => text()(); // 'insert', 'update', 'delete'
  TextColumn get payload => text()(); // JSON payload
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
}
