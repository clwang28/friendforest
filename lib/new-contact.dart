import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'contacts.dart';

class NewContactPage extends StatelessWidget {
  ContactsPageState parent;
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
  ContactsPageState parent;
  NewContactForm(this.parent);

  @override
  _NewContactFormState createState() => _NewContactFormState(parent);
}

class _NewContactFormState extends State<NewContactForm> {
  final myController = TextEditingController();
  ContactsPageState parent;
  _NewContactFormState(this.parent);

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: myController,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          parent.addContact(myController.text);
        },
        child: Icon(Icons.text_fields),
      ),
    );
  }
}