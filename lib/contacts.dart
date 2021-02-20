import 'package:flutter/material.dart';
import 'add-contact.dart';

void main() {
  runApp(ContactsPage());
}

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  int _selectedIndex = 0;
  static List _pages = <Widget>[
    AddContactForm(),
    Text('index1'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = 'Contacts';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(
          child: _pages.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Calendar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Add Friend',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

class ContactsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.count(
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
        crossAxisCount: 2,
        // Generate 100 widgets that display their index in the List.
        children: <Widget>[
          GridTile(
              child: Icon(Icons.face),
              footer: Text('Jennya',
                  textAlign: TextAlign.center)
          ),
          GridTile(
              child: Icon(Icons.face),
              footer: Text('Claire',
                  textAlign: TextAlign.center)
          ),
          GridTile(
              child: Icon(Icons.face),
              footer: Text('Vrushali',
                  textAlign: TextAlign.center)
          ),
          GridTile(
              child: Icon(Icons.face),
              footer: Text('Nivashini',
                  textAlign: TextAlign.center)
          ),
        ],
      ),
    );
  }
}