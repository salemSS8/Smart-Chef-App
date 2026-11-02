// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';
import 'package:smart_cook/data/mock/recipes_data.dart';

void main() async {
  final recipes = RecipesData.allRecipes;
  print('بدء رفع ${recipes.length} وصفة إلى Supabase...');

  const supabaseUrl = 'https://duwiaouvjktgwazvifoq.supabase.co';
  const publishableKey = 'sb_publishable_TRpTM5xhfZdi-xZLp_cCGQ_mradZcUo';

  final client = HttpClient();
  int successCount = 0;
  int errorCount = 0;

  // إرسال على دفعات لتفادي الحمل الزائد
  const batchSize = 10;
  for (int i = 0; i < recipes.length; i += batchSize) {
    final end = (i + batchSize < recipes.length) ? i + batchSize : recipes.length;
    final batch = recipes.sublist(i, end);

    final payload = batch.map((r) => r.toJson()).toList();
    final jsonString = jsonEncode(payload);
    final bytes = utf8.encode(jsonString);

    try {
      final request = await client.postUrl(Uri.parse('$supabaseUrl/rest/v1/recipes'));
      request.headers.set('apikey', publishableKey);
      request.headers.set('Authorization', 'Bearer $publishableKey');
      request.headers.set('Content-Type', 'application/json; charset=utf-8');
      request.headers.set('Prefer', 'resolution=merge-duplicates');
      request.headers.contentLength = bytes.length;

      request.add(bytes);
      final response = await request.close();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        successCount += batch.length;
        print('✅ تم رفع الدفعة (${i + 1} إلى $end) بنجاح.');
      } else {
        final responseBody = await response.transform(utf8.decoder).join();
        print('❌ خطأ في رفع الدفعة (${i + 1} إلى $end): كود ${response.statusCode} - $responseBody');
        errorCount += batch.length;
      }
    } catch (e) {
      print('❌ استثناء أثناء إرسال الدفعة: $e');
      errorCount += batch.length;
    }
  }

  client.close();
  print('========================================');
  print('اكتمل الرفع: نجح $successCount وصفة، فشل $errorCount وصفة');
  print('========================================');
}
