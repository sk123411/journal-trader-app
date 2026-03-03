import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_journal/database/hive_service.dart';
import 'package:flutter_journal/widgets/image_preview_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddStrategySheet extends StatefulWidget {
  Function? onSave;
   AddStrategySheet(this.onSave);

  @override
  State<AddStrategySheet> createState() =>
      _AddMonthlyLearningSheetState();
}

class _AddMonthlyLearningSheetState
    extends State<AddStrategySheet> {
      Uint8List? imageBytes;
String? imageBase64;



  final List<TextEditingController> _controllers = [
    TextEditingController()
  ];
  TextEditingController strategyNameController = TextEditingController();

  String getCurrentMonth() {
    final now = DateTime.now();
  return DateFormat('MMMM yyyy').format(now);
  }

pickImage() async {
  final picked = await ImagePicker().pickImage(source: ImageSource.gallery);

  if (picked != null) {
    final bytes = await picked.readAsBytes();
    setState(() {
      imageBytes = bytes;
      imageBase64 = base64Encode(bytes);
    });
  }
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

    if (learnings.isEmpty) return;



   final entry = {
      // "id": DateTime.now().millisecondsSinceEpoch.toString(),
    "concepts": learnings,
    "name":strategyNameController.text,
    "referenceImage64": imageBase64,
  };

  await HiveService.addStrategy(entry);
  widget.onSave?.call;

    Navigator.pop(context,true);
  
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
              "Add New Strategy",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

             TextField(
                  controller: strategyNameController,
                  decoration: const InputDecoration(
                    labelText: "Strategy Name",
                    border: OutlineInputBorder(),
                  ),
                ),
            const SizedBox(height: 12),

            /// Dynamic Learning Fields
            ..._controllers.map(
              (controller) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    labelText: "Add Concept Point",
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

            const SizedBox(height: 8),



              ElevatedButton(
              onPressed: pickImage,
              child: const Text("Pick Reference Image"),
            ),

if (imageBytes != null)
  GestureDetector(
    onTap: () {
      showDialog(
        context: context,
        builder: (_) => ImagePreviewDialog(
          base64Image: imageBase64!,
        ),
      );
    },
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: Image.memory(imageBytes!, height: 200),
    ),
  ),
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