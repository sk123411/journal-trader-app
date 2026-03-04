import 'package:flutter/material.dart';
import 'package:flutter_journal/database/hive_service.dart';
import 'package:flutter_journal/screens/strategy_list_screen.dart';
import 'package:flutter_journal/widgets/add_monthly_learning_widget.dart';
import 'package:flutter_journal/widgets/month_drawer.dart';
import 'package:flutter_journal/widgets/result_pie_chart.dart';
import 'package:flutter_journal/widgets/strategy_pie_chart.dart';
import 'add_entry_screen.dart';
import 'entries_list_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  var data;
  int wins = 0, losses = 0, breakeven = 0, total = 0;
  final learnings = HiveService.getAllMonthlyLearnings();

  var selectedMonth = HiveService.getCurrentMonth();

  Future loadStats() async {
    if (selectedMonth == null) return;

    data = HiveService.monthlyJournalBox.get(selectedMonth);

    if (data == null) {
      setState(() {
        total = 0;
        wins = 0;
        losses = 0;
        breakeven = 0;
      });
      return;
    }

    final entries = List<Map<String, dynamic>>.from(
      data.map((e) => Map<String, dynamic>.from(e)),
    );

    setState(() {
      total = entries.length;
      wins = entries.where((e) => e['result'] == 'win').length;
      losses = entries.where((e) => e['result'] == 'loss').length;
      breakeven = entries.where((e) => e['result'] == 'breakeven').length;
    });
  }

  @override
  void initState() {
    super.initState();
    loadStats();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadStats();
  }

  Widget statCard(String title, int value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text(
              value.toString(),
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MonthDrawer(
        onTapMonth: (month) {
          setState(() {
            selectedMonth = month;
            loadStats();
          });
        },
      ),
      appBar: AppBar(title: const Text("Trading Journal Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     statCard("Total", total),
            //     statCard("Wins", wins),
            //     statCard("Losses", losses),
            //     statCard("Breakeven", breakeven),
            //   ],
            // ),

            // const SizedBox(height: 40),

            // ElevatedButton(
            //   onPressed: () async {
            //     await Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (_) => AddEntryScreen()),
            //     );
            //     await loadStats(); // no extra setState needed
            //   },
            //   child: const Text("Add Entry"),
            // ),

            // const SizedBox(height: 15),

            // ElevatedButton(
            //   onPressed: () async {
            //     await Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (_) => EntriesListScreen(data, selectedMonth),
            //       ),
            //     );

            //     setState(() {
            //       loadStats();
            //     });
            //   },

            //   child: const Text("View Entries"),
            // ),

            // SizedBox(height: 12),

            // ElevatedButton(
            //   onPressed: () async {
            //     await Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (_) =>
            //             StrategyListScreen(HiveService.getStrategies()),
            //       ),
            //     );

            //     setState(() {
            //       loadStats();
            //     });
            //   },

            //   child: const Text("View Strategies"),
            // ),

            // SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      ResultPieChart(
                        wins: wins,
                        losses: losses,
                        breakeven: breakeven,
                      ),

                      SizedBox(height: 8),

                      ElevatedButton(
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  EntriesListScreen(data, selectedMonth),
                            ),
                          );

                          setState(() {
                            loadStats();
                          });
                        },

                        child: const Text("View Entries"),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20),
                Expanded(child: Column(
                  children: [
                    StrategyPieChart(entries: data),
                                          SizedBox(height: 8),

                      ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        StrategyListScreen(HiveService.getStrategies()),
                  ),
                );

                setState(() {
                  loadStats();
                });
              },

              child: const Text("View Strategies"),
            ),
                  ],
                )),
              ],
            ),

            Text("Top learnings of the month", style: TextStyle(fontSize: 18)),

            Expanded(
              child: ValueListenableBuilder(
                valueListenable: Hive.box('monthlyLearningsBox').listenable(),
                builder: (context, Box box, _) {
                  if (box.isEmpty) {
                    return const Center(
                      child: Text("No learnings added yet 🚀"),
                    );
                  }

                  final learnings = box.values.toList();
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: learnings.length,
                    itemBuilder: (context, index) {
                      final monthData = learnings[index];
                      final month = monthData["month"];
                      final points = List<String>.from(monthData["learnings"]);
                      //be better prepare with analysis on option chart before market open
                      // analysis on support, resistance , breakout , trendlines and so on
                      print(month);
                      print(points);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Month Title
                              ///
                              SizedBox(height: 6),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    month,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () async {
                                      await HiveService.deleteMonthlyLearning(
                                        month,
                                      );
                                      (context as Element).markNeedsBuild();
                                    },
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              /// Learning Points
                              ...points.map(
                                (point) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "• ",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Expanded(
                                        child: Text(
                                          point,
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => const AddMonthlyLearningSheet(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
