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
              child: Text(
                'Улишта',
                style: TextStyle(color: Colors.black, fontSize: 24),
              ),
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
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

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of columns
                    childAspectRatio: 1, // Ensures the boxes are square
                  ),
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
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: color,
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
                        child: Center(
                          child: Text(
                            'Сандук ${hive.number}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddHiveForm(context),
        child: Icon(Icons.add),
        backgroundColor: Colors.yellow,
      ),
    );
  }

  void _showAddHiveForm(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _numberController = TextEditingController();
    final _nameController = TextEditingController();
    final _descriptionController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                Text(
                  'Додај Сандук',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _numberController,
                  decoration: InputDecoration(
                    labelText: 'Број на сандук',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Внеси број на сандук';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Внеси име на сандук',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Внеси име на сандук';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Опис',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
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
                        tasks: [], // Initialize with an empty list of tasks
                      );
                      Provider.of<HiveProvider>(context, listen: false).addHive(hive);
                      _numberController.clear();
                      _nameController.clear();
                      _descriptionController.clear();
                      Navigator.pop(context);
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
        );
      },
    );
  }
}
