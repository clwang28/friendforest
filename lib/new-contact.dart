import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'contacts.dart';

class NewContactPage extends StatelessWidget {
  final ContactsPageState parent;
  NewContactPage(this.parent);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add A Contact"),
        ),
        body: NewContactForm(parent)
    );
  }
}

class NewContactForm extends StatefulWidget {
  final ContactsPageState parent;
  NewContactForm(this.parent);

  @override
  _NewContactFormState createState() => _NewContactFormState(parent);
}

class _NewContactFormState extends State<NewContactForm> {
  final nameController = TextEditingController();
  String dropdownValue;

  ContactsPageState parent;
  _NewContactFormState(this.parent);

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 50),
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'Name'
              ),
              controller: nameController,
            ),
            SizedBox(height: 50),
            Text(
              'How many times per week would you like to contact them?',
              style: TextStyle(fontSize: 24),
            ),
          DropdownButton<String>(
            value: dropdownValue,
            icon: Icon(Icons.arrow_downward),
            onChanged: (String newValue) {
              setState(() { dropdownValue = newValue; });
            },
            items: <String>['1', '2', '3', '4', '5', '6', '7']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
            SizedBox(height: 50),
            OutlinedButton(
              child: Text(
                'Save',
                style: TextStyle(fontSize: 24),
              ),
              onPressed: () { parent.addContact(nameController.text, dropdownValue); },
            )
          ]
        )
      ),
    );
  }
}