import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../core/services/voice_command_service.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/models/recipe.dart';
import 'cook_completed_screen.dart';

/// شاشة وضع الطهي المباشر التفاعلي على الموقد (Guided Cooking Mode)
/// مطابقة بنسبة 100% لهوية Smart Cook Editorial System (Stitch MCP - projects/17025429917112534856)
/// تتضمن شاشات:
/// - Smart Cook — Guided Cooking Mode (c978e399fdca4d2983b39c43d069aef9)
/// - Smart Cook — Guided Cooking Step Mode (0f54c01de1924e638c2292e5de7e81bd)
class CookModeScreen extends StatefulWidget {
  final Recipe recipe;

  const CookModeScreen({super.key, required this.recipe});

  @override
  State<CookModeScreen> createState() => _CookModeScreenState();
}

class _CookModeScreenState extends State<CookModeScreen> {
  int _currentStepIndex = 0;

  // حالة المؤقت التفاعلي
  Timer? _countdownTimer;
  int _remainingSeconds = 0;
  int _totalStepSeconds = 180;
  bool _isTimerRunning = false;

  // خدمة الأوامر الصوتية بدون لمس للمطبخ
  final VoiceCommandService _voiceService = VoiceCommandService();
  bool _isVoiceActive = false;
  String _lastVoiceText = '';
  String? _voiceFeedbackMessage;
  Timer? _voiceFeedbackTimer;

