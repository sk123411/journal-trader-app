import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class HiveService {
  static final journalBox = Hive.box('journalBox');
    static final monthlyJournalBox = Hive.box('monthlyJournalBox');
    static final strategyBox = Hive.box('strategyBox');

  static final monthlyLearningsBox = Hive.box('monthlyLearningsBox');

  /// ------------------ Journal ------------------

  static Future addEntry(Map<String, dynamic> entry) async {
    await journalBox.add(entry);
  }
   static Future clearboxes() async {
    journalBox.clear();
    monthlyJournalBox.clear();
    monthlyLearningsBox.clear();
  }

static Future addEntryToMonth(
    Map<String, dynamic> entry) async {

  // ✅ Get month from entry date
  final date = DateTime.parse(entry['date']);

  final monthKey =
      "${_monthName(date.month)} ${date.year}";

  final existing =
      monthlyJournalBox.get(monthKey, defaultValue: []);

  final entries = List<Map<String, dynamic>>.from(
    (existing as List).map(
      (e) => Map<String, dynamic>.from(e),
    ),
  );

  entries.add(entry);

  await monthlyJournalBox.put(monthKey, entries);
}

static String _monthName(int month) {
  const months = [
    '', 'January', 'February', 'March', 'April',
    'May', 'June', 'July', 'August',
    'September', 'October', 'November', 'December'
  ];
  return months[month];
}

  static Future deleteEntryEverywhere(String id) async {
  // 1️⃣ Delete from journalBox
  final journalData = journalBox.values.toList();

  final journalIndex = journalData.indexWhere(
    (e) => e['id'] == id,
  );

  if (journalIndex != -1) {
    await journalBox.deleteAt(journalIndex);
  }

  // 2️⃣ Delete from monthlyJournalBox
  final months = monthlyJournalBox.keys.toList();

  for (var month in months) {
    final data = monthlyJournalBox.get(month);

    if (data == null) continue;

    final entries = List<Map<String, dynamic>>.from(
      data.map((e) => Map<String, dynamic>.from(e)),
    );

    entries.removeWhere((e) => e['id'] == id);

    if (entries.isEmpty) {
      await monthlyJournalBox.delete(month);
    } else {
      await monthlyJournalBox.put(month, entries);
    }
  }
}

static Future addMonthlyData() async {
  monthlyJournalBox.clear();
  final currentMonth = getCurrentMonth();
  final data = getEntries();

  await monthlyJournalBox.put(currentMonth, data);
}

  static getCurrentMonth() {
    final now = DateTime.now();
  return DateFormat('MMMM yyyy').format(now);
  }
 static List<Map<String, dynamic>> getEntriesByMonth() {
    return monthlyJournalBox.values
        .map((e) => Map<String, dynamic>.from(e))
        .toList();

  }

//   static List<Map<String, dynamic>> getEntriesByMonth(String monthKey) {
//   final data = monthlyJournalBox.get(monthKey);

//   if (data == null) return [];

//   return List<Map<String, dynamic>>.from(
//     data.map((e) => Map<String, dynamic>.from(e)),
//   );
// }

  static List<Map<String, dynamic>> getEntries() {
    return journalBox.values
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }


  static List<Map<String, dynamic>> getStrategies() {
    return strategyBox.values
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

static List<String> getStrategiesNameOnly() {
  return strategyBox.values
      .where((e) => e['name'] != null && e['name'].toString().isNotEmpty)
      .map((e) => e['name'].toString())
      .toList();
}

  static Future deleteEntry(int index) async {
    await journalBox.deleteAt(index);
  }


  static Future deleteStrategy(int index) async {
    await strategyBox.deleteAt(index);
  }

  static Future deleteEntryFromMonth(
    String monthKey,
    int index,
) async {
  final data = monthlyJournalBox.get(monthKey);

  if (data == null) return;

  final entries = List<Map<String, dynamic>>.from(
    data.map((e) => Map<String, dynamic>.from(e)),
  );

  if (index < 0 || index >= entries.length) return;

  entries.removeAt(index);

  // If month becomes empty → remove month completely
  if (entries.isEmpty) {
    await monthlyJournalBox.delete(monthKey);
  } else {
    await monthlyJournalBox.put(monthKey, entries);
  }
}

  /// ------------------ Monthly Learnings ------------------

  static Future addMonthlyLearning(String month, List<String> learnings) async {
    await monthlyLearningsBox.put(month, {
      "month": month,
      "learnings": learnings,
    });
  }

    static Future addStrategy(Map<String, dynamic> strategy) async {
    await strategyBox.add(strategy);
  }

  static List<Map<String, dynamic>> getAllMonthlyLearnings() {
    return monthlyLearningsBox.values
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  static Map<String, dynamic>? getMonthlyLearning(String month) {
    final data = monthlyLearningsBox.get(month);
    if (data == null) return null;
    return Map<String, dynamic>.from(data);
  }

  static Future deleteMonthlyLearning(String month) async {
    await monthlyLearningsBox.delete(month);
  }




static Future insertTestData() async {
  await monthlyJournalBox.clear();

  final entry1 = {
    "id": "1",
    "date": "2026-03-05",
    "bias": "bullish",
    "concepts": "test",
    "mistakes": "none",
    "instrument": "NIFTY",
    "imageBase64": "",
    "result": "win",
  };

  final entry2 = {
    "id": "2",
    "date": "2026-04-02",
    "bias": "bearish",
    "concepts": "test2",
    "mistakes": "late entry",
    "instrument": "BANKNIFTY",
    "imageBase64": "",
    "result": "loss",
  };

    final entry3 = {
    "id": "3",
    "date": "2026-04-04",
    "bias": "bearish",
    "concepts": "test2",
    "mistakes": "late entry",
    "instrument": "BANKNIFTY",
    "imageBase64": "",
    "result": "loss",
  };



    final entry4 = {
    "id": "4",
    "date": "2026-04-04",
    "bias": "bullish",
    "concepts": "test2",
    "mistakes": "late entry",
    "instrument": "BANKNIFTY",
    "imageBase64": "",
    "result": "loss",
  };

  await addEntryToMonth(entry1);
  await addEntryToMonth(entry2);
    await addEntryToMonth(entry3);
  await addEntryToMonth(entry4);

}







}