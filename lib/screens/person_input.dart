import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive/models/person.dart';
import 'package:hive_flutter/screens/person_list.dart';

class PersonInputScreen extends StatefulWidget {
  @override
  _PersonInputScreenState createState() => _PersonInputScreenState();
}

class _PersonInputScreenState extends State<PersonInputScreen> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _friendsController = TextEditingController();

  late Box box; // Use late initialization for Hive box

  @override
  void initState() {
    super.initState();
    openBox(); // Initialize Hive box
  }

  void openBox() async {
    box = await Hive.openBox('local'); // Open Hive box for local storage
  }

  void _savePerson() async {
    final name = _nameController.text;
    final age = int.tryParse(_ageController.text) ?? 0;
    final friends = _friendsController.text.split(',');

    var person = Person(name: name, age: age, friends: friends);

    await box.put(name, person); // Save person object to Hive

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Person saved successfully!')),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _friendsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Person Input'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _ageController,
              decoration: InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _friendsController,
              decoration:
                  InputDecoration(labelText: 'Friends (comma separated)'),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _savePerson,
                  child: Text('Save Person'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PersonListScreen()),
                    );
                  },
                  child: Text('View Saved Persons'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
