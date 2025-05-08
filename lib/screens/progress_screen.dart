import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for progress metrics
    const int wordsLearned = 100;
    const double memoryRate = 0.75; // 75%
    const int reviewSessions = 30;

    // Mock data for review suggestions
    final List<Map<String, String>> reviewSuggestions = [
      {'word': 'Father', 'dueIn': '2 hours'},
      {'word': 'Mother', 'dueIn': '1 day'},
      {'word': 'Brother', 'dueIn': '3 days'},
      {'word': 'Lion', 'dueIn': '5 days'},
    ];

    // Mock data for review activity
    final List<Map<String, dynamic>> reviewActivity = [
      {'day': 'Mon', 'count': 3},
      {'day': 'Tue', 'count': 5},
      {'day': 'Wed', 'count': 2},
      {'day': 'Thu', 'count': 4},
      {'day': 'Fri', 'count': 6},
      {'day': 'Sat', 'count': 3},
      {'day': 'Sun', 'count': 1},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Progress',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress Summary Metrics
              const Text(
                'Progress Summary',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Metrics Cards
              Row(
                children: [
                  // Words Learned
                  Expanded(
                    child: _buildMetricCard(
                      context,
                      'Words Learned',
                      wordsLearned.toString(),
                      Icons.check_circle,
                      Colors.green,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Memory Rate
                  Expanded(
                    child: _buildMetricCard(
                      context,
                      'Memory Rate',
                      '${(memoryRate * 100).toInt()}%',
                      Icons.psychology,
                      Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Review Sessions
                  Expanded(
                    child: _buildMetricCard(
                      context,
                      'Review Sessions',
                      reviewSessions.toString(),
                      Icons.repeat,
                      Colors.orange,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Memory Rate Pie Chart
              const Text(
                'Memory Rate',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 200,
                child: Row(
                  children: [
                    // Pie Chart
                    Expanded(
                      flex: 3,
                      child: _buildMemoryRatePieChart(memoryRate),
                    ),

                    // Legend
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLegendItem('Remembered', Colors.green),
                          const SizedBox(height: 8),
                          _buildLegendItem('Forgotten', Colors.red.shade300),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Review Activity Bar Chart
              const Text(
                'Review Activity',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 200,
                child: _buildReviewActivityBarChart(reviewActivity),
              ),

              const SizedBox(height: 24),

              // Review Suggestions
              const Text(
                'Review Suggestions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Words you may forget soon:',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 12),

              // Review Suggestions List
              ...reviewSuggestions.map(
                (suggestion) => _buildReviewSuggestionItem(context, suggestion),
              ),

              // Bottom padding
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemoryRatePieChart(double memoryRate) {
    return PieChart(
      PieChartData(
        sectionsSpace: 0,
        centerSpaceRadius: 40,
        sections: [
          PieChartSectionData(
            color: Colors.green,
            value: memoryRate * 100,
            title: '${(memoryRate * 100).toInt()}%',
            radius: 60,
            titleStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          PieChartSectionData(
            color: Colors.red.shade300,
            value: (1 - memoryRate) * 100,
            title: '${((1 - memoryRate) * 100).toInt()}%',
            radius: 60,
            titleStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildReviewActivityBarChart(List<Map<String, dynamic>> data) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 8,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${data[groupIndex]['day']}: ${rod.toY.toInt()} sessions',
                const TextStyle(color: Colors.white),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    data[value.toInt()]['day'],
                    style: const TextStyle(fontSize: 12),
                  ),
                );
              },
              reservedSize: 28,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value % 2 != 0) return const SizedBox();
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 12),
                  ),
                );
              },
              reservedSize: 28,
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        barGroups:
            data.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: item['count'].toDouble(),
                    color: Colors.blue,
                    width: 20,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6),
                    ),
                  ),
                ],
              );
            }).toList(),
      ),
    );
  }

  Widget _buildReviewSuggestionItem(
    BuildContext context,
    Map<String, String> suggestion,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: _getVocabIcon(suggestion['word'] ?? ''),
        title: Text(
          suggestion['word'] ?? '',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Due in ${suggestion['dueIn']}',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // TODO: Navigate to flashcard review
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Review ${suggestion['word']} coming soon!'),
            ),
          );
        },
      ),
    );
  }

  Widget _getVocabIcon(String word) {
    // Map vocabulary words to appropriate icons
    IconData iconData;
    Color iconColor;

    switch (word.toLowerCase()) {
      case 'father':
        iconData = Icons.man;
        iconColor = Colors.blue;
        break;
      case 'mother':
        iconData = Icons.woman;
        iconColor = Colors.pink;
        break;
      case 'brother':
        iconData = Icons.boy;
        iconColor = Colors.indigo;
        break;
      case 'sister':
        iconData = Icons.girl;
        iconColor = Colors.purple;
        break;
      case 'lion':
        iconData = Icons.pets;
        iconColor = Colors.amber;
        break;
      default:
        iconData = Icons.text_fields;
        iconColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(iconData, size: 24, color: iconColor),
    );
  }
}
