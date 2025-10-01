import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter/material.dart';
import 'api_service.dart';

class PaymentService {
  final ApiService _api = ApiService();

  /// Card payment using Stripe PaymentIntent flow.
  /// Backend should create PaymentIntent and return client_secret.
  Future<Map<String, dynamic>> payWithCard({required int amountCents, required String currency}) async {
    final resp = await _api.post('/api/v1/payments/create_intent', {'amount': amountCents, 'currency': currency});
    final clientSecret = resp.data['client_secret'] as String;

    // Initialize payment sheet
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: 'TumorHeal',
        appearance: PaymentSheetAppearance(
          colors: PaymentSheetAppearanceColors(
            background: Color(0xFFFFFFFF),
            primary: Color(0xFF2196F3),
          ),
        ),
        billingDetails: const BillingDetails(),
      ),
    );

    await Stripe.instance.presentPaymentSheet();
    return {'status': 'success'};
  }
}
