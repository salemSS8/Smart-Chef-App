import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../providers/pantry_provider.dart';

class VoiceInputSheet extends ConsumerStatefulWidget {
  const VoiceInputSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const VoiceInputSheet(),
    );
  }

  @override
  ConsumerState<VoiceInputSheet> createState() => _VoiceInputSheetState();
}

class _VoiceInputSheetState extends ConsumerState<VoiceInputSheet> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  bool _isListening = true;
  final String _liveSpokenText = '«عندي في المطبخ بيض وبصل وطماطم وشوية دجاج وبطاطس»';

  final List<Map<String, dynamic>> _extractedIngredients = [
    {'id': 'ing_eggs', 'name': 'بيض'},
    {'id': 'ing_onion', 'name': 'بصل'},
    {'id': 'ing_tomato', 'name': 'طماطم'},
    {'id': 'ing_chicken_breast', 'name': 'دجاج'},
    {'id': 'ing_potato', 'name': 'بطاطس'},
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    // Simulate speech finish after 3 seconds
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isListening = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _addExtractedIngredients() {
    final ids = _extractedIngredients.map((e) => e['id'] as String).toList();
    ref.read(pantryProvider.notifier).addMultiple(ids);
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تمت إضافة ${ids.length} مكونات صوتياً إلى مطبخك بنجاح! 🎙️'),
        backgroundColor: AppColors.secondary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.only(
        top: 16,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag bar
            Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const SizedBox(height: 20),

            // Animated Mic Button
            GestureDetector(
              onTap: () {
                setState(() {
                  _isListening = !_isListening;
                });
              },
              child: AnimatedBuilder(
                animation: _animController,
                builder: (context, child) {
                  return Container(
                    padding: EdgeInsets.all(_isListening ? 20 + (_animController.value * 8) : 20),
                    decoration: BoxDecoration(
                      color: _isListening
                          ? AppColors.primary.withAlpha(40)
                          : Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: _isListening ? AppColors.primary : Colors.grey.shade400,
                        shape: BoxShape.circle,
                        boxShadow: [
                          if (_isListening)
                            BoxShadow(
                              color: AppColors.primary.withAlpha(80),
                              blurRadius: 15,
                              offset: const Offset(0, 4),
                            ),
                        ],
                      ),
                      child: const Icon(Icons.mic_rounded, size: 36, color: Colors.white),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            Text(
              _isListening ? 'نستمع إليك الآن... تكلّم بطبيعتك' : 'تم استخراج المكونات بنجاح!',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _isListening ? AppColors.primary : AppColors.secondary,
              ),
            ),

            const SizedBox(height: 12),

            // Spoken text bubble
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
              child: Text(
                _liveSpokenText,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, height: 1.4, fontStyle: FontStyle.italic),
              ),
            ),

            const SizedBox(height: 20),

            // Extracted Ingredients
            const Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                'المكونات المستخرجة (المس للحذف أو التعديل):',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),

            const SizedBox(height: 10),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _extractedIngredients.map((item) {
                return Chip(
                  avatar: const Icon(Icons.check_circle_rounded, color: AppColors.secondary, size: 16),
                  label: Text(item['name']),
                  deleteIcon: const Icon(Icons.close_rounded, size: 16),
                  onDeleted: () {
                    setState(() {
                      _extractedIngredients.remove(item);
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _extractedIngredients.isEmpty ? null : _addExtractedIngredients,
              child: Text('أضف ${_extractedIngredients.length} مكونات إلى مطبخي 🛒'),
            ),
          ],
        ),
      ),
    );
  }
}
