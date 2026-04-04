// ui/sync_button.dart

import 'package:flutter/material.dart';
import 'package:flutter_journal/auth_service.dart';
import 'package:flutter_journal/database/hive_service.dart';
import 'package:flutter_journal/database/supabase_service.dart';
import 'package:flutter_journal/login_screen.dart';

class SyncButton extends StatefulWidget {
  const SyncButton({super.key});

  @override
  State<SyncButton> createState() => _SyncButtonState();
}

class _SyncButtonState extends State<SyncButton> {
  bool isSyncing = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isSyncing
          ? null
          : () async {
              setState(() => isSyncing = true);

              try {
               if (AuthService.isLoggedIn) {
  final entries = HiveService.getEntries();
  final strategies = HiveService.getStrategies();
  await SupabaseService.uploadJournalEntriesBulk(entries);
  await SupabaseService.uploadStrategiesBulk(strategies);

   ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Sync completed")),
                );
}else{

  Navigator.push(context, MaterialPageRoute(builder: (c)=>LoginScreen()));

}
               
              } catch (e) {
                print(e);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Sync failed: $e")),
                );
              }

              setState(() => isSyncing = false);
            },
      child: isSyncing
          ? const CircularProgressIndicator()
          : const Text("Sync Now"),
    );
  }
}