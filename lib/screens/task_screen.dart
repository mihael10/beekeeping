import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beekeeping_management/models/task.dart';
import 'package:beekeeping_management/providers/task_provider.dart';
import 'package:beekeeping_management/providers/hive_provider.dart';
import 'package:beekeeping_management/providers/tag_provider.dart';

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dueDateController = TextEditingController();
  int? _selectedHiveId;
  int? _selectedTagId;
  bool _isAddingTask = false;

  void _editTask(BuildContext context, Task task) {
    final _editTitleController = TextEditingController(text: task.title);
    final _editDescriptionController = TextEditingController(text: task.description);
    final _editDueDateController = TextEditingController(text: task.dueDate.toIso8601String());
    int? _editSelectedHiveId = task.hiveId;
    int? _editSelectedTagId = task.tagId;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Промени задача'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _editTitleController,
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
                  controller: _editDescriptionController,
                  decoration: InputDecoration(
                    labelText: 'Опис',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _editDueDateController,
                  decoration: InputDecoration(
                    labelText: 'Краен рок',
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
                      _editDueDateController.text = pickedDate.toIso8601String();
                    }
                  },
                ),
                SizedBox(height: 10),
                Consumer<HiveProvider>(
                  builder: (context, hiveProvider, child) {
                    return DropdownButtonFormField<int>(
                      value: _editSelectedHiveId,
                      decoration: InputDecoration(
                        labelText: 'Селектирај сандук',
                        border: OutlineInputBorder(),
                      ),
                      items: hiveProvider.hives.map((hive) {
                        return DropdownMenuItem<int>(
                          value: hive.id,
                          child: Text('Сандук ${hive.number}: ${hive.name}'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _editSelectedHiveId = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Селектирај сандук';
                        }
                        return null;
                      },
                    );
                  },
                ),
                SizedBox(height: 10),
                Consumer<TagProvider>(
                  builder: (context, tagProvider, child) {
                    return DropdownButtonFormField<int>(
                      value: _editSelectedTagId,
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
                        setState(() {
                          _editSelectedTagId = value;
                        });
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
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Откажи'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  task.title = _editTitleController.text;
                  task.description = _editDescriptionController.text;
                  task.dueDate = DateTime.parse(_editDueDateController.text);
                  task.hiveId = _editSelectedHiveId!;
                  task.tagId = _editSelectedTagId;
                  Provider.of<TaskProvider>(context, listen: false).updateTask(task);
                  Navigator.pop(context);
                }
              },
              child: Text('Промени'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, int taskId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Избриши задача'),
          content: Text('Дали сте сигурни дека сакате да ја избришете задачата?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Откажи'),
            ),
            ElevatedButton(
              onPressed: () {
                Provider.of<TaskProvider>(context, listen: false).deleteTask(taskId as Task);
                Navigator.pop(context);
              },
              child: Text('Избриши'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Работни Задачи'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<TaskProvider>(
              builder: (context, provider, child) {
                return ListView.builder(
                  itemCount: provider.tasks.length,
                  itemBuilder: (context, index) {
                    final task = provider.tasks[index];
                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(task.title, style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          '${task.description ?? ''}\nДата: ${task.dueDate.toIso8601String()}',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _editTask(context, task),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _confirmDelete(context, task.id),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          if (_isAddingTask)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleController,
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
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Опис',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _dueDateController,
                      decoration: InputDecoration(
                        labelText: 'Краен рок',
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
                          _dueDateController.text = pickedDate.toIso8601String();
                        }
                      },
                    ),
                    SizedBox(height: 10),
                    Consumer<HiveProvider>(
                      builder: (context, hiveProvider, child) {
                        return DropdownButtonFormField<int>(
                          value: _selectedHiveId,
                          decoration: InputDecoration(
                            labelText: 'Селектирај сандук',
                            border: OutlineInputBorder(),
                          ),
                          items: hiveProvider.hives.map((hive) {
                            return DropdownMenuItem<int>(
                              value: hive.id,
                              child: Text('Сандук ${hive.number}: ${hive.name}'),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedHiveId = value;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Селектирај сандук';
                            }
                            return null;
                          },
                        );
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
                            setState(() {
                              _selectedTagId = value;
                            });
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
                        if (_formKey.currentState!.validate()) {
                          if (_selectedHiveId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Селектирај сандук'),
                              backgroundColor: Colors.red,
                            ));
                            return;
                          }

                          final task = Task(
                            id: DateTime.now().millisecondsSinceEpoch,
                            title: _titleController.text,
                            description: _descriptionController.text,
                            dueDate: DateTime.parse(_dueDateController.text),
                            hiveId: _selectedHiveId!,
                            tagId: _selectedTagId,
                          );
                          Provider.of<TaskProvider>(context, listen: false).addTask(task);
                          _titleController.clear();
                          _descriptionController.clear();
                          _dueDateController.clear();
                          setState(() {
                            _selectedHiveId = null;
                            _selectedTagId = null;
                            _isAddingTask = false;
                          });
                        }
                      },
                      child: Text('Додади задача'),
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
            )
          else
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _isAddingTask = true;
                  });
                },
                backgroundColor: Colors.yellow,
                child: Icon(Icons.add, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
