import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/services/app_update_service.dart';
import '../../core/services/sync_service.dart';
import '../../core/theme/app_colors.dart';
import '../../data/mock/recipes_data.dart';
import '../providers/auth_provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/pantry_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/auth_modal.dart';
import '../widgets/recipe_card.dart';
import 'paywall_screen.dart';
import 'onboarding_screen.dart';
import 'meal_planner_screen.dart';
import 'cookbooks_screen.dart';
import 'dietary_allergens_screen.dart';
import 'recipe_creator_screen.dart';
import 'creator_submissions_screen.dart';
import 'shopping_screen.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _expiringAlerts = true;
  bool _dinnerAlert = true;
  bool _aiSubstitutions = true;
  bool _screenWakeLock = true;
  String _unitStandard = 'metric'; // 'metric', 'imperial'
  String _activeFolder = 'all';

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final pantry = ref.watch(pantryProvider);
    final favIds = ref.watch(favoritesProvider);
    final authUser = ref.watch(authProvider);
    final syncStatusAsync = ref.watch(syncStatusStreamProvider);
    final syncStatus = syncStatusAsync.value ?? SyncStatus.idle;

    final favRecipes = RecipesData.allRecipes
        .where((r) => favIds.contains(r.id))
        .map((r) => r.evaluateMatch(pantry))
        .toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'الملف الشخصي والإعدادات',
          style: GoogleFonts.cairo(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: isDark ? AppColors.textPrimaryDark : AppColors.primary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'تحديث المزامنة',
            onPressed: () {
              ref.read(syncServiceProvider).processSyncQueue();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('جاري مزامنة بيانات المطبخ مع السحابة...'),
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        children: [
          // 0. Editorial Kitchen OS Header Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.secondaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.tune_rounded, size: 15, color: AppColors.primary),
                const SizedBox(width: 6),
                Text(
                  'KITCHEN OS • نظام إدارة المطبخ الذكي',
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.accentGold : AppColors.primary,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Text(
            'الإعدادات والتفضيلات الذكية',
            style: GoogleFonts.newsreader(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.primary,
              height: 1.2,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            'تخصيص اللهجات الطهوية، حواجز الحساسية، وتكامل السحابة وإدارة الوصفات.',
            style: GoogleFonts.cairo(
              fontSize: 12,
              color: isDark ? AppColors.textSecondaryDark : AppColors.secondary,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 16),

          // 1. Chef Profile Plaque matching Stitch
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(isDark ? 30 : 6),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: AppColors.primaryFixed,
                          child: Text(
                            authUser.isAnonymous ? '👨‍🍳' : '⭐',
                            style: const TextStyle(fontSize: 30),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 18,
                            height: 18,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.check, size: 12, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  authUser.isAnonymous
                                      ? 'ضيف طاهي ذكي'
                                      : (authUser.email ?? authUser.displayName ?? 'طاهي مسجل'),
                                  style: GoogleFonts.cairo(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.secondaryContainer,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  authUser.isAnonymous ? 'مستوى 1' : 'شيف Pro',
                                  style: GoogleFonts.manrope(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '${pantry.length} مكونات في مطبخك · ${favIds.length} وصفات محفوظة',
                            style: GoogleFonts.cairo(
                              fontSize: 11,
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        visualDensity: VisualDensity.compact,
                      ),
                      onPressed: () => AuthModal.show(context),
                      child: Text(
                        authUser.isAnonymous ? 'تسجيل / ربط' : 'إدارة',
                        style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkBackground : AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        syncStatus == SyncStatus.syncing
                            ? Icons.sync_rounded
                            : syncStatus == SyncStatus.offline
                                ? Icons.cloud_off_rounded
                                : Icons.cloud_done_rounded,
                        size: 16,
                        color: syncStatus == SyncStatus.syncing
                            ? AppColors.warning
                            : syncStatus == SyncStatus.offline
                                ? AppColors.secondary
                                : AppColors.success,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          syncStatus == SyncStatus.syncing
                              ? 'جاري المزامنة مع Supabase...'
                              : syncStatus == SyncStatus.offline
                                  ? 'العمل دون اتصال (محفوظ محلياً في Drift DB)'
                                  : 'متزامن سحابياً مع Supabase (71 وصفة مؤمنة)',
                          style: GoogleFonts.cairo(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Upgrade to Pro Card (Editorial Gold & Deep Forest Green)
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PaywallScreen()),
              );
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withAlpha(50),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.accentGold.withAlpha(40),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.workspace_premium_rounded, color: AppColors.accentGold, size: 26),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ترقية إلى طاهي ذكي Pro 👑',
                          style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        Text(
                          'تحليل غير محدود للثلاجة بالذكاء الاصطناعي وخطة الوجبات التلقائية',
                          style: GoogleFonts.cairo(color: AppColors.primaryFixedDim, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_left_rounded, color: AppColors.accentGold, size: 22),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // SECTION 1: التوطين ومعايير القياس
          _buildSectionHeader('التوطين ومعايير القياس 🌍', Icons.public_rounded),
          const SizedBox(height: 8),

          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
            ),
            child: Column(
              children: [
                ListTile(
                  title: Text('لغة واجهة الطهي', style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: Text('العربية (لهجات المطبخ الشامي، الخليجي، المصري، المغاربي)', style: GoogleFonts.cairo(fontSize: 11)),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkBackground : AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('عربي (AR)', style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  ),
                ),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('معيار قياس المقادير', style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 13)),
                          Text('يُطبّق على بطاقات الوصفات', style: GoogleFonts.cairo(fontSize: 11, color: AppColors.secondary)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkBackground : AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            _buildUnitToggle('metric', 'متري (غرام/مل)'),
                            _buildUnitToggle('imperial', 'أكواب وملاعق'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // SECTION 2: الحمية وسلامة المطبخ
          _buildSectionHeader('الحمية وسلامة المطبخ 🛡️', Icons.health_and_safety_rounded),
          const SizedBox(height: 8),

          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.shield_outlined, color: AppColors.primary),
                  title: Text('إدارة الحساسيات والحميات 🥗', style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: Text('استبعاد المكسرات، الجلوتين، أو اللاكتوز تلقائياً', style: GoogleFonts.cairo(fontSize: 11)),
                  trailing: const Icon(Icons.chevron_left_rounded, size: 20),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const DietaryAllergensScreen()),
                    );
                  },
                ),
                const Divider(height: 1),
                SwitchListTile.adaptive(
                  value: _aiSubstitutions,
                  activeTrackColor: AppColors.primary,
                  title: Text('بدائل المكونات الذكية بالذكاء الاصطناعي', style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: Text('اقتراح بديل من مؤونتك للمكونات الناقصة أو المسببة للحساسية', style: GoogleFonts.cairo(fontSize: 11)),
                  onChanged: (val) => setState(() => _aiSubstitutions = val),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // SECTION 3: أدوات الطاهي وتكامل الداشبورد
          _buildSectionHeader('أدوات الطاهي وتكامل الداشبورد 👨‍🍳', Icons.dashboard_customize_rounded),
          const SizedBox(height: 8),

          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.calendar_month_rounded, color: AppColors.primary),
                  title: Text('مخطط الوجبات الأسبوعي 🗓️', style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: Text('جدولة وجبات الأسبوع وتوليد قائمة النواقص تلقائياً', style: GoogleFonts.cairo(fontSize: 11)),
                  trailing: const Icon(Icons.chevron_left_rounded, size: 20),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const MealPlannerScreen()));
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.menu_book_rounded, color: AppColors.accentGold),
                  title: Text('كتيباتي والوصفات المحفوظة 📚', style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: Text('مجموعات مخصصة وسجل الطهي المنزلي (${favIds.length} وصفات)', style: GoogleFonts.cairo(fontSize: 11)),
                  trailing: const Icon(Icons.chevron_left_rounded, size: 20),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const CookbooksScreen()));
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.shopping_cart_outlined, color: AppColors.primary),
                  title: Text('قائمة التسوق الذكية 🛒', style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: Text('نواقص المكونات المحسوبة من محرك المطابقة', style: GoogleFonts.cairo(fontSize: 11)),
                  trailing: const Icon(Icons.chevron_left_rounded, size: 20),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ShoppingScreen()));
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.add_circle_outline_rounded, color: AppColors.primary),
                  title: Text('استوديو ابتكار الوصفات ✍️', style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: Text('تأليف وصفات جديدة بمساعدة AI وإرسالها للنشر', style: GoogleFonts.cairo(fontSize: 11)),
                  trailing: const Icon(Icons.chevron_left_rounded, size: 20),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const RecipeCreatorScreen()));
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.fact_check_rounded, color: AppColors.primary),
                  title: Text('لوحة المبدع وحالة الوصفات 📋', style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: Text('متابعة التدقيق التحريري والوصفات المعتمدة في الداشبورد', style: GoogleFonts.cairo(fontSize: 11)),
                  trailing: const Icon(Icons.chevron_left_rounded, size: 20),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const CreatorSubmissionsScreen()));
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.dashboard_customize_rounded, color: AppColors.accentGold),
                  title: Text('لوحة تحكم المشرف (Web Dashboard) 🌐', style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: Text('smart-cook-admin.vercel.app — إدارة 71 وصفة والمحتوى', style: GoogleFonts.cairo(fontSize: 11)),
                  trailing: const Icon(Icons.open_in_new_rounded, size: 16),
                  onTap: () async {
                    final uri = Uri.parse('https://smart-cook-admin.vercel.app');
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    }
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // SECTION 4: المظهر ووضع الموقد والإشعارات
          _buildSectionHeader('المظهر ووضع الموقد والإشعارات 🔔', Icons.notifications_active_rounded),
          const SizedBox(height: 8),

          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
            ),
            child: Column(
              children: [
                SwitchListTile.adaptive(
                  value: isDark,
                  activeTrackColor: AppColors.primary,
                  title: Text('الوضع الليلي (Dark Mode)', style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: Text('تفعيل الثيم الداكن للراحة البصرية أثناء الطهي', style: GoogleFonts.cairo(fontSize: 11)),
                  onChanged: (val) {
                    ref.read(themeProvider.notifier).setTheme(val ? ThemeMode.dark : ThemeMode.light);
                  },
                ),
                const Divider(height: 1),
                SwitchListTile.adaptive(
                  value: _screenWakeLock,
                  activeTrackColor: AppColors.primary,
                  title: Text('إبقاء الشاشة مضاءة على الموقد (Wake Lock)', style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: Text('منع إطفاء الشاشة تلقائياً أثناء تنفيذ خطوات الطبخ الحية', style: GoogleFonts.cairo(fontSize: 11)),
                  onChanged: (val) => setState(() => _screenWakeLock = val),
                ),
                const Divider(height: 1),
                SwitchListTile.adaptive(
                  value: _expiringAlerts,
                  activeTrackColor: AppColors.primary,
                  title: Text('تنبيه المكونات القريبة من الفساد', style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: Text('إشعار قبل انتهاء صلاحية الأطعمة بـ 48 ساعة لتقليل الهدر', style: GoogleFonts.cairo(fontSize: 11)),
                  onChanged: (val) => setState(() => _expiringAlerts = val),
                ),
                const Divider(height: 1),
                SwitchListTile.adaptive(
                  value: _dinnerAlert,
                  activeTrackColor: AppColors.primary,
                  title: Text('اقتراح عشاء اليوم', style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: Text('تذكير يومي في الساعة 07:00 مساءً بما يمكنك طهيه من ثلاجتك', style: GoogleFonts.cairo(fontSize: 11)),
                  onChanged: (val) => setState(() => _dinnerAlert = val),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.explore_outlined, color: AppColors.primary),
                  title: Text('إعادة تشغيل جولة البدء (Onboarding)', style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: Text('التعرف على مميزات مسح الثلاجة والأوامر الصوتية', style: GoogleFonts.cairo(fontSize: 11)),
                  trailing: const Icon(Icons.chevron_left_rounded, size: 20),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const OnboardingScreen()));
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.system_update_rounded, color: AppColors.primary),
                  title: Text('التحقق من التحديثات', style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: Text('فحص ما إذا كان هناك إصدار أحدث للتطبيق', style: GoogleFonts.cairo(fontSize: 11)),
                  trailing: const Icon(Icons.chevron_left_rounded, size: 20),
                  onTap: () => AppUpdateService.manualCheckForUpdates(context),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // SECTION 5: المفضلة والمجلدات
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'الوصفات المحفوظة (${favRecipes.length})',
                style: GoogleFonts.newsreader(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              ChoiceChip(
                label: const Text('الكل 📁'),
                selected: _activeFolder == 'all',
                selectedColor: AppColors.primary,
                labelStyle: TextStyle(color: _activeFolder == 'all' ? Colors.white : AppColors.primary),
                onSelected: (_) => setState(() => _activeFolder = 'all'),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('وجبات رئيسية 🍲'),
                selected: _activeFolder == 'lunch',
                selectedColor: AppColors.primary,
                labelStyle: TextStyle(color: _activeFolder == 'lunch' ? Colors.white : AppColors.primary),
                onSelected: (_) => setState(() => _activeFolder = 'lunch'),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('سريعة التحضير ⚡'),
                selected: _activeFolder == 'dinner',
                selectedColor: AppColors.primary,
                labelStyle: TextStyle(color: _activeFolder == 'dinner' ? Colors.white : AppColors.primary),
                onSelected: (_) => setState(() => _activeFolder = 'dinner'),
              ),
            ],
          ),

          const SizedBox(height: 10),

          if (favRecipes.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
              ),
              child: Column(
                children: [
                  const Icon(Icons.bookmark_border_rounded, size: 40, color: AppColors.secondary),
                  const SizedBox(height: 8),
                  Text('لا توجد وصفات محفوظة في هذا المجلد بعد', style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(
                    'المس علامة الحفظ عند استعراض أي وصفة لإضافتها هنا لتصل إليها دون إنترنت.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cairo(color: AppColors.secondary, fontSize: 11),
                  ),
                ],
              ),
            )
          else
            ...favRecipes.take(3).map((r) => RecipeCard(matchResult: r, isHorizontal: false)),

          const SizedBox(height: 24),

          // Compliance & Privacy Tile (Apple App Store Guideline 5.1.1(v) & Google Play Store Policy)
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.danger.withAlpha(60)),
            ),
            child: ListTile(
              leading: const Icon(Icons.delete_forever_rounded, color: AppColors.danger),
              title: Text(
                'حذف الحساب والبيانات نهائياً',
                style: GoogleFonts.cairo(color: AppColors.danger, fontWeight: FontWeight.bold, fontSize: 13),
              ),
              subtitle: Text(
                'حذف فوري لجميع البيانات السحابية والمحلية بدون استرجاع',
                style: GoogleFonts.cairo(fontSize: 11),
              ),
              trailing: const Icon(Icons.chevron_left_rounded, size: 20, color: AppColors.danger),
              onTap: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('تأكيد حذف الحساب والبيانات'),
                    content: const Text(
                      'هل أنت متأكد من رغبتك في حذف حسابك وجميع بياناتك نهائياً؟ سيتم مسح كافة المكونات والوصفات المحفوظة وقائمة التسوق فوراً من هذا الجهاز والسحابة.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('إلغاء'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text('حذف نهائي', style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                );

                if (confirm == true && context.mounted) {
                  await ref.read(authProvider.notifier).deleteAccountAndUserData();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم حذف بيانات الحساب والمخزن بنجاح.')),
                    );
                  }
                }
              },
            ),
          ),

          const SizedBox(height: 28),

          // Brand Footnote
          Center(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/image/icon-1024.png',
                    width: 56,
                    height: 56,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'طاهي ذكي — Smart Cook',
                  style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  'Smart Cook Anthology • Version 4.12.0 • Build 892',
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.secondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'طبخ أذكى • هدر أقل • توفير أكثر\nمبني وفق أرقى معايير النشر الطهوي الأصيل.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(
                    fontSize: 11,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.secondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 36),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 6),
        Text(
          title,
          style: GoogleFonts.cairo(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textPrimaryDark : AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildUnitToggle(String key, String label) {
    final isSelected = _unitStandard == key;
    return InkWell(
      onTap: () => setState(() => _unitStandard = key),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: GoogleFonts.cairo(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.white : AppColors.secondary,
          ),
        ),
      ),
    );
  }
}
