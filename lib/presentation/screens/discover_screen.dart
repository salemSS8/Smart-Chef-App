import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../data/mock/recipes_data.dart';
import '../widgets/voice_input_sheet.dart';
import 'recipe_detail_screen.dart';

class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({super.key});

  @override
  ConsumerState<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends ConsumerState<DiscoverScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedPill = 'الكل';
  final Set<String> _followingChefs = {};

  final List<String> _trendingPills = [
    'الكل',
    '🍂 يخنات خريفية',
    '🍋 ليمون معتق',
    'باستا يدوية',
    'شواء على الحطب',
    'أقل من 30 دقيقة',
    'أعشاب برية',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleFollow(String chefName) {
    setState(() {
      if (_followingChefs.contains(chefName)) {
        _followingChefs.remove(chefName);
      } else {
        _followingChefs.add(chefName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Search & Filter Bar matching Stitch 727aaaedbf8f4980b5e45639372ae724
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceDark : AppColors.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(isDark ? 20 : 5),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search_rounded, color: AppColors.secondary, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              decoration: const InputDecoration(
                                hintText: 'ابحث في المكونات، الأقاليم، أو الشيف...',
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.mic_rounded, color: AppColors.primary, size: 20),
                            onPressed: () => VoiceInputSheet.show(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.tune_rounded, color: AppColors.primary, size: 20),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Horizontal Trending Pills
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _trendingPills.map((pill) {
                    final isSel = _selectedPill == pill;
                    return Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: ChoiceChip(
                        label: Text(pill),
                        selected: isSel,
                        selectedColor: AppColors.primary,
                        labelStyle: TextStyle(
                          color: isSel ? Colors.white : (isDark ? Colors.white70 : AppColors.secondary),
                          fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                          fontSize: 12,
                        ),
                        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceContainerLowest,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        onSelected: (_) => setState(() => _selectedPill = pill),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 20),

              // 2. Featured Editorial Terroir Story (Hero Anthology Card) matching Stitch
              Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(isDark ? 30 : 8),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image with Scrim & Badges
                    AspectRatio(
                      aspectRatio: 16 / 10,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CachedNetworkImage(
                            imageUrl: 'https://images.unsplash.com/photo-1551183053-bf91a1d81141?auto=format&fit=crop&w=800&q=80',
                            fit: BoxFit.cover,
                          ),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  AppColors.primary.withAlpha(220),
                                ],
                                stops: const [0.4, 1.0],
                              ),
                            ),
                          ),

                          // Top Badges
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(220),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(color: AppColors.tertiary, shape: BoxShape.circle),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'مجلد ١٢ • أقاليم مميزة',
                                    style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Positioned(
                            top: 12,
                            left: 12,
                            child: Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(200),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.bookmark_border_rounded, size: 18, color: AppColors.primary),
                            ),
                          ),

                          // Bottom Text Overlay
                          Positioned(
                            bottom: 12,
                            right: 16,
                            left: 16,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'بولونيا، إيطاليا',
                                  style: GoogleFonts.manrope(
                                    fontSize: 11,
                                    color: AppColors.primaryFixed,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'البساطة المقدسة لمطبخ إميليا رومانيا',
                                  style: GoogleFonts.newsreader(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    height: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Card Body
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'عجائن يدوية وأجبان بارميجيانو معتقة في كهوف خشبية ومراجل نحاسية تلخص روح بولونيا عبر قرون من الإتقان والهدوء.',
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Metadata Chips
                          Row(
                            children: [
                              const Icon(Icons.person_pin_rounded, size: 16, color: AppColors.primary),
                              const SizedBox(width: 4),
                              Text('الشيف ماركو بليني', style: GoogleFonts.manrope(fontSize: 11, color: AppColors.secondary)),
                              const SizedBox(width: 8),
                              const Text('•', style: TextStyle(color: Colors.grey)),
                              const SizedBox(width: 8),
                              const Icon(Icons.menu_book_rounded, size: 16, color: AppColors.primary),
                              const SizedBox(width: 4),
                              Text('٨ وصفات', style: GoogleFonts.manrope(fontSize: 11, color: AppColors.secondary)),
                            ],
                          ),

                          const SizedBox(height: 16),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                icon: const Text('قراءة المختارات', style: TextStyle(fontWeight: FontWeight.bold)),
                                label: const Icon(Icons.arrow_back_rounded, size: 16),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => RecipeDetailScreen(recipe: RecipesData.allRecipes.first)),
                                  );
                                },
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.schedule_rounded, size: 14, color: AppColors.secondary),
                                  const SizedBox(width: 4),
                                  Text('٧ دقائق قراءة', style: GoogleFonts.manrope(fontSize: 11, color: AppColors.secondary)),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // 3. Regional Terroirs Carousel matching Stitch
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'أقاليم الطهي الأصيلة 🌍',
                    style: GoogleFonts.newsreader(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('عرض الكل (١٨)'),
                  ),
                ],
              ),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildTerroirScrollCard(
                      title: 'شاميات الحطب والأعشاب',
                      subtitle: 'سماق بري وطحينة معصورة على الحجر',
                      badge: '٢٤ وصفة',
                      icon: Icons.local_fire_department_rounded,
                      imageUrl: 'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=500&q=80',
                      isDark: isDark,
                    ),
                    _buildTerroirScrollCard(
                      title: 'مطبخ الشمال والعرعر',
                      subtitle: 'أسماك الأنهار المدخنة وعصير التوت البري',
                      badge: '١٦ وصفة',
                      icon: Icons.eco_rounded,
                      imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=500&q=80',
                      isDark: isDark,
                    ),
                    _buildTerroirScrollCard(
                      title: 'كايسيكي كيوتو المتناغم',
                      subtitle: 'مرق الداشي وفطر الماتسوتاكي',
                      badge: '١٩ وصفة',
                      icon: Icons.water_drop_rounded,
                      imageUrl: 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?auto=format&fit=crop&w=500&q=80',
                      isDark: isDark,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // 4. Artisanal Techniques Masterclasses (فيديوهات التقنيات اليدوية)
              Text(
                'تقنيات الشيف اليدوية 👨‍🍳',
                style: GoogleFonts.newsreader(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'إرشادات بصرية قصيرة لإتقان أصعب تقنيات الطهي',
                style: GoogleFonts.manrope(fontSize: 12, color: isDark ? AppColors.textSecondaryDark : AppColors.secondary),
              ),

              const SizedBox(height: 12),

              _buildTechniqueCard(
                title: 'فن فرد عجينة السفوغليا يدوياً',
                subtitle: 'معادلة الترطيب واختبار المرونة والفرد الرقيق جداً',
                chef: 'الشيف ماركو بليني',
                rating: '4.9 ★ (1.2k)',
                duration: '12:40',
                imageUrl: 'https://images.unsplash.com/photo-1556910103-1c02745aae4d?auto=format&fit=crop&w=500&q=80',
                isDark: isDark,
              ),

              const SizedBox(height: 10),

              _buildTechniqueCard(
                title: 'الاستحلاب الحراري لصلصة الكاتشيو إي بيبي',
                subtitle: 'توازن ماء سلق الباستا مع الجبن لتجنب التكتل',
                chef: 'الشيف أنطونيو روسي',
                rating: '5.0 ★ (3.4k)',
                duration: '06:15',
                imageUrl: 'https://images.unsplash.com/photo-1621996346565-e3d5d62811b4?auto=format&fit=crop&w=500&q=80',
                isDark: isDark,
              ),

              const SizedBox(height: 28),

              // 5. Guild of Gastronomy / Voices to Follow (أصوات الطهي والشيفات)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'أصوات في عالم الطهي ⭐',
                    style: GoogleFonts.newsreader(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('استكشف الكل'),
                  ),
                ],
              ),

              _buildChefFollowRow(
                name: 'ماركو بليني',
                title: 'بولونيا، إيطاليا • خبير فرد السفوغليا اليدوي',
                imageUrl: 'https://images.unsplash.com/photo-1577219491135-ce391730fb2c?auto=format&fit=crop&w=200&q=80',
                isDark: isDark,
              ),

              const SizedBox(height: 8),

              _buildChefFollowRow(
                name: 'فريا ليندكفيست',
                title: 'ستوكهولم • باحثة تخمير وتعتيق نباتي',
                imageUrl: 'https://images.unsplash.com/photo-1583394293214-28ded15ee548?auto=format&fit=crop&w=200&q=80',
                isDark: isDark,
              ),

              const SizedBox(height: 8),

              _buildChefFollowRow(
                name: 'نادية خوري',
                title: 'بيروت • مأكولات التراث الشامي وتوابل الجبال',
                imageUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=200&q=80',
                isDark: isDark,
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTerroirScrollCard({
    required String title,
    required String subtitle,
    required String badge,
    required IconData icon,
    required String imageUrl,
    required bool isDark,
  }) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(left: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 120,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.cover),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(220),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      badge,
                      style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.newsreader(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.manrope(fontSize: 11, color: AppColors.secondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechniqueCard({
    required String title,
    required String subtitle,
    required String chef,
    required String rating,
    required String duration,
    required String imageUrl,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 80,
              height: 80,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.cover),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(220),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.play_arrow_rounded, color: AppColors.primary, size: 20),
                    ),
                  ),
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(160),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(duration, style: const TextStyle(color: Colors.white, fontSize: 9)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.newsreader(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.manrope(fontSize: 11, color: AppColors.secondary),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(chef, style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary)),
                    const SizedBox(width: 6),
                    Text(rating, style: GoogleFonts.manrope(fontSize: 11, color: AppColors.secondary)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChefFollowRow({
    required String name,
    required String title,
    required String imageUrl,
    required bool isDark,
  }) {
    final isFollowing = _followingChefs.contains(name);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundImage: NetworkImage(imageUrl),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.manrope(fontSize: 11, color: AppColors.secondary),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isFollowing ? AppColors.surfaceContainerHigh : AppColors.primary,
              foregroundColor: isFollowing ? AppColors.primary : Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 0,
            ),
            onPressed: () => _toggleFollow(name),
            child: Text(
              isFollowing ? '✓ تتابع' : '+ متابعة',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
