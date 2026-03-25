import 'package:flutter/material.dart';
import 'package:flutter_journal/database/hive_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/dashboard_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await HiveService.loadBoxes();
await Supabase.initialize(
  url: 'https://akzumtbohcpjfhfvzlmg.supabase.co',
  anonKey: 'sb_publishable_z8nsbBoIeMB84TUyxFvi7g_ZoYCRt4r',
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const DashboardScreen(),
    );
  }

}
