import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/local/database_provider.dart';

/// مزود قائمة الوصفات المفضلة المتصل بقاعدة بيانات Drift SQLite
class FavoritesNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() {
    final recipeDao = ref.watch(recipeDaoProvider);

    // تحميل المفضلة الابتدائية
    recipeDao.watchFavoriteRecipeIds().first.then((favs) {
      if (favs.isNotEmpty) {
        state = favs.toSet();
      }
    });

    return {};
  }

  /// تبديل حالة التفضيل في قاعدة بيانات Drift
  Future<void> toggleFavorite(String recipeId) async {
    final dao = ref.read(recipeDaoProvider);
    await dao.toggleFavorite(recipeId);
    final favList = await dao.watchFavoriteRecipeIds().first;
    state = favList.toSet();
  }

  /// التحقق من تفضيل الوصفة
  bool isFavorite(String recipeId) => state.contains(recipeId);
}

final favoritesProvider = NotifierProvider<FavoritesNotifier, Set<String>>(FavoritesNotifier.new);
