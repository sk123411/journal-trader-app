import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class StrategyPieChart extends StatelessWidget {
  final List<dynamic>? entries;

  const StrategyPieChart({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {

    // ✅ Handle null or empty
    if (entries == null || entries!.isEmpty) {
      return const Center(
        child: Text("No data available"),
      );
    }

    Map<String, int> strategyWins = {};

    for (var e in entries!) {
      if (e['result'] == 'win') {
        final strategy = e['strategy'] ?? "Unknown";
        strategyWins[strategy] =
            (strategyWins[strategy] ?? 0) + 1;
      }
    }

    // ✅ If no wins found
    if (strategyWins.isEmpty) {
      return const Center(
        child: Text("No winning trades"),
      );
    }

    return AspectRatio(
      aspectRatio: 2,
      child: PieChart(
        PieChartData(
          sections: strategyWins.entries.map((e) {
            return PieChartSectionData(
              value: e.value.toDouble(),
              title: "${e.key}\n${e.value}",
            );
          }).toList(),
        ),
      ),
    );
  }
}