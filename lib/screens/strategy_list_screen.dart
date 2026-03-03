import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter_journal/database/hive_service.dart';
import 'package:flutter_journal/widgets/add_strategy_widget.dart';
import 'package:flutter_journal/widgets/image_preview_dialog.dart';

class StrategyListScreen extends StatefulWidget {
  List<dynamic> entries = [];
  StrategyListScreen(this.entries);

  @override
  State<StrategyListScreen> createState() => _StrategyListScreenState();
}

class _StrategyListScreenState extends State<StrategyListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => AddStrategySheet(() {}),
          );

          if (result == true) {
            setState(() {
              widget.entries = HiveService.strategyBox.values.toList();
            });
          }
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(title: const Text("Strategies")),
      body: ListView.builder(
        itemCount: widget.entries.length,
        itemBuilder: (context, index) {
          final e = widget.entries[index];

          return Card(
            child: ListTile(
              leading: e['referenceImage64'] != ""
                  ? GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => ImagePreviewDialog(
                            base64Image: e['referenceImage64'],
                          ),
                        );
                      },
                      child: Image.memory(
                        base64Decode(e['referenceImage64']),
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Icon(Icons.image),

              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(e['name'], style: TextStyle(fontSize: 18)),
                  SizedBox(height: 12),
                  ...e["concepts"].map(
                    (point) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("• ", style: TextStyle(fontSize: 16)),
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

              trailing: IconButton(
                onPressed: () async {
                  _showDeleteDialog(context, index);
                },
                icon: Icon(Icons.delete),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _showDeleteDialog(BuildContext context, int index) async {
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
      await HiveService.deleteStrategy(index);

      setState(() {
        widget.entries = HiveService.strategyBox.values.toList();
      });
    }
  }
}
