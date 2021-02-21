import 'package:flutter/material.dart';
import 'new-contact.dart';
import 'calendar.dart';

void main() {
  runApp(MaterialApp(
    home: ContactsPage(),
  ));
}

class ContactsPage extends StatefulWidget {
  @override
  ContactsPageState createState() => ContactsPageState();
}

class ContactsPageState extends State<ContactsPage> {
  List _contacts = ['Jennya', 'Claire', 'Vrushali', 'Nivashini'];

  void addContact(String name) {
    setState(() {_contacts.add(name);});
  }

  List<String> getContactNames() {
    return List.from(_contacts);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Contacts'),
        ),
        body: GridView.count(
          // Create a grid with 2 columns
          crossAxisCount: 2,
          children: makeContactTiles()
        ),
        persistentFooterButtons: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyApp()),
              );
            }
          ),
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewContactPage(this)),
                );
              }
          ),
        ],
    );
  }

  List<GridTile> makeContactTiles() {
    List<GridTile> contactTiles = [];
    for (String contact in _contacts) {
      contactTiles.add(GridTile(
          child: Icon(Icons.face),
          footer: Text(contact,
              textAlign: TextAlign.center)
      ));
    }
    return contactTiles;
  }
}