  // تتبع المكونات التي تم وضعها في المقلاة (Mise en Place)
  final Set<String> _checkedIngredients = {};

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // إبقاء الشاشة مضاءة طوال جلسة الطهي لمنع إغلاق الهاتف أثناء انشغال اليدين
    WakelockPlus.enable();
    _initTimerForStep(_currentStepIndex);
    _initVoiceAssistant();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _voiceFeedbackTimer?.cancel();
    _voiceService.stopListening();
    _scrollController.dispose();
    // إعادة ضبط سلوك إغلاق الشاشة الطبيعي عند مغادرة وضع الطهي
    WakelockPlus.disable();
    super.dispose();
  }

  Future<void> _initVoiceAssistant() async {
    final ok = await _voiceService.initialize(
      onStatus: (status) {
        if (!mounted) return;
        setState(() {
          _isVoiceActive = _voiceService.isListening;
        });
      },
    );

    if (ok && mounted) {
      _startVoiceListening();
    }
  }

  Future<void> _startVoiceListening() async {
    try {
      await _voiceService.startListening(
        onPartialResult: (text) {
          if (!mounted) return;
          setState(() {
            _lastVoiceText = text;
          });
        },
        onCommandDetected: (cmd) {
          if (!mounted) return;
          _handleVoiceCommand(cmd);
        },
      );
      if (mounted) {
        setState(() => _isVoiceActive = true);
      }
    } catch (e) {
      debugPrint('Voice start error: $e');
    }
  }

  Future<void> _stopVoiceListening() async {
    await _voiceService.stopListening();
    if (mounted) {
      setState(() => _isVoiceActive = false);
    }
  }

  void _showVoiceFeedback(String msg) {
    _voiceFeedbackTimer?.cancel();
    if (mounted) {
      setState(() => _voiceFeedbackMessage = msg);
      _voiceFeedbackTimer = Timer(const Duration(seconds: 3), () {
        if (mounted) setState(() => _voiceFeedbackMessage = null);
      });
    }
  }

  void _handleVoiceCommand(VoiceCommand cmd) {
    HapticFeedback.mediumImpact();
    switch (cmd.type) {
      case VoiceCommandType.nextStep:
        _showVoiceFeedback('الانتقال للخطوة التالية ⏩');
        _nextStep();
        break;
      case VoiceCommandType.prevStep:
        _showVoiceFeedback('العودة للخطوة السابقة ⏪');
        _prevStep();
        break;
      case VoiceCommandType.toggleTimer:
        _showVoiceFeedback(_isTimerRunning ? 'إيقاف المؤقت ⏸️' : 'تشغيل المؤقت ⏱️');
        _toggleTimer();
        break;
      case VoiceCommandType.startTimer:
        if (cmd.timerMinutes != null && cmd.timerMinutes! > 0) {
          _showVoiceFeedback('تشغيل مؤقت ${cmd.timerMinutes} دقائق ⏱️');
          _startTimerWithSeconds(cmd.timerMinutes! * 60);
        } else {
          _showVoiceFeedback('تشغيل المؤقت ⏱️');
          if (!_isTimerRunning) _toggleTimer();
        }
        break;
      case VoiceCommandType.pauseTimer:
        _showVoiceFeedback('إيقاف المؤقت مؤقتاً ⏸️');
        if (_isTimerRunning) _toggleTimer();
        break;
      case VoiceCommandType.showIngredients:
        _showVoiceFeedback('عرض مقادير الوصفة 📋');
        _showIngredientsSheet();
        break;
      case VoiceCommandType.repeatStep:
        _showVoiceFeedback('تكرار الخطوة الحالية 🔁');
        break;
      case VoiceCommandType.unknown:
        break;
    }
  }

  void _initTimerForStep(int index) {
    _countdownTimer?.cancel();
    _isTimerRunning = false;
    final step = widget.recipe.steps[index];
    final defaultSecs = step.timerSeconds ?? 180; // افتراضي 3 دقائق إذا لم تحدد الخطوة
    setState(() {
      _remainingSeconds = defaultSecs;
      _totalStepSeconds = defaultSecs;
    });
  }

  void _startTimerWithSeconds(int seconds) {
    _countdownTimer?.cancel();
    setState(() {
      _remainingSeconds = seconds;
      _totalStepSeconds = seconds > 0 ? seconds : 180;
      _isTimerRunning = true;
    });
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 1) {
        if (mounted) {
          setState(() {
            _remainingSeconds--;
          });
        }
      } else {
        timer.cancel();
        if (mounted) {
          setState(() {
            _remainingSeconds = 0;
            _isTimerRunning = false;
          });
          HapticFeedback.heavyImpact();
          _showTimerAlert();
        }
      }
    });
  }

  void _toggleTimer() {
    HapticFeedback.selectionClick();
    if (_isTimerRunning) {
      _countdownTimer?.cancel();
      setState(() {
        _isTimerRunning = false;
      });
    } else {
      if (_remainingSeconds <= 0) {
        _remainingSeconds = _totalStepSeconds > 0 ? _totalStepSeconds : 180;
      }
      setState(() {
        _isTimerRunning = true;
      });
      _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_remainingSeconds > 1) {
          if (mounted) {
            setState(() {
              _remainingSeconds--;
            });
          }
        } else {
          timer.cancel();
          if (mounted) {
            setState(() {
              _remainingSeconds = 0;
              _isTimerRunning = false;
            });
            HapticFeedback.heavyImpact();
            _showTimerAlert();
          }
        }
      });
    }
  }

  void _addOneMinute() {
    HapticFeedback.lightImpact();
    setState(() {
      _remainingSeconds += 60;
      _totalStepSeconds += 60;
    });
  }

  void _resetTimer() {
    HapticFeedback.selectionClick();
    _countdownTimer?.cancel();
    final step = widget.recipe.steps[_currentStepIndex];
    final baseSecs = step.timerSeconds ?? 180;
    setState(() {
      _remainingSeconds = baseSecs;
      _totalStepSeconds = baseSecs;
      _isTimerRunning = false;
    });
  }

  void _showTimerAlert() {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.cardDark
            : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.accentTomato.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.alarm_on_rounded,
                color: AppColors.accentTomato,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'انتهى وقت المؤقت! ⏰',
                style: GoogleFonts.newsreader(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : AppColors.textPrimaryLight,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          'حان وقت فحص درجة النضج أو الانتقال للخطوة التالية في تحضير طبقك الشهي.',
          style: GoogleFonts.cairo(
            fontSize: 14,
            height: 1.5,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white70
                : AppColors.textSecondaryLight,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _addOneMinute();
            },
            child: Text(
              '+ دقيقة إضافية',
              style: GoogleFonts.cairo(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              _nextStep();
            },
            child: Text(
              'الخطوة التالية ⏩',
              style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _nextStep() {
    HapticFeedback.lightImpact();
    if (_currentStepIndex < widget.recipe.steps.length - 1) {
      setState(() {
        _currentStepIndex++;
      });
      _initTimerForStep(_currentStepIndex);
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => CookCompletedScreen(recipe: widget.recipe),
        ),
      );
    }
  }

  void _prevStep() {
    HapticFeedback.lightImpact();
    if (_currentStepIndex > 0) {
      setState(() {
        _currentStepIndex--;
      });
      _initTimerForStep(_currentStepIndex);
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
        );
      }
    }
  }

  void _showExitConfirmationDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.cardDark
            : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          'الخروج من وضع الطهي؟',
          style: GoogleFonts.newsreader(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'هل تريد إيقاف جلسة الطهي والرجوع؟ يمكنك استئناف الطهي في أي وقت.',
          style: GoogleFonts.cairo(fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'متابعة الطهي',
              style: GoogleFonts.cairo(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: Text(
              'خروج',
              style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _showIngredientsSheet() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white24 : AppColors.borderLight,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.kitchen_rounded,
                              color: AppColors.primary,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'مكونات الطبق (Mise en Place)',
                                style: GoogleFonts.newsreader(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : AppColors.primary,
                                ),
                              ),
                              Text(
                                '${widget.recipe.ingredients.length} مكونات مسجلة',
                                style: GoogleFonts.cairo(
                                  fontSize: 12,
                                  color: isDark ? Colors.white60 : AppColors.textSecondaryLight,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 8),
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: widget.recipe.ingredients.length,
                      separatorBuilder: (context, index) => const Divider(height: 1),
                      itemBuilder: (context, idx) {
                        final item = widget.recipe.ingredients[idx];
                        final isChecked = _checkedIngredients.contains(item.name);
                        return CheckboxListTile(
                          value: isChecked,
                          activeColor: AppColors.primary,
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            item.displayText ?? '${item.name} (${item.amount})',
                            style: GoogleFonts.cairo(
                              fontSize: 14,
                              decoration: isChecked ? TextDecoration.lineThrough : null,
                              color: isChecked
                                  ? (isDark ? Colors.white38 : Colors.black38)
                                  : (isDark ? Colors.white : AppColors.textPrimaryLight),
                              fontWeight: isChecked ? FontWeight.normal : FontWeight.w600,
                            ),
                          ),
                          secondary: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isChecked
                                  ? (isDark ? Colors.white12 : AppColors.surfaceContainerHigh)
                                  : AppColors.primary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              item.role.label,
                              style: GoogleFonts.cairo(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isChecked
                                    ? (isDark ? Colors.white38 : Colors.black45)
                                    : AppColors.primary,
                              ),
                            ),
                          ),
                          onChanged: (val) {
                            setSheetState(() {
                              if (val == true) {
                                _checkedIngredients.add(item.name);
                              } else {
                                _checkedIngredients.remove(item.name);
                              }
                            });
                            setState(() {});
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final totalSteps = widget.recipe.steps.length;
    final step = widget.recipe.steps[_currentStepIndex];

    final bgCanvas = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final cardBg = isDark ? AppColors.cardDark : Colors.white;
    final borderColor = isDark ? Colors.white.withValues(alpha: 0.1) : AppColors.borderLight;
    final textPrimary = isDark ? Colors.white : AppColors.textPrimaryLight;
    final textSecondary = isDark ? Colors.white70 : AppColors.textSecondaryLight;

    return Scaffold(
      backgroundColor: bgCanvas,
      appBar: AppBar(
        backgroundColor: bgCanvas,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isDark ? Colors.white12 : AppColors.secondaryCream,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.close_rounded, size: 20, color: textPrimary),
          ),
          tooltip: 'الخروج من وضع الطهي',
          onPressed: _showExitConfirmationDialog,
        ),
        title: Column(
          children: [
            Text(
              'الخطوة ${_currentStepIndex + 1} من $totalSteps',
              style: GoogleFonts.cairo(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            Text(
              widget.recipe.title,
              style: GoogleFonts.newsreader(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          // زر تشغيل/إيقاف الأوامر الصوتية
          InkWell(
            onTap: () {
              if (_isVoiceActive) {
                _stopVoiceListening();
              } else {
                _startVoiceListening();
              }
            },
            borderRadius: BorderRadius.circular(20),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _isVoiceActive
                    ? AppColors.primary.withValues(alpha: 0.18)
                    : (isDark ? Colors.white12 : AppColors.surfaceContainerHigh),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _isVoiceActive ? AppColors.primary : Colors.transparent,
                  width: 1.2,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _isVoiceActive ? Icons.mic_rounded : Icons.mic_off_rounded,
                    size: 16,
                    color: _isVoiceActive ? AppColors.primary : textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _isVoiceActive ? 'صوتي نشط' : 'صوتي مكتوم',
                    style: GoogleFonts.cairo(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: _isVoiceActive ? AppColors.primary : textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // زر استعراض المقادير
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isDark ? Colors.white12 : AppColors.secondaryCream,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.format_list_bulleted_rounded,
                size: 20,
                color: AppColors.primary,
              ),
            ),
            tooltip: 'قائمة المقادير',
            onPressed: _showIngredientsSheet,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 1. مسار التقدم المجزأ للخطوات (Segmented Progress Bar)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Row(
                children: List.generate(totalSteps, (idx) {
                  final isDone = idx < _currentStepIndex;
                  final isCurrent = idx == _currentStepIndex;
                  return Expanded(
                    child: Container(
                      height: 5,
                      margin: EdgeInsets.only(left: idx > 0 ? 4 : 0),
                      decoration: BoxDecoration(
                        color: isDone
                            ? AppColors.primary
                            : (isCurrent
                                ? AppColors.accentGold
                                : (isDark ? Colors.white12 : AppColors.borderLight)),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  );
                }),
              ),
            ),

            // 2. رسالة استجابة الصوت عند التقاط أمر
            if (_voiceFeedbackMessage != null)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.accentGold,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _voiceFeedbackMessage!,
                      style: GoogleFonts.cairo(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

            // 3. المحتوى الرئيسي القابل للتمرير
            Expanded(
              child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                children: [
                  // شارة تقنية الطهي والحرارة
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.accentTomato.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.local_fire_department_rounded,
                              size: 15,
                              color: AppColors.accentTomato,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'حرارة متوسطة · 185°C',
                              style: GoogleFonts.cairo(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.accentTomato,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white10 : AppColors.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.soup_kitchen_rounded,
                              size: 15,
                              color: textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'مقلاة ثقيلة / موقد مباشر',
                              style: GoogleFonts.cairo(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // صورة الخطوة / الطبق الغامرة بطابع تحريري مجلي
                  Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CachedNetworkImage(
                          imageUrl: widget.recipe.heroImageUrl,
                          fit: BoxFit.cover,
                          placeholder: (ctx, url) => Container(
                            color: isDark ? AppColors.cardDark : AppColors.secondaryCream,
                          ),
                          errorWidget: (ctx, url, err) => Container(
                            color: isDark ? AppColors.cardDark : AppColors.secondaryCream,
                            child: const Icon(
                              Icons.restaurant_rounded,
                              size: 40,
                              color: AppColors.secondary,
                            ),
                          ),
                        ),
                        // تدرج داكن للقراءة الواضحة
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.25),
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.75),
                              ],
                              stops: const [0.0, 0.45, 1.0],
                            ),
                          ),
                        ),
                        // شارات عائمة على الصورة
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.65),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Colors.greenAccent,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'المرحلة المباشرة ${_currentStepIndex + 1}',
                                  style: GoogleFonts.cairo(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 12,
                          right: 14,
                          left: 14,
                          child: Text(
                            widget.recipe.title,
                            style: GoogleFonts.newsreader(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // بطاقة التعليمات الفورية الكبرى المقروءة عن بُعد (Core Action Box)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: borderColor),
                      boxShadow: [
                        BoxShadow(
                          color: isDark
                              ? Colors.black.withValues(alpha: 0.3)
                              : Colors.black.withValues(alpha: 0.03),
                          blurRadius: 12,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'التعليمات الفورية',
                                style: GoogleFonts.cairo(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          step.text,
                          style: GoogleFonts.cairo(
                            fontSize: 20,
                            height: 1.6,
                            fontWeight: FontWeight.bold,
                            color: textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // نصيحة الشيف الذهبية (Chef Insight Box)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.surfaceContainer.withValues(alpha: 0.1)
                          : AppColors.secondaryCream,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isDark ? Colors.white12 : AppColors.borderLight,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.lightbulb_rounded,
                            color: AppColors.accentGold,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'سر النكهة من الشيف',
                                style: GoogleFonts.cairo(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                step.tip != null && step.tip!.trim().isNotEmpty
                                    ? step.tip!
                                    : 'تحريك المكونات بهدوء وبوتيرة منتظمة يضمن توزيع النكهات ونضجاً متجانساً دون فقدان السوائل العطرية.',
                                style: GoogleFonts.cairo(
                                  fontSize: 13,
                                  height: 1.5,
                                  color: textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // بطاقة المؤقت التفاعلي الكبيرة عالية اللمس (High-Touch Kitchen Timer Card)
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _isTimerRunning
                            ? AppColors.accentTomato.withValues(alpha: 0.5)
                            : borderColor,
                        width: _isTimerRunning ? 1.5 : 1.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _isTimerRunning
                              ? AppColors.accentTomato.withValues(alpha: 0.12)
                              : Colors.black.withValues(alpha: 0.03),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // ترويسة المؤقت
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: (_isTimerRunning
                                            ? AppColors.accentTomato
                                            : AppColors.primary)
                                        .withValues(alpha: 0.12),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.timer_rounded,
                                    size: 18,
                                    color: _isTimerRunning
                                        ? AppColors.accentTomato
                                        : AppColors.primary,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'مؤقت هذه الخطوة',
                                  style: GoogleFonts.newsreader(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: _isTimerRunning
                                    ? AppColors.accentTomato.withValues(alpha: 0.12)
                                    : (isDark ? Colors.white10 : AppColors.surfaceContainerHigh),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _isTimerRunning ? 'يعمل الآن ⏱️' : 'جاهز / متوقف',
                                style: GoogleFonts.cairo(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: _isTimerRunning ? AppColors.accentTomato : textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // الأرقام الرقمية الكبيرة
                        Text(
                          _formatTime(_remainingSeconds),
                          style: GoogleFonts.cairo(
                            fontSize: 44,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2,
                            color: _isTimerRunning
                                ? AppColors.accentTomato
                                : (isDark ? Colors.white : AppColors.primary),
                          ),
                        ),

                        // شريط تقدم المؤقت
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: _totalStepSeconds > 0
                                ? (_remainingSeconds / _totalStepSeconds).clamp(0.0, 1.0)
                                : 0.0,
                            backgroundColor: isDark ? Colors.white12 : AppColors.surfaceContainerHigh,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _isTimerRunning ? AppColors.accentTomato : AppColors.primary,
                            ),
                            minHeight: 6,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // أزرار التحكم بالمؤقت بأهداف لمسية رحبة
                        Row(
                          children: [
                            // زر إعادة الضبط
                            Expanded(
                              flex: 1,
                              child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: textSecondary,
                                  side: BorderSide(color: borderColor),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                onPressed: _resetTimer,
                                icon: const Icon(Icons.restart_alt_rounded, size: 18),
                                label: Text(
                                  'إعادة',
                                  style: GoogleFonts.cairo(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),

                            // زر التشغيل / الإيقاف المؤقت (الأساسي)
                            Expanded(
                              flex: 2,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _isTimerRunning
                                      ? AppColors.accentTomato
                                      : AppColors.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                onPressed: _toggleTimer,
                                icon: Icon(
                                  _isTimerRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                  size: 20,
                                ),
                                label: Text(
                                  _isTimerRunning ? 'إيقاف مؤقت' : 'بدء المؤقت',
                                  style: GoogleFonts.cairo(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),

                            // زر إضافة دقيقة
                            Expanded(
                              flex: 1,
                              child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.primary,
                                  side: BorderSide(
                                    color: AppColors.primary.withValues(alpha: 0.3),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                onPressed: _addOneMinute,
                                icon: const Icon(Icons.add_rounded, size: 18),
                                label: Text(
                                  '+ دقيقة',
                                  style: GoogleFonts.cairo(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // شريط المساعد الصوتي التفاعلي بدون لمس
                  InkWell(
                    onTap: () {
                      if (_isVoiceActive) {
                        _stopVoiceListening();
                      } else {
                        _startVoiceListening();
                      }
                    },
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: _isVoiceActive
                            ? AppColors.primary.withValues(alpha: 0.08)
                            : (isDark ? Colors.white.withValues(alpha: 0.04) : AppColors.secondaryCream),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: _isVoiceActive
                              ? AppColors.primary.withValues(alpha: 0.3)
                              : borderColor,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: _isVoiceActive ? AppColors.primary : Colors.grey.shade400,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.mic_rounded, size: 16, color: Colors.white),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _isVoiceActive
                                      ? (_lastVoiceText.isNotEmpty
                                          ? 'سمعت: «$_lastVoiceText»'
                                          : 'المساعد الصوتي يستمع إليك في المطبخ...')
                                      : 'المساعد الصوتي بدون لمس مكتوم (انقر للتفعيل)',
                                  style: GoogleFonts.cairo(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: _isVoiceActive ? AppColors.primary : textSecondary,
                                  ),
                                ),
                                Text(
                                  'أوامر سريعة: «التالي» • «السابق» • «المؤقت» • «المقادير»',
                                  style: GoogleFonts.cairo(
                                    fontSize: 11,
                                    color: textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),

            // 4. الشريط السفلي الثابت للتنقل الحركي والملاحة السريعة
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              decoration: BoxDecoration(
                color: cardBg,
                border: Border(top: BorderSide(color: borderColor)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // زر الخطوة السابقة
                  Expanded(
                    flex: 2,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: textPrimary,
                        side: BorderSide(color: borderColor),
                        minimumSize: const Size(0, 52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: _currentStepIndex > 0 ? _prevStep : null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.arrow_forward_rounded, size: 18), // في الواجهة العربية السهم اليمين يرجع للخلف
                          const SizedBox(width: 6),
                          Text(
                            'السابق',
                            style: GoogleFonts.cairo(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // زر المقادير السريعة
                  IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: isDark ? Colors.white12 : AppColors.secondaryCream,
                      minimumSize: const Size(52, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    icon: const Icon(Icons.kitchen_rounded, color: AppColors.primary, size: 22),
                    tooltip: 'عرض المقادير',
                    onPressed: _showIngredientsSheet,
                  ),

                  const SizedBox(width: 10),

                  // زر الخطوة التالية / إنهاء الطبق
                  Expanded(
                    flex: 3,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _currentStepIndex == totalSteps - 1
                            ? AppColors.accentGold
                            : AppColors.primary,
                        foregroundColor: _currentStepIndex == totalSteps - 1
                            ? AppColors.primary
                            : Colors.white,
                        minimumSize: const Size(0, 52),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: _nextStep,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _currentStepIndex == totalSteps - 1
                                ? 'إتمام الطبق 🍽️'
                                : 'الخطوة التالية',
                            style: GoogleFonts.cairo(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            _currentStepIndex == totalSteps - 1
                                ? Icons.celebration_rounded
                                : Icons.arrow_back_rounded, // في العربية السهم اليسار يتقدم للأمام
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
