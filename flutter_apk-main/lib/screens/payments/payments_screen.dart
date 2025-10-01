import 'package:flutter/material.dart';
import '../../services/payment_service.dart';
import 'crypto_payment_widget.dart';
import 'card_payment_widget.dart';

class PaymentsScreen extends StatelessWidget {
  final PaymentService _paymentService = PaymentService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payments')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Card(child: ListTile(title: const Text('Pay with card'), subtitle: const Text('Stripe PaymentSheet'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CardPaymentWidget(paymentService: _paymentService))))),
          Card(child: ListTile(title: const Text('Pay with crypto'), subtitle: const Text('BTC / ETH'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CryptoPaymentWidget())))),
        ]),
      ),
    );
  }
}
