import 'package:flutter/material.dart';
import 'package:flutter_journal/database/hive_service.dart';

class StrategyDropdown extends StatefulWidget {

  Function(String strategy) setSelectedStrategy;
   StrategyDropdown(this.setSelectedStrategy);

  @override
  State<StrategyDropdown> createState() => _StrategyDropdownState();
}

class _StrategyDropdownState extends State<StrategyDropdown> {
  List<String> strategies = [];
  String? selectedStrategy;

  @override
  void initState() {
    super.initState();
    loadStrategies();
  }

  void loadStrategies() {
    strategies = HiveService.getStrategiesNameOnly();
    setState(() {});
  }
  
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedStrategy,
      decoration: const InputDecoration(
        labelText: "Select Strategy",
        border: OutlineInputBorder(),
      ),
      items: strategies.map((strategy) {
        return DropdownMenuItem<String>(
          value: strategy,
          child: Text(strategy),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedStrategy = value;
        });

        widget.setSelectedStrategy(value!);

        print("Selected Strategy: $selectedStrategy");
      },
    );
  }


  }