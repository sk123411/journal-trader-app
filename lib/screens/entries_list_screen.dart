import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter_journal/database/hive_service.dart';
import 'package:flutter_journal/screens/add_entry_screen.dart';
import 'package:flutter_journal/widgets/image_preview_dialog.dart';

class EntriesListScreen extends StatefulWidget {
  List<dynamic> entries = [];
  String currentMonth;
  EntriesListScreen(this.entries, this.currentMonth);

  @override
  State<EntriesListScreen> createState() => _EntriesListScreenState();
}

class _EntriesListScreenState extends State<EntriesListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
         await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AddEntryScreen()),
                );

            setState(() {
              widget.entries = HiveService.monthlyJournalBox.get(widget.currentMonth).toList();
            });
          
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(title: const Text("Journal Entries")),
      body: ListView.builder(
        itemCount: widget.entries.length,
        itemBuilder: (context, index) {
          final e = widget.entries[index];

          return Card(
            color: e['result'] == "win"
                ? Colors.green.shade300
                : e['result'] == "loss"
                ? Colors.red.shade300
                : null,
            child: ListTile(
              leading: e['imageBase64'] != ""
                  ? GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) =>
                              ImagePreviewDialog(base64Image: e['imageBase64']),
                        );
                      },
                      child: Image.memory(
                        base64Decode(e['imageBase64']),
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Icon(Icons.image),

              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Instrument: ${e['instrument']}",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),

                  Text("Bias: ${e['bias']}"),
                  Text("Concepts Used: ${e['concepts']}"),

                  Text("Mistakes: ${e['mistakes']}"),
                  Text("Strategy: ${e['strategy']}"),
                ],
              ),
              subtitle: Text("${e['date']} | ${e['result']}"),
              trailing: IconButton(
                onPressed: () async {
                  _showDeleteDialog(context, e['id']);
                },
                icon: Icon(Icons.delete),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _showDeleteDialog(BuildContext context, String id) async {
    final bool? confirmDelete = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Entry"),
          content: const Text(
            "Are you sure you want to delete this entry? This action cannot be undone.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      await HiveService.deleteEntryEverywhere(id);

      setState(() {
        widget.entries =
            HiveService.monthlyJournalBox.get(widget.currentMonth) ?? [];
      });
    }
  }
}
