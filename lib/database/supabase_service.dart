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
      'id':  uuid.v4(),
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

}