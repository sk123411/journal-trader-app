import 'package:flutter/material.dart';
import 'package:flutter_journal/database/hive_service.dart';
import 'package:flutter_journal/helper_methods/helper_methods.dart';
import 'package:intl/intl.dart';

class AddMonthlyLearningSheet extends StatefulWidget {
  const AddMonthlyLearningSheet({Key? key}) : super(key: key);

  @override
  State<AddMonthlyLearningSheet> createState() =>
      _AddMonthlyLearningSheetState();
}

class _AddMonthlyLearningSheetState
    extends State<AddMonthlyLearningSheet> {
  final List<TextEditingController> _controllers = [
    TextEditingController()
  ];

  String getCurrentMonth() {
    final now = DateTime.now();
  return DateFormat('MMMM yyyy').format(now);
  }

  void _addField() {
    setState(() {
      _controllers.add(TextEditingController());
    });
  }

  void _save() async {
    final learnings = _controllers
        .map((c) => c.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();

 if (learnings.isEmpty) {
      HelperMethods.showMyDialog(
        "Point Missing",
        "Please add minimum one learning point",
        context,
      );

      return;
 }

    await HiveService.addMonthlyLearning(
      getCurrentMonth(),
      learnings,
    );

    Navigator.pop(context);
  
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Add Monthly Learnings",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            /// Dynamic Learning Fields
            ..._controllers.map(
              (controller) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    labelText: "Learning Point",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            /// Add More Button
            TextButton.icon(
              onPressed: _addField,
              icon: const Icon(Icons.add),
              label: const Text("Add Another Point"),
            ),

            const SizedBox(height: 20),

            /// Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                child: const Text("Save"),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}