import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class ImagePreviewDialog extends StatelessWidget {
  final String base64Image;

  const ImagePreviewDialog({super.key, required this.base64Image});

  @override
  Widget build(BuildContext context) {
    Uint8List bytes = base64Decode(base64Image);

    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: Colors.black,
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
          ),
          Image.memory(bytes),
        ],
      ),
    );
  }
}
