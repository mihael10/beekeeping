/*
 * This file is part of Beekeeping Management.
 *
 * Beekeeping Management is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Beekeeping Management is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Beekeeping Management. If not, see <http://www.gnu.org/licenses/>.
 *
 * Author: Mihael Josifovski
 * Copyright 2024 Mihael Josifovski
 */


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beekeeping_management/providers/hive_provider.dart';
import 'package:beekeeping_management/providers/task_provider.dart';
import 'package:beekeeping_management/providers/tag_provider.dart';
import 'package:beekeeping_management/screens/hive_screen.dart';
import 'package:beekeeping_management/screens/task_screen.dart';
import 'package:beekeeping_management/screens/tag_screen.dart';

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
        initialRoute: '/',
        routes: {
          '/': (context) => HiveScreen(),
          '/tasks': (context) => TaskScreen(),
          '/tags': (context) => TagScreen(),
        },
      ),
    );
  }
}
