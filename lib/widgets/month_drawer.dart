import 'package:flutter/material.dart';
import 'package:flutter_journal/database/hive_service.dart';
import 'package:intl/intl.dart';

class MonthDrawer extends StatelessWidget {

  Function(String month)? onTapMonth;

   MonthDrawer({this.onTapMonth});

@override
Widget build(BuildContext context) {
final grouped = HiveService.getEntriesGroupedByMonth();

final months = grouped.keys.toList()
  ..sort((a, b) {
    final dateA = DateFormat('MMMM yyyy').parse(a);
    final dateB = DateFormat('MMMM yyyy').parse(b);
    return dateB.compareTo(dateA); // latest first
  });
  return Drawer(
    child: ListView(
      children: [
        const DrawerHeader(
          child: Text(
            "Months",
            style: TextStyle(fontSize: 20),
          ),
        ),

        ...months.map((month) {
          return ListTile(
            title: Text(month.toString()),
            onTap: () {
              onTapMonth?.call(month.toString());
              Navigator.pop(context);

              print("Selected: $month");
            },
          );
        }).toList(),
      ],
    ),
  );
}
}