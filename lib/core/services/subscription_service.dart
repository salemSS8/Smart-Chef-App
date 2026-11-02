import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../config/revenuecat_config.dart';

/// حالة الاشتراك الحالية للمستخدم
class SubscriptionState {
  final bool isPro;
  final bool isLoading;
  final String? errorMessage;
  final Offerings? offerings;

  const SubscriptionState({
    this.isPro = false,
    this.isLoading = false,
    this.errorMessage,
    this.offerings,
  });

  SubscriptionState copyWith({
    bool? isPro,
    bool? isLoading,
    String? errorMessage,
    Offerings? offerings,
  }) {
    return SubscriptionState(
      isPro: isPro ?? this.isPro,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      offerings: offerings ?? this.offerings,
    );
  }
}

/// موفر حالة الاشتراك عبر تطبيق طاهي ذكي
final subscriptionProvider =
    StateNotifierProvider<SubscriptionNotifier, SubscriptionState>((ref) {
  return SubscriptionNotifier();
});

class SubscriptionNotifier extends StateNotifier<SubscriptionState> {
  SubscriptionNotifier() : super(const SubscriptionState()) {
    init();
  }

  bool _isConfigured = false;

  /// تهيئة اتصال RevenueCat عند بدء التطبيق
  Future<void> init() async {
    // RevenueCat يدعم منصات أندرويد و iOS فقط
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      final apiKey = RevenueCatConfig.apiKey;
      if (apiKey.isEmpty || apiKey.contains('placeholder')) {
        debugPrint('RevenueCat: يتم العمل حالياً بمفتاح تجريبي محلي.');
        return;
      }

      try {
        state = state.copyWith(isLoading: true);
        final configuration = PurchasesConfiguration(apiKey);
        await Purchases.configure(configuration);
        _isConfigured = true;

        await checkSubscriptionStatus();
        await fetchOfferings();
      } catch (e) {
        debugPrint('خطأ في تهيئة RevenueCat: $e');
        state = state.copyWith(isLoading: false, errorMessage: e.toString());
      }
    }
  }

  /// التحقق من حالة اشتراك المستخدم الحالية (هل هو Pro؟)
  Future<void> checkSubscriptionStatus() async {
    if (!_isConfigured) return;
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      final hasPro = customerInfo.entitlements.all[RevenueCatConfig.proEntitlementId]?.isActive ?? false;
      state = state.copyWith(isPro: hasPro, isLoading: false);
    } catch (e) {
      debugPrint('خطأ في فحص حالة الاشتراك: $e');
      state = state.copyWith(isLoading: false);
    }
  }

  /// جلب الباقات المتاحة للاشتراك (شهري / سنوي) من المتجر
  Future<void> fetchOfferings() async {
    if (!_isConfigured) return;
    try {
      final offerings = await Purchases.getOfferings();
      state = state.copyWith(offerings: offerings, isLoading: false);
    } catch (e) {
      debugPrint('خطأ في جلب باقات الاشتراك: $e');
      state = state.copyWith(isLoading: false);
    }
  }

  /// إتمام عملية شراء باقة عبر متجر Google Play / Apple
  Future<bool> purchasePackage(Package package) async {
    if (!_isConfigured) return false;
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final purchaseResult = await Purchases.purchase(PurchaseParams.package(package));
      final hasPro = purchaseResult.customerInfo.entitlements.all[RevenueCatConfig.proEntitlementId]?.isActive ?? false;
      state = state.copyWith(isPro: hasPro, isLoading: false);
      return hasPro;
    } catch (e) {
      debugPrint('خطأ أثناء إتمام عملية الشراء: $e');
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  /// استعادة المشتريات السابقة (Restore Purchases)
  Future<bool> restorePurchases() async {
    if (!_isConfigured) return false;
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final customerInfo = await Purchases.restorePurchases();
      final hasPro = customerInfo.entitlements.all[RevenueCatConfig.proEntitlementId]?.isActive ?? false;
      state = state.copyWith(isPro: hasPro, isLoading: false);
      return hasPro;
    } catch (e) {
      debugPrint('خطأ أثناء استعادة المشتريات: $e');
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  /// تفعيل وضع Pro يدوياً لأغراض التجربة والتطوير المحلي
  void setDebugProMode(bool isPro) {
    state = state.copyWith(isPro: isPro);
  }
}
