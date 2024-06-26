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
