import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/sync_service.dart';
import '../../data/local/database_provider.dart';
import '../../data/mock/ingredients_data.dart';
import '../../core/utils/arabic_normalizer.dart';
import '../../domain/models/recipe.dart';
import 'pantry_provider.dart';

class ShoppingItem {
  final String id;
  final String name;
  final String? ingredientId;
  final String? fromRecipe;
  final bool isCompleted;

  const ShoppingItem({
    required this.id,
    required this.name,
    this.ingredientId,
    this.fromRecipe,
    this.isCompleted = false,
  });

  ShoppingItem copyWith({
    String? id,
    String? name,
    String? ingredientId,
    String? fromRecipe,
    bool? isCompleted,
  }) {
    return ShoppingItem(
      id: id ?? this.id,
      name: name ?? this.name,
      ingredientId: ingredientId ?? this.ingredientId,
      fromRecipe: fromRecipe ?? this.fromRecipe,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'ingredientId': ingredientId,
    'fromRecipe': fromRecipe,
    'isCompleted': isCompleted,
  };

  factory ShoppingItem.fromMap(Map<String, dynamic> map) => ShoppingItem(
    id: map['id'] as String,
    name: map['name'] as String,
    ingredientId: map['ingredientId'] as String?,
    fromRecipe: map['fromRecipe'] as String?,
    isCompleted: map['isCompleted'] as bool? ?? false,
  );
}

class ShoppingNotifier extends Notifier<List<ShoppingItem>> {
  @override
  List<ShoppingItem> build() {
    final shoppingDao = ref.watch(shoppingDaoProvider);

    shoppingDao.getAllShoppingItems().then((items) {
      if (items.isNotEmpty) {
        state = _mapDriftItems(items);
      }
    });

    return [];
  }

  List<ShoppingItem> _mapDriftItems(List<dynamic> items) {
    return items.map((item) {
      String displayName = item.customName ?? '';
      if (displayName.isEmpty && item.ingredientId != null) {
        final matched = IngredientsData.allIngredients
            .where((i) => i.id == item.ingredientId);
        displayName = matched.isNotEmpty ? matched.first.name : item.ingredientId!;
      }
      if (displayName.isEmpty) displayName = 'مكوّن تسوق';

      return ShoppingItem(
        id: item.id as String,
        name: displayName,
        ingredientId: item.ingredientId as String?,
        fromRecipe: item.sourceRecipeId as String?,
        isCompleted: item.checked as bool,
      );
    }).toList();
  }

  Future<void> _refresh() async {
    final items = await ref.read(shoppingDaoProvider).getAllShoppingItems();
    state = _mapDriftItems(items);
  }

  /// إضافة عنصر جديد إلى قائمة التسوق
  Future<void> addItem(String name, {String? fromRecipe, String? ingredientId}) async {
    if (name.trim().isEmpty) return;
    final trimmedName = name.trim();

    String? matchedId = ingredientId;
    if (matchedId == null) {
      final normName = ArabicNormalizer.normalize(trimmedName);
      final found = IngredientsData.allIngredients.where(
        (i) => ArabicNormalizer.normalize(i.name) == normName,
      );
      if (found.isNotEmpty) {
        matchedId = found.first.id;
      }
    }

    final dao = ref.read(shoppingDaoProvider);
    final insertedId = await dao.addItem(
      customName: trimmedName,
      ingredientId: matchedId,
      sourceRecipeId: fromRecipe,
    );

    unawaited(ref.read(syncServiceProvider).queueOperation(
      table: 'shopping_items',
      recordId: insertedId.toString(),
      operation: 'INSERT',
      payload: {
        'id': insertedId,
        'custom_name': trimmedName,
        'ingredient_id': matchedId,
        'source_recipe_id': fromRecipe,
      },
    ));

    await _refresh();
  }

  /// إضافة قائمة المكونات الناقصة لوصفة محددة
  Future<void> addMissingIngredients(
    List<RecipeIngredient> missingList,
    String recipeTitle,
  ) async {
    final existingNames = state.map((e) => ArabicNormalizer.normalize(e.name)).toSet();
    final dao = ref.read(shoppingDaoProvider);
    final sync = ref.read(syncServiceProvider);

    for (final ing in missingList) {
      final norm = ArabicNormalizer.normalize(ing.name);
      if (!existingNames.contains(norm)) {
        final insertedId = await dao.addItem(
          customName: ing.name,
          ingredientId: ing.ingredientId,
          sourceRecipeId: recipeTitle,
        );
        unawaited(sync.queueOperation(
          table: 'shopping_items',
          recordId: insertedId.toString(),
          operation: 'INSERT',
          payload: {
            'id': insertedId,
            'custom_name': ing.name,
            'ingredient_id': ing.ingredientId,
            'source_recipe_id': recipeTitle,
          },
        ));
      }
    }
    await _refresh();
  }

  /// تبديل حالة الشراء للعنصر
  Future<void> toggleCompleted(int index) async {
    if (index >= 0 && index < state.length) {
      final item = state[index];
      final newStatus = !item.isCompleted;

      await ref.read(shoppingDaoProvider).toggleItemChecked(item.id, newStatus);
      unawaited(ref.read(syncServiceProvider).queueOperation(
        table: 'shopping_items',
        recordId: item.id,
        operation: 'UPDATE',
        payload: {'id': item.id, 'checked': newStatus},
      ));
      await _refresh();
    }
  }

  /// حذف عنصر من قائمة التسوق
  Future<void> removeItem(int index) async {
    if (index >= 0 && index < state.length) {
      final item = state[index];
      await ref.read(shoppingDaoProvider).removeItem(item.id);
      unawaited(ref.read(syncServiceProvider).queueOperation(
        table: 'shopping_items',
        recordId: item.id,
        operation: 'DELETE',
        payload: {'id': item.id},
      ));
      await _refresh();
    }
  }

  /// حذف جميع العناصر المكتملة
  Future<void> clearCompleted() async {
    await ref.read(shoppingDaoProvider).clearCheckedItems();
    unawaited(ref.read(syncServiceProvider).queueOperation(
      table: 'shopping_items',
      recordId: 'completed',
      operation: 'DELETE_COMPLETED',
      payload: {},
    ));
    await _refresh();
  }


  /// نقل جميع العناصر المشتراة المكتملة مباشرة إلى مخزن المطبخ
  Future<List<String>> transferCompletedToPantry() async {
    final completedItems = state.where((item) => item.isCompleted).toList();
    if (completedItems.isEmpty) return [];

    final List<String> pantryIdsToAdd = [];

    for (final item in completedItems) {
      String? idToAdd = item.ingredientId;
      if (idToAdd == null || idToAdd.isEmpty) {
        final norm = ArabicNormalizer.normalize(item.name);
        final found = IngredientsData.allIngredients.where(
          (i) => ArabicNormalizer.normalize(i.name) == norm,
        );
        if (found.isNotEmpty) {
          idToAdd = found.first.id;
        } else {
          idToAdd = 'ing_${DateTime.now().millisecondsSinceEpoch}_${item.name}';
        }
      }
      pantryIdsToAdd.add(idToAdd);
    }

    // إضافة إلى المخزن
    await ref.read(pantryProvider.notifier).addMultiple(pantryIdsToAdd);

    // حذف من قائمة التسوق
    await clearCompleted();

    return pantryIdsToAdd;
  }
}

final shoppingProvider = NotifierProvider<ShoppingNotifier, List<ShoppingItem>>(ShoppingNotifier.new);
