import 'package:flutter/material.dart';
import 'package:flutter_journal/database/hive_service.dart';
import 'package:flutter_journal/database/supabase_service.dart';
import 'package:flutter_journal/screens/strategy_list_screen.dart';
import 'package:flutter_journal/sync_button.dart';
import 'package:flutter_journal/widgets/add_monthly_learning_widget.dart';
import 'package:flutter_journal/widgets/month_drawer.dart';
import 'package:flutter_journal/widgets/result_pie_chart.dart';
import 'package:flutter_journal/widgets/strategy_pie_chart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
  var learnings;
  var selectedMonth;

Future loadStats() async {
  if (selectedMonth == null) return;

  final grouped = HiveService.getEntriesGroupedByMonth();
  data = grouped[selectedMonth] ?? [];

  print(data);

  int w = 0, l = 0, b = 0;

  for (var e in data) {
    switch (e['result']) {
      case 'win':
        w++;
        break;
      case 'loss':
        l++;
        break;
      case 'breakeven':
        b++;
        break;
    }
  }

  setState(() {
    total = data.length;
    wins = w;
    losses = l;
    breakeven = b;
  });
}

  @override
  void initState() {
    super.initState();
     selectedMonth = HiveService.getCurrentMonth();
  learnings = HiveService.getAllMonthlyLearnings();

  loadStats();
}

void _showRestoreDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Restore Backup"),
        content: const Text(
          "Do you want to overwrite local data with cloud data?\n\n"
          "⚠️ This will replace all your current local entries.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {

              await _restoreFromCloud(context);
            },
            child: const Text("Yes, Restore"),
          ),
        ],
      );
    },
  );
}

Future<void> _restoreFromCloud(BuildContext context) async {
  try {
    // Optional: show loader

    await SupabaseService.fullDownloadSync();

              Navigator.pop(context);


    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("✅ Data restored from cloud")),
    );
  } catch (e) {

              Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("❌ Error: $e")),
    );
  }
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


            SyncButton(),

            SizedBox(height: 12,),

            ElevatedButton(
  onPressed: () {
    _showRestoreDialog(context);
  },
  child: const Text("Restore from Cloud"),
),




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

            SizedBox(height: 12,),
            Text("Top learnings of the month", style: TextStyle(fontSize: 18)),

            Container(
              child: ValueListenableBuilder(
                valueListenable: Hive.box('monthlyLearningsBox').listenable(),
                builder: (context, Box box, _) {
                  if (box.isEmpty) {
                    return const Center(
                      child: Text("No learnings added yet 🚀"),
                    );
                  }

                  final learnings = box.values.toList();
                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: learnings.length,
                      itemBuilder: (context, index) {
                        final monthData = learnings[index];
                        final month = monthData["month"];
                        final points = List<String>.from(monthData["learnings"]);
                       
                    
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
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {


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
