import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/models/recipe.dart';
import 'auth_service.dart';

/// نموذج يمثل تقديم وصفة وحالتها في التدقيق التحريري والداشبورد
class RecipeSubmission {
  final Recipe recipe;
  final String status; // 'draft', 'pending_review', 'approved', 'needs_revision'
  final String? reviewerNotes;
  final DateTime createdAt;
  final DateTime? reviewedAt;

  const RecipeSubmission({
    required this.recipe,
    required this.status,
    this.reviewerNotes,
    required this.createdAt,
    this.reviewedAt,
  });

  bool get isApproved => status == 'approved';
  bool get isPending => status == 'pending_review';
  bool get needsRevision => status == 'needs_revision';
}

/// خدمة إدارة تقديم وتدقيق وصفات المبدعين والتكامل مع Supabase ولوحة التحكم
class CreatorRecipeService {
  CreatorRecipeService._();

  // ذاكرة تخزين مؤقتة للوصفات المقدمة محلياً أثناء انقطاع الاتصال
  static final List<RecipeSubmission> _localSubmissions = [];

  /// إرسال أو تحديث وصفة في Supabase ليتم تدقيقها في لوحة التحكم الإدارية
  static Future<bool> submitRecipe({
    required Recipe recipe,
    String status = 'pending_review',
  }) async {
    final user = AuthService.activeUser;
    final userId = user.id;
    final userEmail = user.email ?? 'chef@smartcook.app';

    final payload = {
      'id': recipe.id,
      'title': recipe.title,
      'description': recipe.description,
      'cuisine': recipe.cuisine,
      'difficulty': recipe.difficulty,
      'prep_minutes': recipe.prepMinutes,
      'cook_minutes': recipe.cookMinutes,
      'servings': recipe.servings,
      'calories': recipe.calories,
      'hero_image_url': recipe.heroImageUrl,
      'tags': recipe.tags,
      'verified': status == 'approved',
      'ingredients': recipe.ingredients.map((e) => e.toJson()).toList(),
      'steps': recipe.steps.map((e) => e.toJson()).toList(),
      'creator_id': userId,
      'creator_email': userEmail,
      'status': status,
      'updated_at': DateTime.now().toIso8601String(),
    };

    // حفظ محلي فوري
    _localSubmissions.removeWhere((s) => s.recipe.id == recipe.id);
    _localSubmissions.insert(
      0,
      RecipeSubmission(
        recipe: recipe,
        status: status,
        createdAt: DateTime.now(),
      ),
    );

    try {
      if (Supabase.instance.isInitialized) {
        final client = Supabase.instance.client;
        await client.from('recipes').upsert(payload);
        debugPrint('✅ [CreatorService] Recipe submitted successfully to Supabase: ${recipe.title}');
        return true;
      }
    } catch (e) {
      debugPrint('⚠️ [CreatorService] Failed to push to Supabase, retained locally: $e');
    }

    return true;
  }

  /// جلب الوصفات المقدمة من المبدع الحالي وحالات مراجعتها
  static Future<List<RecipeSubmission>> getMySubmissions() async {
    final user = AuthService.activeUser;
    final userId = user.id;

    try {
      if (Supabase.instance.isInitialized) {
        final client = Supabase.instance.client;
        final response = await client
            .from('recipes')
            .select()
            .eq('creator_id', userId)
            .order('updated_at', ascending: false);

        if (response.isNotEmpty) {
          return response.map<RecipeSubmission>((row) {
            final json = Map<String, dynamic>.from(row as Map);
            final recipe = Recipe.fromJson(json);
            return RecipeSubmission(
              recipe: recipe,
              status: (json['status'] as String?) ?? (recipe.verified ? 'approved' : 'pending_review'),
              reviewerNotes: json['reviewer_notes'] as String?,
              createdAt: json['created_at'] != null
                  ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
                  : DateTime.now(),
              reviewedAt: json['reviewed_at'] != null
                  ? DateTime.tryParse(json['reviewed_at'].toString())
                  : null,
            );
          }).toList();
        }
      }
    } catch (e) {
      debugPrint('⚠️ [CreatorService] Error fetching submissions from Supabase: $e');
    }

    return List.unmodifiable(_localSubmissions);
  }

  /// حذف مسودة
  static Future<bool> deleteDraft(String recipeId) async {
    _localSubmissions.removeWhere((s) => s.recipe.id == recipeId);
    try {
      if (Supabase.instance.isInitialized) {
        final client = Supabase.instance.client;
        await client.from('recipes').delete().eq('id', recipeId);
      }
      return true;
    } catch (_) {
      return false;
    }
  }
}
