import 'dart:convert';
import 'package:drift/drift.dart';
import '../app_database.dart';
import '../../mock/ingredients_data.dart';
import '../../mock/recipes_data.dart';
import '../../../core/utils/logger.dart';

/// Service responsible for initial population of ingredients and recipes into Drift SQLite.
class DatabaseSeeder {
  final AppDatabase db;

  DatabaseSeeder(this.db);

  Future<void> seedIfEmpty() async {
    final existingIngredients = await db.ingredientDao.getAllIngredients();
    if (existingIngredients.isNotEmpty) {
      AppLogger.info('Database already seeded (${existingIngredients.length} ingredients found). Skipping.');
      return;
    }

    AppLogger.info('🌱 Seeding database with initial culinary data...');

    // 1. Seed Ingredients and Names
    final ingredientCompanions = <IngredientsCompanion>[];
    final nameCompanions = <IngredientNamesCompanion>[];

    for (final ing in IngredientsData.allIngredients) {
      ingredientCompanions.add(
        IngredientsCompanion.insert(
          id: ing.id,
          category: ing.category.name,
          defaultUnit: const Value('piece'),
          shelfLifeFridgeDays: Value(ing.shelfLifeDays),
          updatedAt: DateTime.now(),
        ),
      );

      // Primary name
      nameCompanions.add(
        IngredientNamesCompanion.insert(
          ingredientId: ing.id,
          lang: 'ar',
          name: ing.name,
          normalized: _normalizeArabic(ing.name),
          isPrimary: const Value(true),
        ),
      );

      // Synonyms / dialects
      for (final synonym in ing.synonyms) {
        if (synonym != ing.name) {
          nameCompanions.add(
            IngredientNamesCompanion.insert(
              ingredientId: ing.id,
              lang: 'ar',
              name: synonym,
              normalized: _normalizeArabic(synonym),
              isPrimary: const Value(false),
            ),
          );
        }
      }
    }

    await db.ingredientDao.upsertIngredients(ingredientCompanions);
    await db.ingredientDao.upsertNames(nameCompanions);

    // 2. Seed Recipes, Ingredients & Steps
    final recipeCompanions = <RecipesCompanion>[];
    final recipeIngredientCompanions = <RecipeIngredientsCompanion>[];
    final stepCompanions = <RecipeStepsCompanion>[];

    for (final r in RecipesData.allRecipes) {
      final difficultyInt = r.difficulty == 'سهل'
          ? 1
          : r.difficulty == 'متوسط'
              ? 2
              : 3;

      recipeCompanions.add(
        RecipesCompanion.insert(
          id: r.id,
          slug: r.id,
          title: r.title,
          description: Value(r.description),
          cuisine: Value(r.cuisine),
          mealType: Value(jsonEncode(r.tags)),
          difficulty: Value(difficultyInt),
          prepMinutes: Value(r.prepMinutes),
          cookMinutes: Value(r.cookMinutes),
          totalMinutes: Value(r.prepMinutes + r.cookMinutes),
          baseServings: Value(r.servings),
          caloriesPerServing: Value(r.calories),
          verified: Value(r.verified),
          heroImageUrl: Value(r.heroImageUrl),
          updatedAt: DateTime.now(),
        ),
      );

      for (var i = 0; i < r.ingredients.length; i++) {
        final ing = r.ingredients[i];
        recipeIngredientCompanions.add(
          RecipeIngredientsCompanion.insert(
            recipeId: r.id,
            ingredientId: ing.ingredientId,
            role: ing.role.name,
            amount: const Value(1.0),
            displayText: Value(ing.displayText),
            sortOrder: Value(i),
          ),
        );
      }

      for (final step in r.steps) {
        stepCompanions.add(
          RecipeStepsCompanion.insert(
            recipeId: r.id,
            stepNo: step.stepNo,
            stepText: step.text,
            timerSeconds: Value(step.timerSeconds),
            tip: Value(step.tip),
          ),
        );
      }
    }

    await db.recipeDao.upsertRecipes(recipeCompanions);
    await db.recipeDao.upsertRecipeIngredients(recipeIngredientCompanions);
    await db.recipeDao.upsertRecipeSteps(stepCompanions);

    AppLogger.info(
      '✅ Successfully seeded database with ${ingredientCompanions.length} ingredients and ${recipeCompanions.length} recipes.',
    );
  }

  static String _normalizeArabic(String text) {
    return text
        .replaceAll(RegExp(r'[\u064B-\u065F\u0670]'), '')
        .replaceAll('إ', 'ا')
        .replaceAll('أ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ة', 'ه')
        .replaceAll('ى', 'ي');
  }
}
