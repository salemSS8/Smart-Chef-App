import '../../data/local/app_database.dart';

/// Contract interface for pantry data operations.
abstract class IPantryRepository {
  /// Stream of pantry items for reactive UI updates
  Stream<List<PantryItem>> watchPantryItems();

  /// Get set of currently available ingredient IDs
  Future<Set<String>> getAvailableIngredientIds();

  /// Add or update an ingredient in the pantry
  Future<void> addOrUpdateIngredient({
    required String ingredientId,
    double? quantity,
    String? unit,
    String? location,
    DateTime? expiresOn,
  });

  /// Remove ingredient from pantry by ID
  Future<void> removeIngredient(String ingredientId);

  /// Clear entire pantry
  Future<void> clearPantry();
}
