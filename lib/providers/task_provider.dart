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
import 'package:beekeeping_management/models/task.dart';
import 'package:beekeeping_management/repository/local_storage_repository.dart';

class TaskProvider with ChangeNotifier {
  final LocalStorageRepository _repository = LocalStorageRepository();
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  TaskProvider() {
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    _tasks = await _repository.getTasks();
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    _tasks.add(task);
    await _repository.saveTasks(_tasks);
    notifyListeners();
  }
}
