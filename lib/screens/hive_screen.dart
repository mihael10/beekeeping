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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hives'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Beekeeping Management', style: TextStyle(color: Colors.white, fontSize: 24)),
              decoration: BoxDecoration(
                color: Colors.green,
              ),
            ),
            ListTile(
              leading: Icon(Icons.assignment),
              title: Text('Tasks'),
              onTap: () {
                Navigator.pushNamed(context, '/tasks');
              },
            ),
            ListTile(
              leading: Icon(Icons.label),
              title: Text('Tags'),
              onTap: () {
                Navigator.pushNamed(context, '/tags');
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer2<HiveProvider, TaskProvider>(
              builder: (context, hiveProvider, taskProvider, child) {
                return ListView.builder(
                  itemCount: hiveProvider.hives.length,
                  itemBuilder: (context, index) {
                    final hive = hiveProvider.hives[index];
                    final tasksForToday = taskProvider.tasks.where((task) =>
                    task.hiveId == hive.id &&
                        (task.dueDate.isAtSameMomentAs(DateTime.now()) ||
                            task.dueDate.isBefore(DateTime.now()) && !task.completed));
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
                      child: Card(
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 10,
                              height: 70,
                              color: color,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(16),
                                child: Text('Box ${hive.number}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                    decoration: InputDecoration(
                      labelText: 'Hive Number',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a hive number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Hive Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a hive name';
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
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final hive = Hive(
                          id: DateTime.now().millisecondsSinceEpoch,
                          number: int.parse(_numberController.text),
                          name: _nameController.text,
                          description: _descriptionController.text,
                          tasks: [],
                        );
                        Provider.of<HiveProvider>(context, listen: false).addHive(hive);
                        _numberController.clear();
                        _nameController.clear();
                        _descriptionController.clear();
                      }
                    },
                    child: Text('Add Hive'),
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
