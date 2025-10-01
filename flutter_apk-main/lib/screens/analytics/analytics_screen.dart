import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: LineChart(LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: true),
          borderData: FlBorderData(show: true),
          lineBarsData: [LineChartBarData(spots: [
            FlSpot(0,1), FlSpot(1,1.2), FlSpot(2,1.5), FlSpot(3,1.4)
          ])]
        )),
      ),
    );
  }
}
