import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive/models/person.dart';
class PersonListScreen extends StatefulWidget {
  @override
  _PersonListScreenState createState() => _PersonListScreenState();
}

class _PersonListScreenState extends State<PersonListScreen> {
  late Box box; // Use late initialization for Hive box
  List<Person> persons = [];

  @override
  void initState() {
    super.initState();
    openBox(); // Initialize Hive box
  }

  void openBox() async {
  
    box = await Hive.openBox('local'); // Open Hive box for local storage

    // Fetch all stored persons
    fetchPersons();
  }

  void fetchPersons() {
    List<Person> storedPersons = [];
    box.values.forEach((value) {
      if (value is Person) {
        storedPersons.add(value);
      }
    });

    setState(() {
      persons = storedPersons;
    });
  }

  void deletePerson(String name) async {
    await box.delete(name);
    fetchPersons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Persons'),
      ),
      body: persons.isEmpty
          ? Center(
              child: Text('No persons saved yet.'),
            )
          : ListView.builder(
              itemCount: persons.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onLongPress: () {
                    deletePerson(persons[index].name);
                  },
                  title: Text(persons[index].name),
                  subtitle: Text('Age: ${persons[index].age}'),
                  trailing:
                      Text('Friends: ${persons[index].friends.join(', ')}'),
                );
              },
            ),
    );
  }
}
