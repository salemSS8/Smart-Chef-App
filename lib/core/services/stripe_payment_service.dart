import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/stripe_config.dart';

class StripePaymentService {
  StripePaymentService._();

  /// فتح صفحة الدفع الخاصة بالخطة المحددة (0: شهري، 1: سنوي)
  static Future<bool> openCheckoutForPlan(int planIndex) async {
    final String urlString = planIndex == 1
        ? StripeConfig.yearlySubscriptionUrl
        : StripeConfig.monthlySubscriptionUrl;

    return openCheckoutUrl(urlString);
  }

  /// فتح رابط صفحة دفع Stripe في المتصفح
  static Future<bool> openCheckoutUrl(String urlString) async {
    try {
      final Uri uri = Uri.parse(urlString);

      final bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      return launched;
    } catch (e) {
      debugPrint('Error launching Stripe payment URL: $e');
      return false;
    }
  }
}

