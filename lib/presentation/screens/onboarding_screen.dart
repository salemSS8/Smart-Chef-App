import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/repositories/pantry_repository.dart';
import 'main_navigation_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Preferences state
  String _selectedLanguage = 'ar'; // 'ar' or 'en'
  final Set<String> _selectedCuisines = {'gulf', 'levant', 'egypt'};
  String _selectedUnit = 'cups';
  int _familyMembers = 4;
  final Set<String> _allergies = {};
  bool _enableStaples = true;

  void _finishOnboarding() async {
    final repo = PantryRepository();
    await repo.setOnboardingCompleted(true);
    await repo.setAppLanguage(_selectedLanguage);
    await repo.setPreferredCuisines(_selectedCuisines.toList());

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
    );
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAr = _selectedLanguage == 'ar';

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top Header: Dots indicator & Skip
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _finishOnboarding,
                    child: Text(
                      isAr ? 'تخطي' : 'Skip',
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColors.textSecondaryLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Row(
                    children: List.generate(3, (index) {
                      final isActive = index == _currentPage;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        height: 6,
                        width: isActive ? 24 : 6,
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.primary : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(width: 48), // Balance spacing
                ],
              ),
            ),

            // Page View
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  _buildIntroSlide(isAr),
                  _buildCuisinesAndUnitsSlide(isAr),
                  _buildAllergiesAndFamilySlide(isAr),
                ],
              ),
            ),

            // Bottom Button
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: _nextPage,
                    child: Text(
                      _currentPage == 2
                          ? (isAr ? 'ابدأ الآن 🚀' : 'Get Started 🚀')
                          : (isAr ? 'التالي' : 'Next'),
                    ),
                  ),
                  if (_currentPage == 0) ...[
                    const SizedBox(height: 12),
                    Text(
                      isAr
                          ? 'بدون تسجيل — ابدأ مباشرة، وسجّل لاحقًا لحفظ بياناتك'
                          : 'No login required — Start immediately, save anytime',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Slide 1: Welcome & Language Selector
  Widget _buildIntroSlide(bool isAr) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          // App Logo
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withAlpha(45),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(26),
              child: Image.asset(
                'assets/image/icon-1024.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Language Selector Pills
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () => setState(() => _selectedLanguage = 'ar'),
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    decoration: BoxDecoration(
                      color: _selectedLanguage == 'ar' ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: _selectedLanguage == 'ar'
                          ? [BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 4)]
                          : null,
                    ),
                    child: const Text('🇸🇦 العربية', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                ),
                InkWell(
                  onTap: () => setState(() => _selectedLanguage = 'en'),
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    decoration: BoxDecoration(
                      color: _selectedLanguage == 'en' ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: _selectedLanguage == 'en'
                          ? [BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 4)]
                          : null,
                    ),
                    child: const Text('🇬🇧 English', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // Headlines
          Text(
            isAr ? 'منصة الطبخ العالمية الذكية' : 'Smart Global Cook Platform',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isAr ? 'اطبخ بذكاء من مكونات ثلاجتك' : 'Cook smarter from your pantry',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 14),

          Text(
            isAr
                ? 'قل لنا ما في مطبخك، ونقترح عليك أشهى الأطباق من مختلف مطابخ العالم بنكهتك المفضلة.'
                : 'Discover what you can cook right now with your available ingredients across world cuisines.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
              color: AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  // Slide 2: المطابخ المفضلة عالمياً والوحدات
  Widget _buildCuisinesAndUnitsSlide(bool isAr) {
    final globalCuisines = [
      {'id': 'gulf', 'flag': '🇸🇦', 'title': isAr ? 'الخليجي واليمني' : 'Saudi & Yemeni', 'desc': isAr ? 'كبسة، مندي، حنيذ، مضغوط' : 'Kabsa, Mandi, Haneeth'},
      {'id': 'levant', 'flag': '🇱🇧', 'title': isAr ? 'الشامي' : 'Levantine', 'desc': isAr ? 'بندورة، فتوش، مجدرة، كبة' : 'Fattoush, Kibbeh, Hummus'},
      {'id': 'egypt', 'flag': '🇪🇬', 'title': isAr ? 'المصري' : 'Egyptian', 'desc': isAr ? 'كشري، طعمية، ملوخية، حواوشي' : 'Koshari, Molokhia, Hawawshi'},
      {'id': 'maghreb', 'flag': '🇲🇦', 'title': isAr ? 'المغاربي' : 'North African', 'desc': isAr ? 'كسكس، طاجين، حريرة' : 'Couscous, Tajine, Harira'},
      {'id': 'italian', 'flag': '🇮🇹', 'title': isAr ? 'الإيطالي' : 'Italian', 'desc': isAr ? 'باستا، بيتزا، ريزوتو' : 'Pasta, Pizza, Risotto'},
      {'id': 'asian', 'flag': '🍜', 'title': isAr ? 'الآسيوي' : 'Asian', 'desc': isAr ? 'نودلز، كاري، أرز مقلي' : 'Noodles, Curry, Fried Rice'},
      {'id': 'mexican', 'flag': '🌮', 'title': isAr ? 'اللاتيني والمكسيكي' : 'Mexican & Latin', 'desc': isAr ? 'تاكو، بوريتو، فاهيتا' : 'Tacos, Burritos, Fajitas'},
      {'id': 'healthy', 'flag': '🥗', 'title': isAr ? 'العالمي والصحي' : 'Global Healthy', 'desc': isAr ? 'سلطات، سموزي، بروتين' : 'Salads, Bowls, High Protein'},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            isAr ? 'اختر مطابخك المفضلة 🌍' : 'Select Preferred Cuisines 🌍',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            isAr
                ? 'حدد المطابخ التي تفضل رؤية وصفاتها أولاً (يمكن اختيار أكثر من مطبخ):'
                : 'Choose the cuisines you love most (multi-select supported):',
            style: const TextStyle(fontSize: 13, color: AppColors.textSecondaryLight),
          ),
          const SizedBox(height: 14),

          ...globalCuisines.map((c) {
            final isSelected = _selectedCuisines.contains(c['id']);
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryLight : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.borderLight,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: ListTile(
                dense: true,
                leading: Text(c['flag']!, style: const TextStyle(fontSize: 24)),
                title: Text(c['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: Text(c['desc']!, style: const TextStyle(fontSize: 11)),
                trailing: Icon(
                  isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                  color: isSelected ? AppColors.primary : Colors.grey.shade400,
                  size: 20,
                ),
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      if (_selectedCuisines.length > 1) {
                        _selectedCuisines.remove(c['id']);
                      }
                    } else {
                      _selectedCuisines.add(c['id']!);
                    }
                  });
                },
              ),
            );
          }),

          const SizedBox(height: 14),
          Text(
            isAr ? 'نظام قياس المقادير ⚖️' : 'Measurement System ⚖️',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildChoiceCard(
                  title: isAr ? 'أكواب وملاعق 🥣' : 'Cups & Spoons 🥣',
                  subtitle: isAr ? 'الأسلوب المنزلي السهل' : 'Standard Kitchen',
                  isSelected: _selectedUnit == 'cups',
                  onTap: () => setState(() => _selectedUnit = 'cups'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildChoiceCard(
                  title: isAr ? 'غرامات وملم ⚖️' : 'Metric (Grams) ⚖️',
                  subtitle: isAr ? 'ميزان دقيق' : 'Precise Scale',
                  isSelected: _selectedUnit == 'grams',
                  onTap: () => setState(() => _selectedUnit = 'grams'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Slide 3: الحساسية والأسرة
  Widget _buildAllergiesAndFamilySlide(bool isAr) {
    final allergyList = [
      {'id': 'nuts', 'label': isAr ? 'بدون مكسرات 🥜' : 'Nut Free 🥜'},
      {'id': 'gluten', 'label': isAr ? 'بدون جلوتين 🌾' : 'Gluten Free 🌾'},
      {'id': 'dairy', 'label': isAr ? 'بدون حليب/ألبان 🥛' : 'Dairy Free 🥛'},
      {'id': 'seafood', 'label': isAr ? 'بدون مأكولات بحرية 🦐' : 'Seafood Free 🦐'},
      {'id': 'vegan', 'label': isAr ? 'نظام نباتي 🌱' : 'Vegan 🌱'},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            isAr ? 'السلامة الغذائية وتفضيلات الأسرة 👨‍👩‍👧‍👦' : 'Food Safety & Household 👨‍👩‍👧‍👦',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            isAr
                ? 'سنستبعد تلقائياً أي وصفات تحتوي على مسببات حساسية لك أو لعائلتك.'
                : 'We will filter out any recipes with your specified dietary restrictions.',
            style: const TextStyle(fontSize: 14, color: AppColors.textSecondaryLight),
          ),
          const SizedBox(height: 20),

          // Family members
          Text(isAr ? 'عدد أفراد الأسرة الافتراضي:' : 'Default Servings / Family Size:', style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [1, 2, 4, 6].map((count) {
              final isSel = _familyMembers == count;
              return InkWell(
                onTap: () => setState(() => _familyMembers = count),
                child: Container(
                  width: 65,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSel ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: isSel ? AppColors.primary : AppColors.borderLight),
                  ),
                  child: Center(
                    child: Text(
                      isAr ? '$count ${count == 1 ? 'فرد' : 'أفراد'}' : '$count Ppl',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isSel ? Colors.white : AppColors.textPrimaryLight,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // Allergies & Restrictions
          Text(isAr ? 'مسببات الحساسية والحميات:' : 'Allergens & Dietary Constraints:', style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: allergyList.map((item) {
              final isSel = _allergies.contains(item['id']);
              return FilterChip(
                label: Text(item['label']!),
                selected: isSel,
                selectedColor: AppColors.dangerLight,
                checkmarkColor: AppColors.danger,
                labelStyle: TextStyle(
                  color: isSel ? AppColors.danger : AppColors.textPrimaryLight,
                  fontWeight: FontWeight.w600,
                ),
                onSelected: (val) {
                  setState(() {
                    if (val) {
                      _allergies.add(item['id']!);
                    } else {
                      _allergies.remove(item['id']);
                    }
                  });
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // Staples Opt-in card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _enableStaples ? AppColors.secondaryLight : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _enableStaples ? AppColors.secondary : AppColors.borderLight,
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle_outline_rounded, color: AppColors.secondary, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isAr ? 'الأساسيات مفعلة تلقائياً' : 'Pantry Staples Assumed',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isAr
                            ? 'نفترض وجود الملح والماء والزيت في مطبخك دون سؤالك عنها.'
                            : 'Salt, water, and oil are assumed always available.',
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight),
                      ),
                    ],
                  ),
                ),
                Switch.adaptive(
                  value: _enableStaples,
                  activeTrackColor: AppColors.secondary,
                  onChanged: (val) => setState(() => _enableStaples = val),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChoiceCard({
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderLight,
            width: isSelected ? 1.8 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
          ],
        ),
      ),
    );
  }
}
