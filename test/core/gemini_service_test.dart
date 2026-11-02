import 'package:flutter_test/flutter_test.dart';
import 'package:smart_cook/core/config/app_config.dart';
import 'package:smart_cook/core/services/gemini_ai_service.dart';

void main() {
  group('GeminiAiService Unit Tests', () {
    test('Service fallback generates a valid complete recipe when offline', () async {
      final config = AppConfig.dev();
      final service = GeminiAiService(config);

      final recipe = await service.generateRecipeFromPantry(
        pantryIngredients: ['بيض', 'طماطم', 'بصل'],
      );

      expect(recipe.title.isNotEmpty, isTrue);
      expect(recipe.ingredients.isNotEmpty, isTrue);
      expect(recipe.steps.isNotEmpty, isTrue);
      expect(recipe.servings, greaterThan(0));
      expect(recipe.cookMinutes, greaterThan(0));
    });

    test('AppConfig has user Gemini API Key configured', () {
      final config = AppConfig.dev();
      expect(config.geminiApiKey.isNotEmpty, isTrue);
      expect(config.geminiModel, contains('gemini'));
    });
  });
}
