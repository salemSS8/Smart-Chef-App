import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/models/recipe.dart';
import 'cook_completed_screen.dart';

class CookModeScreen extends StatefulWidget {
  final Recipe recipe;

  const CookModeScreen({super.key, required this.recipe});

  @override
  State<CookModeScreen> createState() => _CookModeScreenState();
}

class _CookModeScreenState extends State<CookModeScreen> {
  int _currentStepIndex = 0;

  // Timer state
  Timer? _countdownTimer;
  int _remainingSeconds = 0;
  bool _isTimerRunning = false;

  @override
  void initState() {
    super.initState();
    // إبقاء الشاشة مضاءة طوال جلسة الطهي لمنع إغلاق الهاتف أثناء انشغال اليدين
    WakelockPlus.enable();
    _initTimerForStep(_currentStepIndex);
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    // إعادة ضبط سلوك إغلاق الشاشة الطبيعي عند مغادرة وضع الطهي
    WakelockPlus.disable();
    super.dispose();
  }

  void _initTimerForStep(int index) {
    _countdownTimer?.cancel();
    _isTimerRunning = false;
    final step = widget.recipe.steps[index];
    if (step.timerSeconds != null) {
      setState(() {
        _remainingSeconds = step.timerSeconds!;
      });
    } else {
      setState(() {
        _remainingSeconds = 0;
      });
    }
  }

  void _toggleTimer() {
    if (_isTimerRunning) {
      _countdownTimer?.cancel();
      setState(() {
        _isTimerRunning = false;
      });
    } else {
      if (_remainingSeconds <= 0) return;
      setState(() {
        _isTimerRunning = true;
      });
      _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_remainingSeconds > 1) {
          setState(() {
            _remainingSeconds--;
          });
        } else {
          timer.cancel();
          setState(() {
            _remainingSeconds = 0;
            _isTimerRunning = false;
          });
          _showTimerAlert();
        }
      });
    }
  }

  void _showTimerAlert() {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.darkSurfaceElevated,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.alarm_on_rounded, color: AppColors.accentTomato, size: 28),
            SizedBox(width: 8),
            Text('انتهى وقت المؤقت! ⏰', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: const Text(
          'حان وقت الانتقال للخطوة التالية في تحضير طبقك الشهي.',
          style: TextStyle(color: Colors.white70, fontSize: 15),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  void _nextStep() {
    if (_currentStepIndex < widget.recipe.steps.length - 1) {
      setState(() {
        _currentStepIndex++;
      });
      _initTimerForStep(_currentStepIndex);
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
    if (_currentStepIndex > 0) {
      setState(() {
        _currentStepIndex--;
      });
      _initTimerForStep(_currentStepIndex);
    }
  }

  void _showIngredientsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkSurfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'مكونات ومقادير الطبق',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white70),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(color: Colors.white12),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.recipe.ingredients.length,
                  itemBuilder: (context, idx) {
                    final item = widget.recipe.ingredients[idx];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle_rounded, size: 18, color: AppColors.secondary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              item.displayText ?? '${item.name} (${item.amount})',
                              style: const TextStyle(fontSize: 15, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
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
    final step = widget.recipe.steps[_currentStepIndex];
    final totalSteps = widget.recipe.steps.length;
    final progress = (_currentStepIndex + 1) / totalSteps;

    // Dark background as in 05 · وضع الطهي
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation matching 05 mockup
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  // Close X button
                  CircleAvatar(
                    backgroundColor: Colors.white.withAlpha(20),
                    child: IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Center title & progress
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '${widget.recipe.title} • الخطوة ${_currentStepIndex + 1} من $totalSteps',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.white12,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accentTomato),
                            minHeight: 4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),
                  // Ingredients sheet button
                  CircleAvatar(
                    backgroundColor: Colors.white.withAlpha(20),
                    child: IconButton(
                      icon: const Icon(Icons.format_list_bulleted_rounded, color: Colors.white),
                      tooltip: 'تذكير بالمقادير',
                      onPressed: _showIngredientsSheet,
                    ),
                  ),
                ],
              ),
            ),

            // Floating Active Timer if running
            if (_isTimerRunning || _remainingSeconds > 0)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatTime(_remainingSeconds),
                      style: const TextStyle(
                        color: AppColors.accentTomato,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'مؤقت: ${widget.recipe.title}',
                          style: const TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.alarm_rounded, color: AppColors.accentTomato, size: 18),
                      ],
                    ),
                  ],
                ),
              ),

            // Step Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 10),

                    // Huge Step Text (matching 05 mockup)
                    Text(
                      step.text,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        height: 1.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Step Image / Illustration placeholder
                    Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(8),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white12, width: 1.5),
                      ),
                      child: Center(
                        child: Text(
                          step.tip != null ? 'نصيحة: ${step.tip}' : 'صورة أو رسم توضيحي للخطوة',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: step.tip != null ? Colors.amber.shade200 : Colors.white38,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Interactive Timer Button matching 05 mockup
                    if (step.timerSeconds != null)
                      InkWell(
                        onTap: _toggleTimer,
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          decoration: BoxDecoration(
                            color: AppColors.accentTomato,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _formatTime(_remainingSeconds),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'monospace',
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    _isTimerRunning
                                        ? 'إيقاف المؤقت مؤقتاً'
                                        : 'شغّل مؤقت ${(step.timerSeconds! / 60).round()} دقائق',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(
                                    _isTimerRunning ? Icons.pause_rounded : Icons.alarm_rounded,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                    const SizedBox(height: 18),

                    // Voice Command Hint (matching 05 mockup)
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'قل «التالي» أو «كرر» أو «مؤقت 5 دقائق»',
                          style: TextStyle(color: Colors.white38, fontSize: 13),
                        ),
                        SizedBox(width: 6),
                        Icon(Icons.mic_none_rounded, color: Colors.white38, size: 16),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Buttons (السابق / التالي)
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.black.withAlpha(40),
              child: Row(
                children: [
                  // Previous button
                  Expanded(
                    flex: 1,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white24, width: 1.5),
                        minimumSize: const Size(0, 56),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: _currentStepIndex > 0 ? _prevStep : null,
                      child: const Text('السابق', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),

                  const SizedBox(width: 14),

                  // Next button (Saffron Gold)
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentGold,
                        foregroundColor: AppColors.darkBackground,
                        minimumSize: const Size(0, 56),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: _nextStep,
                      child: Text(
                        _currentStepIndex == totalSteps - 1 ? 'إتمام الطبق 🍽️' : 'التالي',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
