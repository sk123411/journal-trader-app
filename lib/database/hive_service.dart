import 'package:hive/hive.dart';

class HiveService {
  static final journalBox = Hive.box('journalBox');
  static final monthlyLearningsBox = Hive.box('monthlyLearningsBox');

  /// ------------------ Journal ------------------

  static Future addEntry(Map<String, dynamic> entry) async {
    await journalBox.add(entry);
  }

  static List<Map<String, dynamic>> getEntries() {
    return journalBox.values
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  static Future deleteEntry(int index) async {
    await journalBox.deleteAt(index);
  }

  /// ------------------ Monthly Learnings ------------------

  static Future addMonthlyLearning(String month, List<String> learnings) async {
    await monthlyLearningsBox.put(month, {
      "month": month,
      "learnings": learnings,
    });
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
}