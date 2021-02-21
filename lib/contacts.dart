import 'package:flutter/material.dart';
import 'package:hbp_app/one-to-one-page.dart';
import 'new-contact.dart';
import 'calendar.dart';
import 'dart:math';

void main() {
  runApp(MaterialApp(
      title: 'Calendar',
      home: ContactsPage(),
      theme: ThemeData(
          primaryColor: Colors.lightGreen[400],
          accentColor: Colors.blue[200],
          fontFamily: 'Avenir'
      )
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
        ],
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewContactPage(this)),
            );
          }
        )
    );
  }

  List<Widget> makeContactTiles() {
    List<Widget> contactTiles = [];
    List<String> images = ["assets/images/claire.png", "assets/images/vrushali.png",
      "assets/images/nivashini.png", "assets/images/icon.png",
      "assets/images/icon2.png", "assets/images/icon3.png",
      "assets/images/icon4.png", "assets/images/icon5.png"];

    _contacts.forEach((name, meetingFreq) => {
      contactTiles.add(GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context)
          => OneToOnePage(this, name, meetingFreq, Random().nextInt(4))));
          },
          child: GridTile(
            child: Image.asset(images[Random().nextInt(images.length)]),
            footer: Text(name,
                textAlign: TextAlign.center)
      )))
    });
    return contactTiles;
  }
}
