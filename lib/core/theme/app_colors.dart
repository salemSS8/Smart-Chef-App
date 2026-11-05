import 'package:flutter/material.dart';

/// نظام الألوان المطابق 100% لـ Smart Cook Editorial System (Stitch MCP - projects/17025429917112534856)
/// يعكس هوية النشر الطهوي الرفيع: الأخضر النباتي العميق والورق العاجي الدافئ وذهب الزعفران
class AppColors {
  AppColors._();

  // Primary: Deep Forest Green (#093425 & #234B3A)
  static const Color primary = Color(0xFF093425); // Primary Anchor
  static const Color primaryContainer = Color(0xFF234B3A); // Deep Forest Green
  static const Color primaryLight = Color(0xFFC0ECD5); // Sage Mint
  static const Color primaryDark = Color(0xFF093425);
  static const Color primaryFixed = Color(0xFFC0ECD5); // Sage Mint
  static const Color primaryFixedDim = Color(0xFFA5D0BA);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFF8FBAA4);

  // Secondary: Culinary Warm Cream & Muted Herb (#605E58 & #E6E2D9)
  static const Color secondary = Color(0xFF605E58);
  static const Color secondaryContainer = Color(0xFFE6E2D9); // Warm Cream
  static const Color secondaryCream = Color(0xFFF7F3EA);
  static const Color secondaryLight = Color(0xFFF7F3EA);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onSecondaryContainer = Color(0xFF66645D);

  // Tertiary: Warm Wine & Rose Accents (#492221 & #FFDAD8)
  static const Color tertiary = Color(0xFF492221);
  static const Color tertiaryContainer = Color(0xFF633736);
  static const Color tertiaryFixed = Color(0xFFFFDAD8); // Used for Expiring ingredient pills
  static const Color tertiaryFixedDim = Color(0xFFF6B7B4);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color onTertiaryContainer = Color(0xFFDEA19F);

  // Background & Surfaces: Warm Ivory cookbook parchment (#F9FAF6 & #FFFFFF)
  static const Color backgroundLight = Color(0xFFF9FAF6); // Warm Ivory Canvas
  static const Color surfaceLight = Color(0xFFF9FAF6);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF); // Card white
  static const Color surfaceContainerLow = Color(0xFFF3F4F1);
  static const Color surfaceContainer = Color(0xFFEEEEEB);
  static const Color surfaceContainerHigh = Color(0xFFE8E8E5);
  static const Color surfaceContainerHighest = Color(0xFFE2E3E0);
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
  static const Color danger = Color(0xFFBA1A1A); // تحذيرات الحساسية والحرارة
  static const Color dangerLight = Color(0xFFFFDAD6);
  static const Color success = Color(0xFF2E7D32); // الوصفات الموثقة والمجازة
  static const Color successLight = Color(0xFFE8F5E9);
  static const Color warning = Color(0xFFE67E22); // قيد المراجعة
  static const Color surfaceTint = Color(0xFF3E6654);

  // Text Colors (Ink on parchment)
  static const Color textPrimaryLight = Color(0xFF1A1C1A); // حبر زيتي فحمي عالي التباين
  static const Color textSecondaryLight = Color(0xFF414844); // رمادي عشبي ناعم للبيانات الثانوية
  static const Color textPrimaryDark = Color(0xFFF0F4F1);
  static const Color textSecondaryDark = Color(0xFFA1ABA5);

  // Borders & Dividers: Warm bone hairline divider (#E8E5DC)
  static const Color borderLight = Color(0xFFE8E5DC);
  static const Color borderDark = Color(0xFF2A3B33);
}
