class Task {
  final int id;
  late final String title;
  late final String? description;
  late final DateTime dueDate;
  late final int hiveId;
  late final int? tagId;
  final bool completed;

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.dueDate,
    required this.hiveId,
    this.tagId,
    this.completed = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'hiveId': hiveId,
      'tagId': tagId,
      'completed': completed,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dueDate: DateTime.parse(json['dueDate']),
      hiveId: json['hiveId'],
      tagId: json['tagId'],
      completed: json['completed'],
    );
  }
}
