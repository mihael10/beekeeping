import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beekeeping_management/models/hive.dart';
import 'package:beekeeping_management/providers/task_provider.dart';
import 'package:beekeeping_management/providers/tag_provider.dart';
import 'package:beekeeping_management/models/task.dart';

class HiveDetailScreen extends StatelessWidget {
  final Hive hive;

  HiveDetailScreen({required this.hive});

  @override
  Widget build(BuildContext context) {
    final _taskTitleController = TextEditingController();
    final _taskDescriptionController = TextEditingController();
    final _taskDueDateController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    int? _selectedTagId;

    return Scaffold(
      appBar: AppBar(
        title: Text('Сандук ${hive.number} Детали'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Име: ${hive.name}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Опис: ${hive.description}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 16),
              Text('Работни Задачи:', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              Consumer<TaskProvider>(
                builder: (context, taskProvider, child) {
                  final hiveTasks = taskProvider.tasks.where((task) => task.hiveId == hive.id).toList();
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: hiveTasks.length,
                    itemBuilder: (context, index) {
                      final task = hiveTasks[index];
                      return Card(
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          title: Text(task.title),
                          subtitle: Text(task.dueDate.toIso8601String()),
                        ),
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _taskTitleController,
                      decoration: InputDecoration(
                        labelText: 'Наслов на работната задача',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Внеси наслов на работната задача';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _taskDescriptionController,
                      decoration: InputDecoration(
                        labelText: 'Опис',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _taskDueDateController,
                      decoration: InputDecoration(
                        labelText: 'Датум',
                        border: OutlineInputBorder(),
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          _taskDueDateController.text = pickedDate.toIso8601String();
                        }
                      },
                    ),
                    SizedBox(height: 10),
                    Consumer<TagProvider>(
                      builder: (context, tagProvider, child) {
                        return DropdownButtonFormField<int>(
                          value: _selectedTagId,
                          decoration: InputDecoration(
                            labelText: 'Селектирај категорија',
                            border: OutlineInputBorder(),
                          ),
                          items: tagProvider.tags.map((tag) {
                            return DropdownMenuItem<int>(
                              value: tag.id,
                              child: Text(tag.name),
                            );
                          }).toList(),
                          onChanged: (value) {
                            _selectedTagId = value;
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Селектирај категорија';
                            }
                            return null;
                          },
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate() && _taskDueDateController.text.isNotEmpty) {
                          final task = Task(
                            id: DateTime.now().millisecondsSinceEpoch,
                            title: _taskTitleController.text,
                            description: _taskDescriptionController.text,
                            dueDate: DateTime.parse(_taskDueDateController.text),
                            hiveId: hive.id,
                            tagId: _selectedTagId,
                          );
                          Provider.of<TaskProvider>(context, listen: false).addTask(task);
                          _taskTitleController.clear();
                          _taskDescriptionController.clear();
                          _taskDueDateController.clear();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Успешно додадена категорија!')));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Селектирај датум на краен рок за извршеток на задачата')));
                        }
                      },
                      child: Text('Додади Задача'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
