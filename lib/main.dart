import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beekeeping_management/providers/hive_provider.dart';
import 'package:beekeeping_management/providers/task_provider.dart';
import 'package:beekeeping_management/providers/tag_provider.dart';
import 'package:beekeeping_management/screens/hive_screen.dart';
import 'package:beekeeping_management/screens/task_screen.dart';
import 'package:beekeeping_management/screens/tag_screen.dart';
import 'package:beekeeping_management/screens/dashboard_screen.dart';

void main() {
  runApp(BeekeepingApp());
}

class BeekeepingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HiveProvider()..fetchHives()),
        ChangeNotifierProvider(create: (context) => TaskProvider()..fetchTasks()),
        ChangeNotifierProvider(create: (context) => TagProvider()..fetchTags()),
      ],
      child: MaterialApp(
        title: 'Beekeeping Management',
        theme: ThemeData(
          primarySwatch: Colors.yellow,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/dashboard',
        routes: {
          '/': (context) => HiveScreen(),
          '/tasks': (context) => TaskScreen(),
          '/tags': (context) => TagScreen(),
          '/dashboard': (context) => DashboardScreen(),
        },
      ),
    );
  }
}
