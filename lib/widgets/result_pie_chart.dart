import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ResultPieChart extends StatelessWidget {
  final int wins;
  final int losses;
  final int breakeven;

  const ResultPieChart({
    super.key,
    required this.wins,
    required this.losses,
    required this.breakeven,
  });

  @override
  Widget build(BuildContext context) {
    final total = wins + losses + breakeven;

    // ✅ Handle no data case
    if (total == 0) {
      return const Center(
        child: Text("No data available"),
      );
    }

    return AspectRatio(
      aspectRatio: 2,
      child: PieChart(
        PieChartData(
          sections: [
            if (wins > 0)
              PieChartSectionData(
                value: wins.toDouble(),
                color: Colors.green,
                title: "Win\n$wins",
              ),
            if (losses > 0)
              PieChartSectionData(
                value: losses.toDouble(),
                color: Colors.red,
                title: "Loss\n$losses",
              ),
            if (breakeven > 0)
              PieChartSectionData(
                value: breakeven.toDouble(),
                color: Colors.orange,
                title: "BE\n$breakeven",
              ),
          ],
        ),
      ),
    );
  }
}