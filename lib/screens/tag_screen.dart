import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beekeeping_management/models/tag.dart';
import 'package:beekeeping_management/providers/tag_provider.dart';

class TagScreen extends StatefulWidget {
  @override
  _TagScreenState createState() => _TagScreenState();
}

class _TagScreenState extends State<TagScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  void _editTag(BuildContext context, Tag tag) {
    final _editNameController = TextEditingController(text: tag.name);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Промени Категорија'),
          content: TextFormField(
            controller: _editNameController,
            decoration: InputDecoration(
              labelText: 'Име на категорија',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Внеси име на категоријата';
              }
              return null;
            },
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
                if (_editNameController.text.isNotEmpty) {
                  Provider.of<TagProvider>(context, listen: false).updateTag(
                    Tag(id: tag.id, name: _editNameController.text),
                  );
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

  void _confirmDelete(BuildContext context, int tagId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Избриши Категорија'),
          content: Text('Дали сте сигурни дека сакате да ја избришете категоријата?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Откажи'),
            ),
            ElevatedButton(
              onPressed: () {
                Provider.of<TagProvider>(context, listen: false).deleteTag(tagId as Tag);
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
        title: Text('Категории'),
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
            child: Consumer<TagProvider>(
              builder: (context, provider, child) {
                return ListView.builder(
                  itemCount: provider.tags.length,
                  itemBuilder: (context, index) {
                    final tag = provider.tags[index];
                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(tag.name, style: TextStyle(fontWeight: FontWeight.bold)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _editTag(context, tag),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _confirmDelete(context, tag.id),
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
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Име на категорија',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Внеси име на категоријата';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final tag = Tag(
                          id: DateTime.now().millisecondsSinceEpoch,
                          name: _nameController.text,
                        );
                        Provider.of<TagProvider>(context, listen: false).addTag(tag);
                        _nameController.clear();
                      }
                    },
                    child: Text('Додај Категорија'),
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
