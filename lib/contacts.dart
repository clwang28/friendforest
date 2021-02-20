import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'Friends';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
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
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Add Friend',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Calendar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          // currentIndex: _selectedIndex,
          // onTap: _onItemTapped,
        ),
      ),
    );
  }
}