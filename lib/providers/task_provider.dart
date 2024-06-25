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
