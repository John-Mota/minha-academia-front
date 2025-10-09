import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:minha_academia_front/utils/constants/colors.dart';

class WeeklyCheckinChart extends StatelessWidget {
  const WeeklyCheckinChart({super.key});

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xFF90949B),
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Seg';
        break;
      case 1:
        text = 'Ter';
        break;
      case 2:
        text = 'Qua';
        break;
      case 3:
        text = 'Qui';
        break;
      case 4:
        text = 'Sex';
        break;
      case 5:
        text = 'Sáb';
        break;
      case 6:
        text = 'Dom';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  @override
  Widget build(BuildContext context) {
    const targetLineY = 110.0;
    final lineColor = primaryColor;

    final List<FlSpot> checkinData = [
      const FlSpot(0, 140),
      const FlSpot(1, 170),
      const FlSpot(2, 190),
      const FlSpot(3, 200),
      const FlSpot(4, 230),
      const FlSpot(5, 160),
      const FlSpot(6, 100),
    ];

    const chartBackgroundColor = Color(0xFF1D293D);
    const gridColor = Color(0xFF384459);
    const labelColor = Colors.white70;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: chartBackgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF848485), width: 2.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          const Text(
            'Dados dos últimos 7 dias',
            style: TextStyle(color: labelColor, fontSize: 16),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: LineChart(
              LineChartData(
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: getTitles,
                      interval: 1,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: 60,
                      getTitlesWidget: (value, meta) {
                        if (value == 250) return Container();

                        return Text(
                          '${value.toInt()}',
                          style: const TextStyle(
                            color: labelColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.left,
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 60,
                  getDrawingHorizontalLine: (value) {
                    return const FlLine(
                      color: gridColor,
                      strokeWidth: 1,
                      dashArray: [5, 5],
                    );
                  },
                ),
                minX: 0,
                maxX: 6,
                minY: 0,
                maxY: 250,

                lineBarsData: [
                  LineChartBarData(
                    spots: checkinData,
                    isCurved: true,
                    color: lineColor,
                    barWidth: 3,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) =>
                          FlDotCirclePainter(
                            radius: 4,
                            color: lineColor,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          ),
                    ),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
