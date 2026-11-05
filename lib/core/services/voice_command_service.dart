import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

/// أنواع الأوامر الصوتية المعترف بها في وضع الطهي
enum VoiceCommandType {
  nextStep,
  prevStep,
  toggleTimer,
  startTimer,
  pauseTimer,
  showIngredients,
  repeatStep,
  unknown,
}

class VoiceCommand {
  final VoiceCommandType type;
  final String rawText;
  final int? timerMinutes;

  const VoiceCommand({
    required this.type,
    required this.rawText,
    this.timerMinutes,
  });
}

/// خدمة معالجة الأوامر الصوتية بدون لمس أثناء الطهي
class VoiceCommandService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isInitialized = false;
  String _selectedLocaleId = 'ar_SA';

  bool get isAvailable => _isInitialized && _speech.isAvailable;
  bool get isListening => _speech.isListening;

  /// تهيئة محرك تحويل الصوت إلى نص
  Future<bool> initialize({
    void Function(String status)? onStatus,
    void Function(SpeechRecognitionError error)? onError,
  }) async {
    if (_isInitialized) return _speech.isAvailable;

    try {
      _isInitialized = await _speech.initialize(
        onStatus: (status) {
          debugPrint('VoiceCommandService Status: $status');
          onStatus?.call(status);
        },
        onError: (errorNotification) {
          debugPrint('VoiceCommandService Error: ${errorNotification.errorMsg}');
          onError?.call(errorNotification);
        },
        debugLogging: kDebugMode,
      );

      if (_isInitialized) {
        // البحث عن أفضل لغة عربية متوفرة في النظام
        final locales = await _speech.locales();
        final arabicLocale = locales.firstWhere(
          (loc) => loc.localeId.toLowerCase().startsWith('ar'),
          orElse: () => locales.isNotEmpty ? locales.first : stt.LocaleName('ar_SA', 'Arabic'),
        );
        _selectedLocaleId = arabicLocale.localeId;
        debugPrint('VoiceCommandService: Active locale $_selectedLocaleId');
      }

      return _isInitialized;
    } catch (e) {
      debugPrint('VoiceCommandService Init Exception: $e');
      _isInitialized = false;
      return false;
    }
  }

  /// بدء الاستماع للأوامر الصوتية
  Future<void> startListening({
    required void Function(VoiceCommand command) onCommandDetected,
    void Function(String partialText)? onPartialResult,
  }) async {
    if (!_isInitialized) {
      final ok = await initialize();
      if (!ok) return;
    }

    if (_speech.isListening) {
      await _speech.stop();
    }

    try {
      await _speech.listen(
        onResult: (SpeechRecognitionResult result) {
          final words = result.recognizedWords.trim();
          onPartialResult?.call(words);

          if (result.finalResult || words.isNotEmpty) {
            final cmd = parseCommand(words);
            if (cmd.type != VoiceCommandType.unknown) {
              onCommandDetected(cmd);
            }
          }
        },
        listenOptions: stt.SpeechListenOptions(
          localeId: _selectedLocaleId,
          listenFor: const Duration(seconds: 40),
          pauseFor: const Duration(seconds: 3),
          partialResults: true,
          cancelOnError: false,
          listenMode: stt.ListenMode.confirmation,
        ),
      );
    } catch (e) {
      debugPrint('VoiceCommandService Listen Exception: $e');
    }
  }

  /// إيقاف الاستماع
  Future<void> stopListening() async {
    if (_speech.isListening) {
      await _speech.stop();
    }
  }

  /// إلغاء الاستماع
  Future<void> cancelListening() async {
    await _speech.cancel();
  }

  /// تحليل النص المنطوق واستخراج الأمر
  VoiceCommand parseCommand(String rawText) {
    final lower = rawText.toLowerCase().trim();

    // 1. أمر الخطوة التالية
    if (lower.contains('تالي') ||
        lower.contains('التالي') ||
        lower.contains('بعده') ||
        lower.contains('بعدها') ||
        lower.contains('امش') ||
        lower.contains('الخطوه التاليه') ||
        lower.contains('الخطوة التالية') ||
        lower.contains('next')) {
      return VoiceCommand(type: VoiceCommandType.nextStep, rawText: rawText);
    }

    // 2. أمر الخطوة السابقة
    if (lower.contains('سابق') ||
        lower.contains('السابق') ||
        lower.contains('ارجع') ||
        lower.contains('رجوع') ||
        lower.contains('قبله') ||
        lower.contains('قبلها') ||
        lower.contains('الخطوة السابقة') ||
        lower.contains('back') ||
        lower.contains('previous')) {
      return VoiceCommand(type: VoiceCommandType.prevStep, rawText: rawText);
    }

    // 3. أمر المؤقت مع استخراج الدقائق
    if (lower.contains('مؤقت') || lower.contains('مؤقت')) {
      final numberMatch = RegExp(r'(\d+)').firstMatch(lower);
      int? minutes;
      if (numberMatch != null) {
        minutes = int.tryParse(numberMatch.group(1)!);
      } else if (lower.contains('خمس') || lower.contains('خمسة')) {
        minutes = 5;
      } else if (lower.contains('عشر') || lower.contains('عشرة')) {
        minutes = 10;
      } else if (lower.contains('دقيقة') || lower.contains('دقيقه')) {
        minutes = 1;
      } else if (lower.contains('دقيقتين')) {
        minutes = 2;
      }

      if (lower.contains('وقف') || lower.contains('ايقاف') || lower.contains('إيقاف') || lower.contains('pause') || lower.contains('stop')) {
        return VoiceCommand(type: VoiceCommandType.pauseTimer, rawText: rawText);
      }

      if (lower.contains('شغل') || lower.contains('ابدأ') || lower.contains('start') || minutes != null) {
        return VoiceCommand(type: VoiceCommandType.startTimer, rawText: rawText, timerMinutes: minutes);
      }

      return VoiceCommand(type: VoiceCommandType.toggleTimer, rawText: rawText, timerMinutes: minutes);
    }

    // 4. أمر إيقاف المؤقت بدون كلمة مؤقت
    if (lower == 'وقف' || lower == 'ايقاف' || lower == 'إيقاف' || lower == 'pause' || lower == 'stop') {
      return VoiceCommand(type: VoiceCommandType.pauseTimer, rawText: rawText);
    }

    // 5. أمر عرض المقادير
    if (lower.contains('مقادير') ||
        lower.contains('المقادير') ||
        lower.contains('مكونات') ||
        lower.contains('المكونات') ||
        lower.contains('وش المقادير') ||
        lower.contains('شو المكونات') ||
        lower.contains('ingredients')) {
      return VoiceCommand(type: VoiceCommandType.showIngredients, rawText: rawText);
    }

    // 6. أمر تكرار الخطوة
    if (lower.contains('كرر') ||
        lower.contains('اعد') ||
        lower.contains('أعد') ||
        lower.contains('اقرأ') ||
        lower.contains('اقرا') ||
        lower.contains('عيده') ||
        lower.contains('repeat')) {
      return VoiceCommand(type: VoiceCommandType.repeatStep, rawText: rawText);
    }

    return VoiceCommand(type: VoiceCommandType.unknown, rawText: rawText);
  }
}
