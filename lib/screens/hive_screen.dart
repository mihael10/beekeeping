import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beekeeping_management/models/hive.dart';
import 'package:beekeeping_management/providers/hive_provider.dart';
import 'package:beekeeping_management/providers/task_provider.dart';
import 'hive_detail_screen.dart';

class HiveScreen extends StatefulWidget {
  @override
  _HiveScreenState createState() => _HiveScreenState();
}

class _HiveScreenState extends State<HiveScreen> {
  final _formKey = GlobalKey<FormState>();
  final _numberController = TextEditingController();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Сандуци'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Beekeeping Management'),
              decoration: BoxDecoration(
                color: Colors.yellow,
              ),
            ),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text('Контролна Табла'),
              onTap: () {
                Navigator.pushNamed(context, '/dashboard');
              },
            ),
            ListTile(
              leading: Icon(Icons.assignment),
              title: Text('Работни Задачи'),
              onTap: () {
                Navigator.pushNamed(context, '/tasks');
              },
            ),
            ListTile(
              leading: Icon(Icons.label),
              title: Text('Категории'),
              onTap: () {
                Navigator.pushNamed(context, '/tags');
              },
            ),
            ListTile(
              leading: Icon(Icons.api),
              title: Text('Сандуци'),
              onTap: () {
                Navigator.pushNamed(context, '/');
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Пребарај сандук',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: Consumer2<HiveProvider, TaskProvider>(
              builder: (context, hiveProvider, taskProvider, child) {
                final filteredHives = hiveProvider.hives.where((hive) {
                  return hive.number.toString().contains(searchQuery);
                }).toList();

                return ListView.builder(
                  itemCount: filteredHives.length,
                  itemBuilder: (context, index) {
                    final hive = filteredHives[index];
                    final tasksForToday = taskProvider.tasks.where((task) =>
                    task.hiveId == hive.id &&
                        (task.dueDate.isAtSameMomentAs(DateTime.now()) ||
                            (task.dueDate.isBefore(DateTime.now()) && !task.completed))).toList();
                    final color = tasksForToday.isNotEmpty ? Colors.red : Colors.green;

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HiveDetailScreen(hive: hive),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        child: Row(
                          children: [
                            Container(
                              width: 10,
                              height: 50,
                              color: color,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text('Сандук ${hive.number}', style: TextStyle(fontSize: 16)),
                                ),
                              ),
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _numberController,
                    decoration: InputDecoration(labelText: 'Број на сандук'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Внеси број на сандук';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Внеси име на сандук'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Имен на сандук';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(labelText: 'Опис'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final hive = Hive(
                          id: DateTime.now().millisecondsSinceEpoch,
                          number: int.parse(_numberController.text),
                          name: _nameController.text,
                          description: _descriptionController.text,
                          tasks: [], // Initialize with an empty list of tasks
                        );
                        Provider.of<HiveProvider>(context, listen: false).addHive(hive);
                        _numberController.clear();
                        _nameController.clear();
                        _descriptionController.clear();
                      }
                    },
                    child: Text('Додај Сандук'),
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
