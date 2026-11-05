import 'package:flutter_test/flutter_test.dart';
import 'package:smart_cook/core/services/voice_command_service.dart';

void main() {
  late VoiceCommandService service;

  setUp(() {
    service = VoiceCommandService();
  });

  group('VoiceCommandService Voice Command Parsing', () {
    test('parses next step commands correctly in Arabic', () {
      expect(service.parseCommand('التالي').type, equals(VoiceCommandType.nextStep));
      expect(service.parseCommand('الخطوة التالية').type, equals(VoiceCommandType.nextStep));
      expect(service.parseCommand('بعده').type, equals(VoiceCommandType.nextStep));
      expect(service.parseCommand('امش للخطوة الجاية').type, equals(VoiceCommandType.nextStep));
      expect(service.parseCommand('next').type, equals(VoiceCommandType.nextStep));
    });

    test('parses previous step commands correctly in Arabic', () {
      expect(service.parseCommand('السابق').type, equals(VoiceCommandType.prevStep));
      expect(service.parseCommand('الخطوة السابقة').type, equals(VoiceCommandType.prevStep));
      expect(service.parseCommand('ارجع').type, equals(VoiceCommandType.prevStep));
      expect(service.parseCommand('رجوع').type, equals(VoiceCommandType.prevStep));
      expect(service.parseCommand('back').type, equals(VoiceCommandType.prevStep));
    });

    test('parses timer commands with numbers correctly', () {
      final cmd5 = service.parseCommand('مؤقت 5 دقائق');
      expect(cmd5.type, equals(VoiceCommandType.startTimer));
      expect(cmd5.timerMinutes, equals(5));

      final cmd10 = service.parseCommand('شغل مؤقت عشر دقائق');
      expect(cmd10.type, equals(VoiceCommandType.startTimer));
      expect(cmd10.timerMinutes, equals(10));

      final pauseCmd = service.parseCommand('وقف المؤقت');
      expect(pauseCmd.type, equals(VoiceCommandType.pauseTimer));

      final pauseSimple = service.parseCommand('وقف');
      expect(pauseSimple.type, equals(VoiceCommandType.pauseTimer));
    });

    test('parses ingredients and repetition commands', () {
      expect(service.parseCommand('المقادير').type, equals(VoiceCommandType.showIngredients));
      expect(service.parseCommand('المكونات').type, equals(VoiceCommandType.showIngredients));
      expect(service.parseCommand('وش المقادير').type, equals(VoiceCommandType.showIngredients));

      expect(service.parseCommand('كرر').type, equals(VoiceCommandType.repeatStep));
      expect(service.parseCommand('أعد الخطوة').type, equals(VoiceCommandType.repeatStep));
      expect(service.parseCommand('اقرأ').type, equals(VoiceCommandType.repeatStep));
    });
  });
}
