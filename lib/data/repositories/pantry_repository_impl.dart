import '../../domain/repositories/i_pantry_repository.dart';
import '../local/app_database.dart';
import '../local/daos/pantry_dao.dart';

/// Implementation of IPantryRepository using Drift PantryDao.
class PantryRepositoryImpl implements IPantryRepository {
  final PantryDao _pantryDao;

  PantryRepositoryImpl(this._pantryDao);

  @override
  Stream<List<PantryItem>> watchPantryItems() {
    return _pantryDao.watchPantryItems();
  }

  @override
  Future<Set<String>> getAvailableIngredientIds() {
    return _pantryDao.getAvailableIngredientIds();
  }

  @override
  Future<void> addOrUpdateIngredient({
    required String ingredientId,
    double? quantity,
    String? unit,
    String? location,
    DateTime? expiresOn,
  }) {
    return _pantryDao.addOrUpdateItem(
      ingredientId: ingredientId,
      quantity: quantity,
      unit: unit,
      location: location,
      expiresOn: expiresOn,
    );
  }

  @override
  Future<void> removeIngredient(String ingredientId) {
    return _pantryDao.removeByIngredientId(ingredientId);
  }

  @override
  Future<void> clearPantry() {
    return _pantryDao.clearPantry();
  }
}
