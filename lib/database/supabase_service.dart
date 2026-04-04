import 'package:flutter_journal/database/hive_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class SupabaseService {
  static final _client = Supabase.instance.client;

static final uuid = Uuid();
  /// Upload all journal entries (Sync Now)
 static Future<void> uploadJournalEntriesBulk(
    List<Map<String, dynamic>> entries) async {
  final user = _client.auth.currentUser;

  if (user == null) {
    throw Exception("User not logged in");
  }

  final data = entries.map((entry) {
    return {
      'id':  entry['id'],
      'user_id': user.id,
      'date': entry['date'],
      'bias': entry['bias'],
      'result': entry['result'],
      'instrument': entry['instrument'],
      'concepts': entry['concepts'],
      'mistakes': entry['mistakes'],
      'imageBase64': entry['imageBase64'],
    };
  }).toList();

  await _client.from('journal_entries').upsert(data);
}


static Future<void> uploadStrategiesBulk(
    List<Map<String, dynamic>> strategies) async {
  final user = Supabase.instance.client.auth.currentUser;

  if (user == null) {
    throw Exception("User not logged in");
  }

  final data = strategies.map((strategy) {
    return {
      'id': strategy['id'], // ✅ SAME ID (no new UUID)
      'user_id': user.id,
      'name': strategy['name'],
      'concepts': strategy['concepts'], // List → works as JSON
      'reference_image64': strategy['referenceImage64'],
    };
  }).toList();

  await Supabase.instance.client
      .from('strategies')
      .upsert(
        data,
        onConflict: 'id', // 🔥 prevents duplicates
      );
}



static Future<void> downloadJournalEntries() async {
  final user = Supabase.instance.client.auth.currentUser;

  if (user == null) {
    throw Exception("User not logged in");
  }

  final response = await Supabase.instance.client
      .from('journal_entries')
      .select()
      .eq('user_id', user.id);

  // 🔥 Clear local Hive first (simple sync)
  await HiveService.journalBox.clear();

  for (var item in response) {
    final entry = {
      'id': item['id'],
      'date': item['date'],
      'bias': item['bias'],
      'result': item['result'],
      'instrument': item['instrument'],
      'concepts': item['concepts'],
      'mistakes': item['mistakes'],
      'imageBase64': item['imageBase64'],
    };

    await HiveService.journalBox.add(entry);
  }

  print("✅ Journal entries downloaded");
}




static Future<void> downloadStrategies() async {
  final user = Supabase.instance.client.auth.currentUser;

  if (user == null) {
    throw Exception("User not logged in");
  }

  final response = await Supabase.instance.client
      .from('strategies')
      .select()
      .eq('user_id', user.id);

  // 🔥 Clear local Hive
  await HiveService.strategyBox.clear();

  for (var item in response) {
    final strategy = {
      'id': item['id'],
      'name': item['name'],
      'concepts': List<String>.from(item['concepts'] ?? []),
      'referenceImage64': item['reference_image64'],
    };

    await HiveService.strategyBox.add(strategy);
  }

  print("✅ Strategies downloaded");
}


static Future<void> fullDownloadSync() async {
  await downloadJournalEntries();
  await downloadStrategies();
}



}