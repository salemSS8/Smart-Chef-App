import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../core/theme/app_colors.dart';
import '../../data/mock/ingredients_data.dart';
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
  final stt.SpeechToText _speech = stt.SpeechToText();

  bool _isSpeechInitialized = false;
  bool _isListening = false;
  String _liveSpokenText = '';
  String? _statusMessage;
  String _selectedLocaleId = 'ar_SA';

  final List<Map<String, dynamic>> _extractedIngredients = [];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _initAndStartSpeech();
  }

  Future<void> _initAndStartSpeech() async {
    setState(() {
      _statusMessage = 'جاري تهيئة الميكروفون...';
    });

    try {
      final available = await _speech.initialize(
        onStatus: (status) {
          if (!mounted) return;
          if (status == 'listening') {
            setState(() {
              _isListening = true;
              _statusMessage = 'نستمع إليك الآن... تكلّم بطبيعتك 🎙️';
            });
          } else if (status == 'notListening' || status == 'done') {
            setState(() {
              _isListening = false;
              if (_extractedIngredients.isNotEmpty) {
                _statusMessage = 'تم استخراج المكونات بنجاح!';
              } else if (_liveSpokenText.isNotEmpty) {
                _statusMessage = 'توقف الاستماع. لم نتعرف على مكونات واضحة، حاول مرة أخرى.';
              } else {
                _statusMessage = 'انقر على الميكروفون لبدء التحدث';
              }
            });
          }
        },
        onError: (err) {
          if (!mounted) return;
          setState(() {
            _isListening = false;
            _statusMessage = 'تنبيه: ${err.errorMsg} (انقر لإعادة المحاولة)';
          });
        },
      );

      if (available) {
        _isSpeechInitialized = true;
        final locales = await _speech.locales();
        final arabicLocale = locales.firstWhere(
          (loc) => loc.localeId.toLowerCase().startsWith('ar'),
          orElse: () => locales.isNotEmpty ? locales.first : stt.LocaleName('ar_SA', 'Arabic'),
        );
        _selectedLocaleId = arabicLocale.localeId;
        _startListening();
      } else {
        setState(() {
          _statusMessage = 'تعذر تشغيل الميكروفون أو لم يتم منح الإذن.';
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'خطأ في تشغيل ميكروفون الجهاز: $e';
      });
    }
  }

  Future<void> _startListening() async {
    if (!_speech.isAvailable) return;

    setState(() {
      _isListening = true;
      _statusMessage = 'نستمع إليك الآن... قل مثلاً: عندي طماطم وبصل وبيض';
    });

    await _speech.listen(
      onResult: (SpeechRecognitionResult result) {
        if (!mounted) return;
        setState(() {
          _liveSpokenText = result.recognizedWords;
        });
        _extractIngredientsFromText(result.recognizedWords);
      },
      listenOptions: stt.SpeechListenOptions(
        localeId: _selectedLocaleId,
        listenFor: const Duration(seconds: 40),
        pauseFor: const Duration(seconds: 4),
        partialResults: true,
        cancelOnError: false,
        listenMode: stt.ListenMode.dictation,
      ),
    );
  }

  Future<void> _stopListening() async {
    await _speech.stop();
    if (mounted) {
      setState(() {
        _isListening = false;
      });
    }
  }

  void _extractIngredientsFromText(String text) {
    if (text.trim().isEmpty) return;
    final lower = text.toLowerCase();

    final found = <Map<String, dynamic>>[];
    final matchedIds = <String>{};

    // 1. البحث في قاعدة بيانات المكونات المعرفة مسبقاً
    for (final ing in IngredientsData.allIngredients) {
      final nameMatches = lower.contains(ing.name.toLowerCase());
      final synonymMatches = ing.synonyms.any((s) => lower.contains(s.toLowerCase()));

      if ((nameMatches || synonymMatches) && !matchedIds.contains(ing.id)) {
        matchedIds.add(ing.id);
        found.add({
          'id': ing.id,
          'name': ing.name,
          'emoji': ing.emoji,
        });
      }
    }

    // 2. إذا لم نجد في القاموس ولكن المستخدم ذكر كلمات مفصولة بـ (و)
    if (found.isEmpty && text.contains(' ')) {
      final cleanText = text
          .replaceAll(RegExp(r'(عندي|في|المطبخ|شوية|كيلو|حبة|حبات|من|مع|اليوم|أبغى|اريد)'), '')
          .trim();
      final words = cleanText.split(RegExp(r'[\s،,و]+')).where((w) => w.trim().length > 1);

      for (final w in words) {
        final wTrim = w.trim();
        if (wTrim.isNotEmpty && !matchedIds.contains(wTrim)) {
          matchedIds.add(wTrim);
          found.add({
            'id': 'ing_voice_${wTrim.hashCode.abs()}',
            'name': wTrim,
            'emoji': '🥗',
          });
        }
      }
    }

    if (found.isNotEmpty) {
      setState(() {
        _extractedIngredients.clear();
        _extractedIngredients.addAll(found);
      });
    }
  }

  @override
  void dispose() {
    _speech.stop();
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
                if (_isListening) {
                  _stopListening();
                } else {
                  if (_isSpeechInitialized) {
                    _startListening();
                  } else {
                    _initAndStartSpeech();
                  }
                }
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
                      child: Icon(
                        _isListening ? Icons.mic_rounded : Icons.mic_none_rounded,
                        size: 36,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            Text(
              _statusMessage ?? (_isListening ? 'نستمع إليك الآن... تكلّم بطبيعتك' : 'انقر على الميكروفون للتحدث'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
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
                _liveSpokenText.isEmpty
                    ? '«تحدث بأي مكونات موجودة لديك، وسيتعرف عليها التطبيق مباشرة...»'
                    : '«$_liveSpokenText»',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: _liveSpokenText.isEmpty ? Colors.grey : (isDark ? Colors.white : Colors.black87),
                  fontStyle: _liveSpokenText.isEmpty ? FontStyle.italic : FontStyle.normal,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Extracted Ingredients
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'المكونات المكتشفة بالصوت:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                if (_extractedIngredients.isNotEmpty)
                  Text(
                    '${_extractedIngredients.length} مكونات',
                    style: const TextStyle(fontSize: 12, color: AppColors.secondary, fontWeight: FontWeight.bold),
                  ),
              ],
            ),

            const SizedBox(height: 10),

            if (_extractedIngredients.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'لم يتم اكتشاف مكونات بعد. تحدث بأسماء الأطعمة للبدء.',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                ),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _extractedIngredients.map((item) {
                  return Chip(
                    avatar: Text(item['emoji'] ?? '🥕', style: const TextStyle(fontSize: 14)),
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
