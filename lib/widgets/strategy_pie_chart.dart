import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class StrategyPieChart extends StatelessWidget {
  final List< dynamic> entries;

   StrategyPieChart({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    Map<String, int> strategyWins = {};

  for (var e in entries) {
  if (e['result'] == 'win') {
    final strategy = e['strategy'] ?? "Unknown";
    strategyWins[strategy] =
        (strategyWins[strategy] ?? 0) + 1;
  }
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