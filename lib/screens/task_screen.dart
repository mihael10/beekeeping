import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beekeeping_management/models/task.dart';
import 'package:beekeeping_management/providers/task_provider.dart';
import 'package:beekeeping_management/providers/hive_provider.dart';
import 'package:beekeeping_management/providers/tag_provider.dart';
import 'package:beekeeping_management/models/hive.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
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
                        subtitle: Text(task.dueDate.toIso8601String()),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Task Title',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a task title';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _dueDateController,
                    decoration: InputDecoration(
                      labelText: 'Due Date',
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
                          labelText: 'Select Hive',
                          border: OutlineInputBorder(),
                        ),
                        items: hiveProvider.hives.map((hive) {
                          return DropdownMenuItem<int>(
                            value: hive.id,
                            child: Text('Box ${hive.number}: ${hive.name}'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedHiveId = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a hive';
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
                          labelText: 'Select Tag',
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
                            return 'Please select a tag';
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
                            content: Text('Please select a hive'),
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
                        });
                      }
                    },
                    child: Text('Add Task'),
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
          ),
        ],
      ),
    );
  }
}
