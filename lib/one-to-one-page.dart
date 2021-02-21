import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'contacts.dart';

class OneToOnePage extends StatelessWidget {
  final ContactsPageState parent;
  final String name;
  final String meetingFreq;

  OneToOnePage(this.parent, this.name, this.meetingFreq);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(name),
        ),
        body: OneToOneContent(parent, name, meetingFreq));
  }
}

class OneToOneContent extends StatefulWidget {
  final ContactsPageState parent;
  final String name;
  final String meetingFreq;

  OneToOneContent(this.parent, this.name, this.meetingFreq);

  @override
  OneToOneContentState createState() => OneToOneContentState(parent, name, meetingFreq);
}

class OneToOneContentState extends State<OneToOneContent> {
  final ContactsPageState parent;
  final String name;
  String dropdownValue;

  OneToOneContentState(this.parent, this.name, this.dropdownValue);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Center(child: Image.asset('assets/images/happynature.jpg')),
      SizedBox(height: 50),
      Text('Number of times per week\nyou want to contact ' + name + ':',
          style: TextStyle(fontSize: 18)),
      DropdownButton<String>(
        value: dropdownValue,
        icon: Icon(Icons.arrow_downward),
        onChanged: (String newValue) {
          setState(() { dropdownValue = newValue; });
        },
        items: <String>['1', '2', '3', '4', '5', '6', '7']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
      ),
      OutlinedButton(
          child: Text('Save'),
          onPressed: () {
            parent.updateMeetingFreq(name, dropdownValue);
          }),
      SizedBox(height: 50),
      OutlinedButton(
          child: Text('Delete contact'),
          onPressed: () {
            parent.deleteContact(name);
          })
    ]);
  }
}
