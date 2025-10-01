import 'package:flutter/material.dart';
import 'payments/payments_screen.dart';
import 'plans/plans_screen.dart';
import 'reports/reports_screen.dart';
import 'analytics/analytics_screen.dart';
import 'scanner/food_scanner_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TumorHeal')),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(12),
        children: [
          _tile(context, 'Payments', Icons.payment, PaymentsScreen()),
          _tile(context, 'Plans', Icons.local_dining, PlansScreen()),
          _tile(context, 'Reports', Icons.picture_as_pdf, ReportsScreen()),
          _tile(context, 'Analytics', Icons.bar_chart, AnalyticsScreen()),
          _tile(context, 'Food Scanner', Icons.camera_alt, FoodScannerScreen()),
        ],
      ),
    );
  }

  Widget _tile(BuildContext context, String title, IconData icon, Widget page) {
    return Card(
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
        child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 44), const SizedBox(height: 8), Text(title)])),
      ),
    );
  }
}
