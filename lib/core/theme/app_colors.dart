import 'package:flutter/material.dart';

/// نظام الألوان المستخرج والمطابق لـ Smart Cook Editorial System (Stitch MCP)
/// يعكس هوية النشر الطهوي الرفيع: الأخضر النباتي العميق والورق العاجي الدافئ وذهب الزعفران
class AppColors {
  AppColors._();

  // Primary: Deep Forest Green (#234B3A) - اللون الأساسي المميز للمنصة
  static const Color primary = Color(0xFF234B3A);
  static const Color primaryDark = Color(0xFF093425);
  static const Color primaryLight = Color(0xFFE8F0EC); // Sage tint container

  // Secondary: Culinary Warm Cream & Muted Herb
  static const Color secondary = Color(0xFF605E58);
  static const Color secondaryCream = Color(0xFFF7F3EA); // Warm cream container
  static const Color secondaryLight = Color(0xFFF7F3EA);

  // Backgrounds: Warm Ivory cookbook parchment (#FCFAF7)
  static const Color backgroundLight = Color(0xFFFCFAF7);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color surfaceCream = Color(0xFFF7F3EA);

  // Dark Mode: Botanical Slate & Charcoal Moss
  static const Color backgroundDark = Color(0xFF0F1713);
  static const Color surfaceDark = Color(0xFF16221D);
  static const Color cardDark = Color(0xFF1E2D27);
  static const Color darkBackground = backgroundDark;
  static const Color darkSurface = surfaceDark;
  static const Color darkSurfaceElevated = cardDark;
  static const Color accentSage = Color(0xFFA5D0BA);

  // Accents & Culinary Signals
  static const Color accentGold = Color(0xFFE5A83B); // Saffron Gold (التقييمات، شارات التميز)
  static const Color accentTomato = Color(0xFFD96B4B); // Tomato Red (مؤقتات الطهي الحية)
  static const Color accentPeach = Color(0xFFF39E75);
  static const Color danger = Color(0xFFBA1A1A); // تحذيرات الحساسية والحرارة
  static const Color dangerLight = Color(0xFFFFDAD6);
  static const Color success = Color(0xFF2E7D32); // الوصفات الموثقة والمجازة
  static const Color successLight = Color(0xFFE8F5E9);
  static const Color warning = Color(0xFFE67E22); // قيد المراجعة
  static const Color info = Color(0xFF2980B9);

  // Text Colors (Ink on parchment)
  static const Color textPrimaryLight = Color(0xFF242923); // حبر زيتي فحمي عالي التباين
  static const Color textSecondaryLight = Color(0xFF777D75); // رمادي عشبي ناعم للبيانات الثانوية
  static const Color textPrimaryDark = Color(0xFFF0F4F1);
  static const Color textSecondaryDark = Color(0xFFA1ABA5);

  // Borders & Dividers: Warm bone hairline divider (#E8E5DC)
  static const Color borderLight = Color(0xFFE8E5DC);
  static const Color borderDark = Color(0xFF2A3B33);
}

