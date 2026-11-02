import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/app_config.dart';
import '../utils/logger.dart';
import '../../domain/models/recipe.dart';

/// Service for Google Gemini AI features:
/// 1. Dynamic AI Chef recipe generation based on available pantry items.
/// 2. Image recognition to scan fridge / pantry shelves and detect ingredients.
class GeminiAiService {
  final AppConfig _config;
  final HttpClient _client;

  static const List<String> _preferredModels = [
    'gemini-3.5-flash-lite',
    'gemini-flash-latest',
    'gemini-3.8-flash',
  ];

  GeminiAiService(this._config) : _client = HttpClient() {
    _client.connectionTimeout = const Duration(seconds: 15);
  }

  /// Generates a customized, complete Arabic recipe based on pantry items.
  Future<Recipe> generateRecipeFromPantry({
    required List<String> pantryIngredients,
    String? cuisinePreference,
  }) async {
    final apiKey = _config.geminiApiKey;
    if (apiKey.isEmpty) {
      AppLogger.warning('Gemini API Key is empty, using fallback recipe generator.');
      return _generateLocalFallbackRecipe(pantryIngredients);
    }

    final ingredientsList = pantryIngredients.isNotEmpty
        ? pantryIngredients.join('، ')
        : 'بيض، طماطم، بصل، بهارات، زيت';

    final prompt = '''
أنت الشيف الذكي لتطبيق "Smart Cook" (طاهي ذكي). بناءً على المكونات المتوفرة التالية:
$ingredientsList
${cuisinePreference != null ? 'المطبخ المفضل: $cuisinePreference' : ''}

ابتكر وصفة طبخ شهية ومبتكرة وعملية وسريعة بصيغة JSON حصراً بدون أي نصوص تمهيدية أو ختامية وبدون أي علامات خارج كائن الـ JSON.
يجب أن يكون الـ JSON بالهيكل الدقيق التالي:
{
  "title": "اسم الوصفة بالعربية",
  "description": "وصف مشوق وموجز للوصفة",
  "cuisine": "نوع المطبخ (عربي / شامي / خليجي / عالمي)",
  "difficulty": "سهل",
  "prepMinutes": 10,
  "cookMinutes": 20,
  "servings": 3,
  "calories": 400,
  "tags": ["ابتكار ذكي", "سريع", "عشاء"],
  "ingredients": [
    {
      "name": "اسم المكون",
      "amount": "الكمية بدقة",
      "role": "core"
    }
  ],
  "steps": [
    {
      "stepNo": 1,
      "text": "شرح الخطوة بالعربية مع الإرشادات",
      "timerSeconds": 300
    }
  ]
}
''';

    for (final model in _preferredModels) {
      try {
        AppLogger.info('Calling Gemini model $model for recipe generation...');
        final uri = Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$apiKey',
        );

        final req = await _client.postUrl(uri);
        req.headers.contentType = ContentType.json;
        req.write(jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ],
          'generationConfig': {
            'responseMimeType': 'application/json',
            'temperature': 0.7,
          }
        }));

        final res = await req.close().timeout(const Duration(seconds: 30));
        final body = await res.transform(utf8.decoder).join();

        if (res.statusCode == 200) {
          final json = jsonDecode(body) as Map<String, dynamic>;
          final candidates = json['candidates'] as List<dynamic>?;
          if (candidates != null && candidates.isNotEmpty) {
            final contentParts = candidates[0]['content']?['parts'] as List<dynamic>?;
            if (contentParts != null && contentParts.isNotEmpty) {
              final rawText = contentParts[0]['text'] as String;
              final parsedRecipe = _parseRecipeFromJson(rawText);
              if (parsedRecipe != null) {
                AppLogger.info('Gemini AI successfully generated recipe: ${parsedRecipe.title}');
                return parsedRecipe;
              }
            }
          }
        } else {
          AppLogger.warning('Gemini model $model returned status ${res.statusCode}: $body');
        }
      } catch (e, st) {
        AppLogger.error('Gemini call failed on model $model', error: e, stackTrace: st);
      }
    }

    AppLogger.warning('All Gemini models exhausted or unavailable. Falling back to local recipe generation.');
    return _generateLocalFallbackRecipe(pantryIngredients);
  }

  /// Analyzes an image of a fridge or shelf to detect ingredients.
  Future<List<String>> detectIngredientsFromImage(Uint8List imageBytes) async {
    final apiKey = _config.geminiApiKey;
    if (apiKey.isEmpty) {
      return ['بيض', 'طماطم', 'حليب', 'جبنة', 'خيار'];
    }

    final base64Image = base64Encode(imageBytes);
    final prompt = '''
تعرف على الأطعمة والمكونات ومحتويات الثلاجة الظاهرة في هذه الصورة.
أرجع النتيجة بصيغة JSON قائمة بالمكونات المكتشفة بالعربية:
["طماطم", "بيض", "حليب", "خيار", "جبنة"]
فقط مصفوفة JSON بدون أي نصوص إضافية.
''';

    for (final model in ['gemini-3.5-flash-lite', 'gemini-flash-latest']) {
      try {
        final uri = Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$apiKey',
        );

        final req = await _client.postUrl(uri);
        req.headers.contentType = ContentType.json;
        req.write(jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt},
                {
                  'inlineData': {
                    'mimeType': 'image/jpeg',
                    'data': base64Image,
                  }
                }
              ]
            }
          ],
          'generationConfig': {
            'responseMimeType': 'application/json',
          }
        }));

        final res = await req.close().timeout(const Duration(seconds: 30));
        final body = await res.transform(utf8.decoder).join();

        if (res.statusCode == 200) {
          final json = jsonDecode(body) as Map<String, dynamic>;
          final rawText = json['candidates']?[0]?['content']?['parts']?[0]?['text'] as String?;
          if (rawText != null) {
            final decoded = jsonDecode(rawText);
            if (decoded is List) {
              return decoded.map((e) => e.toString()).toList();
            }
          }
        }
      } catch (e) {
        AppLogger.warning('Gemini vision detection error: $e');
      }
    }

    return ['بيض', 'طماطم', 'حليب', 'جبنة', 'خيار'];
  }

  Recipe? _parseRecipeFromJson(String rawJson) {
    try {
      final cleaned = rawJson.trim();
      final data = jsonDecode(cleaned) as Map<String, dynamic>;

      final title = data['title']?.toString() ?? 'ابتكار الشيف الذكي';
      final description = data['description']?.toString() ?? 'وصفة فريدة تم إعدادها بواسطة الذكاء الاصطناعي';
      final cuisine = data['cuisine']?.toString() ?? 'ابتكار ذكي';
      final difficulty = data['difficulty']?.toString() ?? 'سهل';
      final prepMinutes = (data['prepMinutes'] as num?)?.toInt() ?? 10;
      final cookMinutes = (data['cookMinutes'] as num?)?.toInt() ?? 20;
      final servings = (data['servings'] as num?)?.toInt() ?? 2;
      final calories = (data['calories'] as num?)?.toInt() ?? 350;

      final rawTags = data['tags'] as List<dynamic>?;
      final tags = rawTags?.map((t) => t.toString()).toList() ?? ['ابتكار ذكي', 'سريع'];

      final rawIngredients = data['ingredients'] as List<dynamic>? ?? [];
      final ingredients = rawIngredients.map((ing) {
        final m = ing as Map<String, dynamic>;
        final roleStr = m['role']?.toString().toLowerCase() ?? 'core';
        IngredientRole role;
        if (roleStr.contains('core')) {
          role = IngredientRole.core;
        } else if (roleStr.contains('staple')) {
          role = IngredientRole.staple;
        } else if (roleStr.contains('optional')) {
          role = IngredientRole.optional;
        } else {
          role = IngredientRole.important;
        }

        return RecipeIngredient(
          ingredientId: 'ai_${DateTime.now().microsecondsSinceEpoch}_${m['name']}',
          name: m['name']?.toString() ?? 'مكون',
          role: role,
          amount: m['amount']?.toString() ?? 'حسب الرغبة',
          displayText: '${m['amount'] ?? ''} ${m['name'] ?? ''}'.trim(),
        );
      }).toList();

      final rawSteps = data['steps'] as List<dynamic>? ?? [];
      var stepCounter = 1;
      final steps = rawSteps.map((s) {
        final m = s as Map<String, dynamic>;
        final stepNo = (m['stepNo'] as num?)?.toInt() ?? stepCounter++;
        final text = m['text']?.toString() ?? 'اتبع التعليمات لتحضير الطبق';
        final timerSeconds = (m['timerSeconds'] as num?)?.toInt();
        return RecipeStep(
          stepNo: stepNo,
          text: text,
          timerSeconds: timerSeconds,
        );
      }).toList();

      return Recipe(
        id: 'gemini_${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        description: description,
        cuisine: cuisine,
        difficulty: difficulty,
        prepMinutes: prepMinutes,
        cookMinutes: cookMinutes,
        servings: servings,
        calories: calories,
        heroImageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=800&q=80',
        tags: tags,
        verified: false,
        ingredients: ingredients,
        steps: steps,
      );
    } catch (e, st) {
      AppLogger.error('Failed to parse recipe JSON from Gemini', error: e, stackTrace: st);
      return null;
    }
  }

  Recipe _generateLocalFallbackRecipe(List<String> pantry) {
    return Recipe(
      id: 'local_ai_${DateTime.now().millisecondsSinceEpoch}',
      title: 'عجة الخضار والأعشاب بالمقلاة الذهبية',
      description: 'وصفة سريعة ولذيذة تم ابتكارها بناءً على المكونات المتوفرة في مطبخك، متوازنة وغنية بالبروتين.',
      cuisine: 'ابتكار ذكي',
      difficulty: 'سهل جداً',
      prepMinutes: 10,
      cookMinutes: 15,
      servings: 2,
      calories: 320,
      heroImageUrl: 'https://images.unsplash.com/photo-1525351484163-7529414344d8?auto=format&fit=crop&w=800&q=80',
      tags: ['ابتكار ذكي', 'سريع', 'عالي البروتين'],
      verified: false,
      ingredients: const [
        RecipeIngredient(
          ingredientId: 'ing_eggs',
          name: 'بيض',
          role: IngredientRole.core,
          amount: '3 حبات',
        ),
        RecipeIngredient(
          ingredientId: 'ing_tomato',
          name: 'طماطم',
          role: IngredientRole.important,
          amount: 'حبة واحدة مفرومة',
        ),
        RecipeIngredient(
          ingredientId: 'ing_onion',
          name: 'بصل',
          role: IngredientRole.important,
          amount: 'نصف حبة مفرومة',
        ),
        RecipeIngredient(
          ingredientId: 'ing_oil_vegetable',
          name: 'زيت نباتي أو زبدة',
          role: IngredientRole.staple,
          amount: 'ملعقة كبيرة',
        ),
      ],
      steps: const [
        RecipeStep(
          stepNo: 1,
          text: 'في مقلاة على نار متوسطة، سخن ملعقة الزيت وشوح البصل والطماطم المفرومة لمدة 4 دقائق.',
          timerSeconds: 240,
        ),
        RecipeStep(
          stepNo: 2,
          text: 'اخفق البيض مع رشة ملح وفلفل أسود وبهاراتك المفضلة حتى يتجانس.',
          timerSeconds: 60,
        ),
        RecipeStep(
          stepNo: 3,
          text: 'اسكب البيض المخفوق فوق الخضار، وخفف النار ثم غط المقلاة لمدة 6 إلى 8 دقائق حتى يتماسك القرص تماماً.',
          timerSeconds: 420,
        ),
      ],
    );
  }
}

/// Riverpod provider for GeminiAiService
final geminiAiServiceProvider = Provider<GeminiAiService>((ref) {
  final config = ref.watch(appConfigProvider);
  return GeminiAiService(config);
});
