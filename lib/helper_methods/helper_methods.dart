import 'package:flutter/material.dart';

class HelperMethods {
  static void showMyDialog(
    String title,
    String description,
    BuildContext context,
  ) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: Container(
          width: 300,
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: TextStyle(fontSize: 18)),
              Text(description),
            ],
          ),
        ),
      ),
    );
  }
}
