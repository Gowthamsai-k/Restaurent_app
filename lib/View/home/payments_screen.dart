import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        // No back button, since it's a main tab
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Summary Cards
            _buildSummaryCards(),
            const SizedBox(height: 24),

            // 2. Sales Chart
            const Text(
              'Weekly Sales',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildSalesChart(),
            const SizedBox(height: 24),

            // 3. Best-Selling Items
            const Text(
              'Best-Selling Items',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildBestSellers(),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS ---

  Widget _buildSummaryCards() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
          title: 'Today\'s Revenue',
          value: '₹8,450',
          color: Colors.green,
        ),
        _buildStatCard(
          title: 'Total Orders',
          value: '42',
          color: Colors.deepOrange,
        ),
        _buildStatCard(
          title: 'Avg. Order Value',
          value: '₹201',
          color: Colors.blue,
        ),
        _buildStatCard(
          title: 'New Customers',
          value: '7',
          color: Colors.purple,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalesChart() {
    return Container(
      height: 250,
      padding: const EdgeInsets.only(top: 16, right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 10000, // Max revenue for the dummy data
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (group) => Colors.blueGrey,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '₹${(rod.toY - rod.fromY).round()}',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const style = TextStyle(fontSize: 12);
                  String text;
                  switch (value.toInt()) {
                    case 0:
                      text = 'Mon';
                      break;
                    case 1:
                      text = 'Tue';
                      break;
                    case 2:
                      text = 'Wed';
                      break;
                    case 3:
                      text = 'Thu';
                      break;
                    case 4:
                      text = 'Fri';
                      break;
                    case 5:
                      text = 'Sat';
                      break;
                    case 6:
                      text = 'Sun';
                      break;
                    default:
                      text = '';
                  }
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(text, style: style),
                  );
                },
                reservedSize: 28,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  if (value == 0) return const Text('');
                  if (value % 2000 == 0) {
                    return Text(
                      '${(value / 1000).toInt()}k',
                      style: const TextStyle(fontSize: 12),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 2000,
            getDrawingHorizontalLine: (value) =>
                FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 1),
          ),
          barGroups: [
            _makeBarGroup(0, 5000),
            _makeBarGroup(1, 6500),
            _makeBarGroup(2, 4500),
            _makeBarGroup(3, 7500),
            _makeBarGroup(4, 9000),
            _makeBarGroup(5, 8450),
            _makeBarGroup(6, 6200),
          ],
        ),
      ),
    );
  }

  // Helper for Bar Chart Data
  BarChartGroupData _makeBarGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: Colors.deepOrange,
          width: 16,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(6),
            topRight: Radius.circular(6),
          ),
        ),
      ],
    );
  }

  Widget _buildBestSellers() {
    // Dummy data for best sellers
    final List<Map<String, dynamic>> bestSellers = [
      {'name': 'Margherita Pizza', 'orders': 120},
      {'name': 'Veggie Burger', 'orders': 95},
      {'name': 'Coke', 'orders': 210},
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: List.generate(bestSellers.length, (index) {
          final item = bestSellers[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.deepOrange.withOpacity(0.1),
              child: Text(
                '#${index + 1}',
                style: const TextStyle(
                  color: Colors.deepOrange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              item['name'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Text(
              '${item['orders']} orders',
              style: const TextStyle(fontSize: 16),
            ),
          );
        }),
      ),
    );
  }
}
