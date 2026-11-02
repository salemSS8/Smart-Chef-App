import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/sync_service.dart';
import '../../data/local/database_provider.dart';

/// مزود حالة مخزون المطبخ المتصل لحظياً بقاعدة بيانات Drift SQLite
class PantryNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() {
    final pantryDao = ref.watch(pantryDaoProvider);

    // تحميل المكونات الحالية من قاعدة البيانات
    pantryDao.getAvailableIngredientIds().then((ids) {
      if (ids.isNotEmpty) {
        state = ids;
      }
    });

    return {
      'ing_eggs',
      'ing_tomato',
      'ing_onion',
      'ing_bell_pepper',
    };
  }

  /// تبديل حالة المكون (إضافة إلى أو حذف من قاعدة بيانات Drift والمزامنة)
  Future<void> toggleIngredient(String ingredientId) async {
    final dao = ref.read(pantryDaoProvider);
    final sync = ref.read(syncServiceProvider);

    if (state.contains(ingredientId)) {
      await dao.removeByIngredientId(ingredientId);
      unawaited(sync.queueOperation(
        table: 'pantry_items',
        recordId: ingredientId,
        operation: 'DELETE',
        payload: {'ingredient_id': ingredientId},
      ));
    } else {
      await dao.addOrUpdateItem(ingredientId: ingredientId);
      unawaited(sync.queueOperation(
        table: 'pantry_items',
        recordId: ingredientId,
        operation: 'INSERT',
        payload: {'ingredient_id': ingredientId},
      ));
    }
    state = await dao.getAvailableIngredientIds();
  }

  /// فحص وجود مكون
  bool contains(String ingredientId) => state.contains(ingredientId);

  /// مسح المخزون بالكامل
  Future<void> clearAll() async {
    final dao = ref.read(pantryDaoProvider);
    await dao.clearPantry();
    unawaited(ref.read(syncServiceProvider).queueOperation(
      table: 'pantry_items',
      recordId: 'all',
      operation: 'DELETE_ALL',
      payload: {},
    ));
    state = {};
  }

  /// إضافة قائمة مكونات دفعة واحدة إلى Drift
  Future<void> addMultiple(Iterable<String> ingredientIds) async {
    final dao = ref.read(pantryDaoProvider);
    final sync = ref.read(syncServiceProvider);
    for (final id in ingredientIds) {
      await dao.addOrUpdateItem(ingredientId: id);
      unawaited(sync.queueOperation(
        table: 'pantry_items',
        recordId: id,
        operation: 'INSERT',
        payload: {'ingredient_id': id},
      ));
    }
    state = await dao.getAvailableIngredientIds();
  }
}

final pantryProvider = NotifierProvider<PantryNotifier, Set<String>>(PantryNotifier.new);

