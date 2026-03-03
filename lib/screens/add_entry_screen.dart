import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_journal/database/hive_service.dart';
import 'package:flutter_journal/widgets/image_preview_dialog.dart';
import 'package:flutter_journal/widgets/strategy_dropdown.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:typed_data';

import '../models/journal_entry.dart';

class AddEntryScreen extends StatefulWidget {
  const AddEntryScreen({super.key});

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  final biasController = TextEditingController();
  final conceptsController = TextEditingController();
  final mistakesController = TextEditingController();
    final instrumentController = TextEditingController();
    final strategyController = TextEditingController();

Uint8List? imageBytes;
String? imageBase64;

  DateTime selectedDate = DateTime.now();
  String result = "win";
  File? imageFile;


  pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDate: selectedDate,
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
    }
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

saveEntry() async {
  final entry = {
      "id": DateTime.now().millisecondsSinceEpoch.toString(),

    "date": DateFormat('yyyy-MM-dd').format(selectedDate),
    "bias": biasController.text,
    "concepts": conceptsController.text,
        "strategy": strategyController.text,

    "mistakes": mistakesController.text,
        "instrument": instrumentController.text,

    "imageBase64": imageBase64 ?? "",
    "result": result,
  };

  await HiveService.addEntry(entry);
    await HiveService.addEntryToMonth(entry);
    Navigator.pop(context);

}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Journal Entry")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [

            // Date
            ListTile(
              title: Text(
                "Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}"),
              trailing: const Icon(Icons.calendar_today),
              onTap: pickDate,
            ),
   TextField(
              controller: instrumentController,
              decoration: const InputDecoration(labelText: "Instrument"),
            ),
            TextField(
              controller: biasController,
              decoration: const InputDecoration(labelText: "Bias"),
            ),

            TextField(
              controller: conceptsController,
              decoration: const InputDecoration(labelText: "Concepts Used"),
            ),

            TextField(
              controller: mistakesController,
              decoration: const InputDecoration(labelText: "Mistakes"),
              maxLines: 3,
            ),
            const SizedBox(height: 10),

            StrategyDropdown((strategy) {

                strategyController.text = strategy;
            }),
            const SizedBox(height: 10),

            DropdownButtonFormField(
              value: result,
              items: const [
                DropdownMenuItem(value: "win", child: Text("Win")),
                DropdownMenuItem(value: "loss", child: Text("Loss")),
                DropdownMenuItem(value: "breakeven", child: Text("Breakeven")),
              ],
              onChanged: (v) => setState(() => result = v.toString()),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: pickImage,
              child: const Text("Pick Chart Image"),
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


            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: saveEntry,
              child: const Text("Save Entry"),
            ),
          ],
        ),
      ),
    );
  }
}
