import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/app_update_service.dart';
import '../../core/services/remote_config_service.dart';
import '../../core/theme/app_colors.dart';
import '../providers/matching_provider.dart';
import '../providers/shopping_provider.dart';
import 'today_screen.dart';
import 'pantry_screen.dart';
import 'discover_screen.dart';
import 'shopping_screen.dart';
import 'settings_screen.dart';

class MainNavigationScreen extends ConsumerStatefulWidget {
  final int initialIndex;

  const MainNavigationScreen({super.key, this.initialIndex = 0});

  @override
  ConsumerState<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen> {
  late int _currentIndex;
  bool _dismissedAnnouncement = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        AppUpdateService.checkForUpdatesOnStartup(context);
      }
    });
  }

  @override
  void didUpdateWidget(covariant MainNavigationScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialIndex != widget.initialIndex) {
      _currentIndex = widget.initialIndex;
    }
  }

  void _goToTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final matching = ref.watch(matchingProvider);
    final shoppingList = ref.watch(shoppingProvider);
    final pendingShoppingCount = shoppingList.where((i) => !i.isCompleted).length;

    final screens = [
      TodayScreen(onNavigateToPantry: () => _goToTab(1)),
      PantryScreen(onViewRecipes: () => _goToTab(0)),
      const DiscoverScreen(),
      const ShoppingScreen(),
      const SettingsScreen(),
    ];

    final remoteConfig = RemoteConfigService.current;
    if (remoteConfig.maintenanceMode) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.engineering_rounded,
                    size: 56,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'نجهز لك وصفات أشهى! 👨‍🍳',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  remoteConfig.announcementMessage.isNotEmpty
                      ? remoteConfig.announcementMessage
                      : 'التطبيق في وضع الصيانة السريعة لتحديث قاعدة الوصفات العالمية. سنعود خلال دقائق!',
                  style: const TextStyle(fontSize: 14, height: 1.5),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          if (remoteConfig.isAnnouncementActive &&
              remoteConfig.announcementMessage.trim().isNotEmpty &&
              !_dismissedAnnouncement)
            SafeArea(
              bottom: false,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.campaign_rounded, color: Colors.white, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        remoteConfig.announcementMessage,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.white, size: 18),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => setState(() => _dismissedAnnouncement = true),
                    ),
                  ],
                ),
              ),
            ),
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: screens,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _goToTab,
        items: [
          BottomNavigationBarItem(
            icon: Badge(
              isLabelVisible: matching.totalReadyCount > 0,
              label: Text('${matching.totalReadyCount}'),
              backgroundColor: AppColors.accentGold,
              child: const Icon(Icons.restaurant_rounded),
            ),
            label: 'اليوم',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.kitchen_rounded),
            label: 'مطبخي',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.travel_explore_rounded),
            label: 'اكتشف',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              isLabelVisible: pendingShoppingCount > 0,
              label: Text('$pendingShoppingCount'),
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.shopping_cart_outlined),
            ),
            activeIcon: const Icon(Icons.shopping_cart_rounded),
            label: 'التسوق',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            activeIcon: Icon(Icons.person_rounded),
            label: 'أنا',
          ),
        ],
      ),
    );
  }
}
