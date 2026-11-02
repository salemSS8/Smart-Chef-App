/// إعدادات وتهيئة بوابة الدفع Stripe
class StripeConfig {
  StripeConfig._();

  /// المفتاح العام (Publishable Key)
  static const String publishableKey =
      'pk_test_51UTlM58a56Bgdygqc92WuIAKfpXWjSuL5KJUSgQPg61F7ui9EnNH1ql7tubMjkFQSwbHYLnA1np7t57LDKUpGgP600kVVaKcmR';

  /// رابط الدفع المباشر للاشتراك الشهري (24.99 ر.س / شهر)
  static const String monthlySubscriptionUrl =
      'https://buy.stripe.com/test_aFa9AN1g19iZatAazk87K00';

  /// رابط الدفع المباشر للاشتراك السنوي (149.99 ر.س / سنة)
  static const String yearlySubscriptionUrl =
      'https://buy.stripe.com/test_bJedR33o93YFeJQfTE87K01';
}

