import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _expiringAlerts = true;
  bool _dinnerAlert = true;
  String _activeFolder = 'all'; // 'all', 'lunch', 'dinner'

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
      appBar: AppBar(
        title: const Text('أنا والملف الشخصي 👤'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        children: [
          // User & Profile Card (matching "أنا" tab)
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
                  color: Colors.black.withAlpha(isDark ? 20 : 6),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: AppColors.primaryLight,
                      child: Text(authUser.isAnonymous ? '👨‍🍳' : '⭐', style: const TextStyle(fontSize: 28)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            authUser.isAnonymous
                                ? 'ضيف طاهي ذكي'
                                : (authUser.email ?? authUser.displayName ?? 'طاهي مسجل'),
                            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${pantry.length} مكونات في مطبخك · ${favIds.length} وصفات محفوظة',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () => AuthModal.show(context),
                      child: Text(
                        authUser.isAnonymous ? 'تسجيل / ربط' : 'إدارة الحساب',
                        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.black26 : Colors.grey.shade100,
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
                            ? Colors.orange
                            : syncStatus == SyncStatus.offline
                                ? Colors.grey
                                : Colors.green,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        syncStatus == SyncStatus.syncing
                            ? 'جاري المزامنة السحابية...'
                            : syncStatus == SyncStatus.offline
                                ? 'العمل دون اتصال (محفوظ محلياً)'
                                : 'البيانات متزامنة سحابياً وفي أمان',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),


          const SizedBox(height: 16),

          // Upgrade to Pro Card
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
                gradient: const LinearGradient(
                  colors: [Color(0xFFE8742C), Color(0xFFC0392B)],
                  begin: AlignmentDirectional.topStart,
                  end: AlignmentDirectional.bottomEnd,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 32),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ترقية إلى طاهي ذكي Pro 👑',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'ذكاء اصطناعي غير محدود وبلا إعلانات (تجربة 7 أيام مجاناً)',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 16),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // SECTION: المفضلة والمجلدات (Folder-based saved recipes)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'الوصفات المحفوظة (${favRecipes.length})',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Folder chips
          Row(
            children: [
              ChoiceChip(
                label: const Text('الكل 📁'),
                selected: _activeFolder == 'all',
                onSelected: (_) => setState(() => _activeFolder = 'all'),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('وجبات الغداء 🍲'),
                selected: _activeFolder == 'lunch',
                onSelected: (_) => setState(() => _activeFolder = 'lunch'),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('أطباق سريعة ⚡'),
                selected: _activeFolder == 'dinner',
                onSelected: (_) => setState(() => _activeFolder = 'dinner'),
              ),
            ],
          ),

          const SizedBox(height: 12),

          if (favRecipes.isEmpty)
            Container(
              padding: const EdgeInsets.all(28),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
              ),
              child: Column(
                children: [
                  const Icon(Icons.bookmark_border_rounded, size: 50, color: Colors.grey),
                  const SizedBox(height: 8),
                  const Text('لا توجد وصفات في هذا المجلد بعد', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                    'المس علامة القلب عند تصفح أي وصفة لحفظها هنا للرجوع إليها لاحقاً.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight, fontSize: 12),
                  ),
                ],
              ),
            )
          else
            ...favRecipes.map((r) => RecipeCard(matchResult: r, isHorizontal: false)),

          const SizedBox(height: 24),

          // SECTION: الإشعارات
          const Text('الإشعارات والتذكير 🔔', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),

          Card(
            child: Column(
              children: [
                SwitchListTile.adaptive(
                  value: _expiringAlerts,
                  activeTrackColor: AppColors.primary,
                  title: const Text('تنبيه المكونات القريبة من الفساد'),
                  subtitle: const Text('إشعار قبل انتهاء صلاحية الأطعمة بيومين لتقليل الهدر'),
                  onChanged: (val) => setState(() => _expiringAlerts = val),
                ),
                const Divider(height: 1),
                SwitchListTile.adaptive(
                  value: _dinnerAlert,
                  activeTrackColor: AppColors.primary,
                  title: const Text('اقتراح عشاء اليوم'),
                  subtitle: const Text('تذكير يومي في الساعة 07:00 مساءً بما يمكنك طهيه'),
                  onChanged: (val) => setState(() => _dinnerAlert = val),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // SECTION: المظهر واللغة
          const Text('المظهر واللغة ⚙️', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),

          Card(
            child: Column(
              children: [
                SwitchListTile.adaptive(
                  value: isDark,
                  activeTrackColor: AppColors.primary,
                  secondary: Icon(isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded, color: AppColors.primary),
                  title: const Text('الوضع الليلي (Dark Mode)'),
                  subtitle: Text(isDark ? 'المظهر الداكن مفعل' : 'المظهر الفاتح الدافئ'),
                  onChanged: (_) => ref.read(themeProvider.notifier).toggleTheme(),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.language_rounded, color: AppColors.primary),
                  title: const Text('لغة التطبيق والمطابخ المفضلة'),
                  subtitle: const Text('العربية (RTL) / English — مطابخ عالمية'),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const OnboardingScreen()),
                    );
                  },
                ),
                const Divider(height: 1),
                const ListTile(
                  leading: Icon(Icons.offline_pin_rounded, color: AppColors.secondary),
                  title: Text('العمل دون اتصال (Offline-first)'),
                  subtitle: Text('قاعدة البيانات وخوارزمية المطابقة تعمل محلياً على جهازك بسرعة فائقة وبصفر تكلفة استضافة.'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.tune_rounded, color: AppColors.primary),
                  title: const Text('جولة الترحيب وتفضيلات اللهجة'),
                  subtitle: const Text('إعادة تعيين بلدك واللهجة ونظام الوحدات والحميات'),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const OnboardingScreen()),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.system_update_rounded, color: AppColors.primary),
                  title: const Text('التحقق من وجود تحديثات'),
                  subtitle: const Text('الإصدار الحالي v1.0.0 — مرتبط بـ GitHub Releases'),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                  onTap: () async {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('جاري فحص التحديثات...'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                    final info = await AppUpdateService.checkUpdate();
                    if (!context.mounted) return;
                    if (info != null && info.hasUpdate) {
                      await AppUpdateService.showUpdateDialog(context, info);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('أنت تستخدم أحدث إصدار من طاهي ذكي (v1.0.0) ✨'),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // SECTION: عن طاهي ذكي
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/image/icon-1024.png',
                    width: 72,
                    height: 72,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'طاهي ذكي — Smart Cook',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'الإصدار 1.0.0 (النسخة المستقرة)',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'طبخ أذكى • هدر أقل • توفير أكثر\nمصمم خصيصاً للمطبخ العربي الأصيل وبصفر تكلفة استضافة.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Compliance & Privacy Tile (Apple App Store Guideline 5.1.1(v) & Google Play Store Policy)
          Card(
            color: isDark ? AppColors.surfaceDark : Colors.white,
            child: ListTile(
              leading: const Icon(Icons.delete_forever_rounded, color: AppColors.danger),
              title: const Text(
                'حذف الحساب والبيانات نهائياً',
                style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.bold),
              ),
              subtitle: const Text('حذف فوري لجميع البيانات السحابية والمحلية بدون استرجاع'),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
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

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

