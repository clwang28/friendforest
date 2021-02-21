import 'package:flutter/material.dart';
import 'package:hbp_app/one-to-one-page.dart';
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
  var _contacts = <String, String>{
    'Jennya': '1',
    'Claire': '2',
    'Vrushali': '3',
    'Nivashini': '4'
  };

  void addContact(String name, String meetingFreq) {
    setState(() {_contacts.putIfAbsent(name, () => meetingFreq); });
  }

  void updateMeetingFreq(String name, String newMeetingFreq) {
    setState(() {
      _contacts[name] = newMeetingFreq;
    });
  }

  void deleteContact(String nameToRemove) {
    setState(() { _contacts.removeWhere((name, meetingFreq) => name == nameToRemove); });
  }

  List<String> getContactNames() {
    return List.from(_contacts.keys);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Contacts'),
        ),
        body: GridView.count(
          crossAxisCount: 2,
          children: makeContactTiles(),
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

  List<Widget> makeContactTiles() {
    List<Widget> contactTiles = [];
    _contacts.forEach((name, meetingFreq) => {
      contactTiles.add(GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context)
          => OneToOnePage(this, name, meetingFreq)),
            );
          },
          child: GridTile(
            child: Icon(Icons.face),
            footer: Text(name,
                textAlign: TextAlign.center)
      )))});
    return contactTiles;
  }
}
