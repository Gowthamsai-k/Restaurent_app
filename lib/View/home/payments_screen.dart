import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            'Orders Today',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // 🔹 Pie Chart for Order Status
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    color: Colors.green,
                    value: 12,
                    title: 'Completed',
                    titleStyle: const TextStyle(color: Colors.white),
                  ),
                  PieChartSectionData(
                    color: Colors.orange,
                    value: 3,
                    title: 'Pending',
                    titleStyle: const TextStyle(color: Colors.white),
                  ),
                ],
                sectionsSpace: 2,
                centerSpaceRadius: 40,
              ),
            ),
          ),
          const SizedBox(height: 24),

          const Text(
            'Revenue Overview',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // 🔹 Bar Chart for revenue by day
          SizedBox(
            height: 250,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 5000,
                barGroups: [
                  BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 4500, color: Colors.redAccent)]),
                  BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 3800, color: Colors.redAccent)]),
                  BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 5000, color: Colors.redAccent)]),
                  BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 4200, color: Colors.redAccent)]),
                  BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 4700, color: Colors.redAccent)]),
                  BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 3500, color: Colors.redAccent)]),
                  BarChartGroupData(x: 6, barRods: [BarChartRodData(toY: 4800, color: Colors.redAccent)]),
                ],
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];
                        return Text(days[value.toInt()], style: const TextStyle(fontSize: 12));
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
