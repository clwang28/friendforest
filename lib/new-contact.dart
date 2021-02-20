import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'contacts.dart';

/*
make icons into links
delete functionality
 */

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
  final contactFreqController = TextEditingController();
  ContactsPageState parent;
  _NewContactFormState(this.parent);

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed.
    nameController.dispose();
    contactFreqController.dispose();
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
            TextFormField(
              controller: contactFreqController,
            ),
            SizedBox(height: 50),
            TextButton(
              child: Text(
                'Save',
                style: TextStyle(fontSize: 24),
              ),
              onPressed: () { parent.addContact(nameController.text); },
            )
          ]
        )
      ),
    );
  }
}