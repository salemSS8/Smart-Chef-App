import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _selectedCategory = 'all';
  final Set<String> _readNotifIds = {'notif_4', 'notif_5'};

  final List<Map<String, dynamic>> _notifications = [
    {
      'id': 'notif_1',
      'category': 'creator',
      'tag': 'اعتماد هيئة التحرير',
      'time': 'منذ ١٠ دقائق',
      'title': 'نُشرت وصفتك: سمك القاروص المتوسطي',
      'body': 'تمت مراجعة وصفتك "قاروص البحر الأبيض المشوي" واعتمادها من الشيف أنطوان! أصبحت متاحة الآن في دليل التذوق العالمي.',
      'icon': Icons.verified_rounded,
      'iconBg': AppColors.primaryFixed,
      'iconColor': AppColors.primary,
      'actionLabel': 'عرض الوصفة المنشورة',
      'hasAction': true,
    },
    {
      'id': 'notif_2',
      'category': 'creator',
      'tag': 'مطلوب إجراء',
      'time': 'منذ ٣ ساعات',
      'title': 'ملاحظة تدقيق: منقوشة الزعتر البلدي',
      'body': 'طلب الشيف المراجع توضيح درجة حرارة حجر الفرن في الخطوة ٣ لضمان سلامة الخبز الحجري المقرمش.',
      'quote': '«يرجى توضيح درجة حرارة الحجر لتفادي احتراق قاعدة الخبز.» — الشيف أنطوان',
      'icon': Icons.assignment_late_rounded,
      'iconBg': AppColors.secondaryContainer,
      'iconColor': AppColors.primary,
      'actionLabel': 'مراجعة وإعادة إرسال',
      'hasAction': true,
      'isWarning': true,
    },
    {
      'id': 'notif_3',
      'category': 'pantry',
      'tag': 'تنبيه المؤونة الطازجة',
      'time': 'أمس',
      'title': 'صلاحية تنتهي خلال ٤٨ ساعة',
      'body': 'الزعتر البري وليمون الماير يقتربان من ذروة النضج. نقترح طهي "قاروص الفرن" أو تجميدهما لحفظ الزيوت العطرية.',
      'chips': ['زعتر بري (١٢ جم متبقٍ)', 'ليمون ماير (حبتان)'],
      'icon': Icons.kitchen_rounded,
      'iconBg': AppColors.surfaceContainerHigh,
      'iconColor': AppColors.textPrimaryLight,
      'hasAction': false,
    },
    {
      'id': 'notif_4',
      'category': 'community',
      'tag': 'مجتمع التذوق',
      'time': 'منذ يومين',
      'title': 'الشيف إيلينا و١٤ آخرون حفظوا وصفتك',
      'body': 'تمت إضافة ملاحظتك حول تفتيح نكهة الكمون في "شكشوكة المقلاة الحديدية" إلى قوائم التفضيل.',
      'icon': Icons.bookmark_added_rounded,
      'iconBg': AppColors.primaryFixed,
      'iconColor': AppColors.primary,
      'hasAction': false,
    },
    {
      'id': 'notif_5',
      'category': 'creator',
      'tag': 'الجريدة التحريرية',
      'time': 'منذ ٣ أيام',
      'title': 'المجلد الثالث عشر من الأنثولوجيا متاح',
      'body': 'مختارات جديدة: "أسرار مطابخ سواحل اليونان العتيقة". تقنيات معتمدة لطهي المأكولات البحرية بالأعشاب البرية.',
      'icon': Icons.wine_bar_rounded,
      'iconBg': AppColors.tertiaryContainer,
      'iconColor': AppColors.onTertiaryContainer,
      'actionLabel': 'قراءة العدد',
      'hasAction': true,
    },
  ];

  void _markAllRead() {
    setState(() {
      for (final n in _notifications) {
        _readNotifIds.add(n['id'] as String);
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.done_all_rounded, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text('تم تحديد جميع الإشعارات كمقروءة'),
          ],
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final unreadCount = _notifications.where((n) => !_readNotifIds.contains(n['id'])).length;

    final filteredList = _notifications.where((n) {
      if (_selectedCategory == 'all') return true;
      return n['category'] == _selectedCategory;
    }).toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: (isDark ? AppColors.darkBackground : AppColors.backgroundLight).withValues(alpha: 0.95),
        title: Text(
          'الإشعارات والنشاط',
          style: GoogleFonts.cairo(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: isDark ? AppColors.textPrimaryDark : AppColors.primary,
          ),
        ),
        actions: [
          if (unreadCount > 0)
            TextButton.icon(
              onPressed: _markAllRead,
              icon: const Icon(Icons.done_all_rounded, size: 16),
              label: const Text('قراءة الكل', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            ),
        ],
      ),
      body: Column(
        children: [
          // Subheader Status Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'صندوق الوارد',
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.secondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: unreadCount > 0
                            ? AppColors.primaryFixed
                            : (isDark ? AppColors.surfaceDark : AppColors.surfaceContainer),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        unreadCount > 0 ? '$unreadCount غير مقروء' : 'مكتمل ومقروء',
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: unreadCount > 0 ? AppColors.primary : AppColors.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Categories Bar
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              children: [
                _buildFilterChip('all', 'الكل'),
                const SizedBox(width: 8),
                _buildFilterChip('creator', 'اعتمادات الطهاة'),
                const SizedBox(width: 8),
                _buildFilterChip('pantry', 'المؤونة والطهي'),
                const SizedBox(width: 8),
                _buildFilterChip('community', 'المجتمع'),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Notification Cards
          Expanded(
            child: filteredList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.notifications_paused_outlined, size: 48, color: AppColors.secondary.withValues(alpha: 0.5)),
                        const SizedBox(height: 12),
                        Text(
                          'لا توجد إشعارات في هذا التصنيف',
                          style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final item = filteredList[index];
                      final isUnread = !_readNotifIds.contains(item['id']);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        color: isDark ? AppColors.surfaceDark : Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: isUnread
                                ? AppColors.primary.withValues(alpha: 0.3)
                                : (isDark ? AppColors.borderDark : AppColors.borderLight),
                            width: isUnread ? 1.5 : 1,
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _readNotifIds.add(item['id'] as String);
                            });
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: item['iconBg'] as Color,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        item['icon'] as IconData,
                                        color: item['iconColor'] as Color,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: (item['isWarning'] == true)
                                                      ? AppColors.dangerLight
                                                      : (isDark ? AppColors.surfaceContainerHigh : AppColors.surfaceContainerLow),
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  item['tag'] as String,
                                                  style: GoogleFonts.cairo(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color: (item['isWarning'] == true)
                                                        ? AppColors.danger
                                                        : AppColors.primary,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                item['time'] as String,
                                                style: GoogleFonts.manrope(
                                                  fontSize: 11,
                                                  color: isDark ? AppColors.textSecondaryDark : AppColors.secondary,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            item['title'] as String,
                                            style: GoogleFonts.cairo(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (isUnread)
                                      Container(
                                        width: 8,
                                        height: 8,
                                        margin: const EdgeInsets.only(top: 4),
                                        decoration: const BoxDecoration(
                                          color: AppColors.primary,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.only(right: 52),
                                  child: Text(
                                    item['body'] as String,
                                    style: GoogleFonts.cairo(
                                      fontSize: 12,
                                      height: 1.5,
                                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                    ),
                                  ),
                                ),
                                if (item['quote'] != null) ...[
                                  const SizedBox(height: 8),
                                  Container(
                                    margin: const EdgeInsets.only(right: 52),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: isDark ? AppColors.darkBackground : AppColors.surfaceContainerLow,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border(right: BorderSide(color: AppColors.primary, width: 3)),
                                    ),
                                    child: Text(
                                      item['quote'] as String,
                                      style: GoogleFonts.cairo(
                                        fontSize: 11,
                                        fontStyle: FontStyle.italic,
                                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                      ),
                                    ),
                                  ),
                                ],
                                if (item['chips'] != null) ...[
                                  const SizedBox(height: 8),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 52),
                                    child: Wrap(
                                      spacing: 8,
                                      runSpacing: 4,
                                      children: (item['chips'] as List<String>).map((c) {
                                        return Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: isDark ? AppColors.darkBackground : AppColors.surfaceContainerLow,
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(Icons.eco_rounded, size: 12, color: AppColors.primary),
                                              const SizedBox(width: 4),
                                              Text(c, style: GoogleFonts.cairo(fontSize: 11, color: AppColors.primary)),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                                if (item['hasAction'] == true) ...[
                                  const SizedBox(height: 12),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 52),
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: (item['isWarning'] == true)
                                            ? AppColors.primary
                                            : AppColors.primary,
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      ),
                                      icon: const Icon(Icons.arrow_back_rounded, size: 14),
                                      label: Text(
                                        item['actionLabel'] as String,
                                        style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.bold),
                                      ),
                                      onPressed: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('الانتقال إلى: ${item['actionLabel']}'),
                                            behavior: SnackBarBehavior.floating,
                                            duration: const Duration(seconds: 1),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String key, String label) {
    final isSelected = _selectedCategory == key;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () => setState(() => _selectedCategory = key),
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : (isDark ? AppColors.surfaceDark : AppColors.surfaceContainerLow),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.cairo(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected
                ? Colors.white
                : (isDark ? AppColors.textSecondaryDark : AppColors.textPrimaryLight),
          ),
        ),
      ),
    );
  }
}
