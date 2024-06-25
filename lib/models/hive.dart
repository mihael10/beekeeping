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


import 'package:beekeeping_management/models/task.dart';

class Hive {
  int id;
  int number;
  String name;
  String? description;
  List<Task> tasks; // Add this line to include tasks

  Hive({
    required this.id,
    required this.number,
    required this.name,
    this.description,
    this.tasks = const [],
  });

  // Add the fromJson and toJson methods to include tasks
  factory Hive.fromJson(Map<String, dynamic> json) {
    return Hive(
      id: json['id'],
      number: json['number'],
      name: json['name'],
      description: json['description'],
      tasks: (json['tasks'] as List).map((task) => Task.fromJson(task)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'number': number,
      'name': name,
      'description': description,
      'tasks': tasks.map((task) => task.toJson()).toList(),
    };
  }
}
