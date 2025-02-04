import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beekeeping_management/providers/hive_provider.dart';
import 'package:beekeeping_management/providers/task_provider.dart';
import 'package:intl/intl.dart';
import 'package:beekeeping_management/models/task.dart';
import 'package:beekeeping_management/models/tag.dart';

import '../providers/tag_provider.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Контролна Табла'),
      ),
      body: Consumer2<HiveProvider, TaskProvider>(
        builder: (context, hiveProvider, taskProvider, child) {
          final hivesWithTasks = hiveProvider.hives.where((hive) {
            return taskProvider.tasks.any((task) =>
            task.hiveId == hive.id &&
                (task.dueDate.isAtSameMomentAs(DateTime.now()) ||
                    (task.dueDate.isBefore(DateTime.now()) && !task.completed)));
          }).toList();

          String currentDate = DateFormat.yMMMMd().format(DateTime.now());

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Денешен Датум: $currentDate',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: hivesWithTasks.isEmpty
                    ? Center(
                  child: Text(
                    'Нема задачи за денес',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
                    : ListView.builder(
                  itemCount: hivesWithTasks.length,
                  itemBuilder: (context, index) {
                    final hive = hivesWithTasks[index];
                    final tasksForToday = taskProvider.tasks.where((task) =>
                    task.hiveId == hive.id &&
                        (task.dueDate.isAtSameMomentAs(DateTime.now()) ||
                            (task.dueDate.isBefore(DateTime.now()) && !task.completed))).toList();

                    return Card(
                      margin: EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 4,
                      child: Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Сандук ${hive.number}',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                ...tasksForToday.map((task) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: ListTile(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      title: Text(
                                        task.title,
                                        style: TextStyle(
                                            color: Colors.grey[800],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 5),
                                          Text(
                                            'Опис:',
                                            style: TextStyle(
                                                color: Colors.grey[800],
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                          ),
                                          Text(
                                            task.description ?? '',
                                            style: TextStyle(color: Colors.grey[700]),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            'Краен рок:',
                                            style: TextStyle(
                                                color: Colors.grey[800],
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                          ),
                                          Text(
                                            DateFormat.yMd().add_jm().format(task.dueDate),
                                            style: TextStyle(color: Colors.grey[700]),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            'Категорија:',
                                            style: TextStyle(
                                                color: Colors.grey[800],
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                          ),
                                          Text(
                                            Provider.of<TagProvider>(context)
                                                .tags
                                                .firstWhere((tag) => tag.id == task.tagId,
                                                orElse: () => Tag(id: 0, name: 'Без категорија'))
                                                .name,
                                            style: TextStyle(color: Colors.grey[700]),
                                          ),
                                        ],
                                      ),
                                      onTap: () => _showTaskDetailsDialog(context, task, taskProvider),
                                    ),
                                  ),
                                )),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: CircleAvatar(
                              backgroundColor: tasksForToday.any((task) => task.completed)
                                  ? Colors.green
                                  : Colors.red,
                              radius: 10,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showTaskDetailsDialog(BuildContext context, Task task, TaskProvider taskProvider) {
    final TextEditingController _noteController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            task.title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Опис: ${task.description ?? ''}'),
              Text('Краен рок: ${DateFormat.yMd().add_jm().format(task.dueDate)}'),
              TextField(
                controller: _noteController,
                decoration: InputDecoration(labelText: 'Белешка'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Откажи'),
            ),
            TextButton(
              onPressed: () {
                taskProvider.updateTask(
                  Task(
                    id: task.id,
                    title: task.title,
                    description: task.description,
                    dueDate: task.dueDate,
                    hiveId: task.hiveId,
                    tagId: task.tagId,
                    completed: true,
                  ),
                );
                Navigator.pop(context);
              },
              child: Text('Заврши'),
            ),
            TextButton(
              onPressed: () {
                final newTask = Task(
                  id: DateTime.now().millisecondsSinceEpoch,
                  title: task.title,
                  description: task.description,
                  dueDate: task.dueDate,
                  hiveId: task.hiveId,
                  tagId: task.tagId,
                  completed: false,
                );
                taskProvider.addTask(newTask);
                Navigator.pop(context);
              },
              child: Text('Отвори дупликат'),
            ),
          ],
        );
      },
    );
  }
}
