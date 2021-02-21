import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'contacts.dart';

class OneToOnePage extends StatelessWidget {
  final ContactsPageState parent;
  final String name;
  final String meetingFreq;
  int meetingsMissed; // in a row, not total


  OneToOnePage(this.parent, this.name, this.meetingFreq, this.meetingsMissed);

  void addMeetingMissed() {
    meetingsMissed++;
  }

  void attendedMeeting() {
    meetingsMissed = 0;
  }

  //testing/demo method
  void setMeetingsMissed(int mm) {
    meetingsMissed = mm;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(name),
        ),
        body: OneToOneContent(parent, name, meetingFreq, meetingsMissed));
  }
}

class OneToOneContent extends StatefulWidget {
  final ContactsPageState parent;
  final String name;
  final String meetingFreq;
  int meetingsMissed;

  OneToOneContent(this.parent, this.name, this.meetingFreq, this.meetingsMissed);

  void addMeetingMissed() {
    meetingsMissed++;
  }

  void attendedMeeting() {
    meetingsMissed = 0;
  }

  //testing/demo method
  void setMeetingsMissed(int mm) {
    meetingsMissed = mm;
  }

  @override
  OneToOneContentState createState() => OneToOneContentState(parent, name, meetingFreq, meetingsMissed);
}

class OneToOneContentState extends State<OneToOneContent> {
  final ContactsPageState parent;
  final String name;
  String dropdownValue;
  int meetingsMissed;

  OneToOneContentState(this.parent, this.name, this.dropdownValue, this.meetingsMissed);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Center(child:
        (this.meetingsMissed == 0) ? Image.asset('assets/images/0.png', width: 200, height: 390) :
        (this.meetingsMissed == 1) ? Image.asset('assets/images/1.png', width: 200, height: 390) :
        (this.meetingsMissed == 2) ? Image.asset('assets/images/2.png', width: 200, height: 390) :
        Image.asset('assets/images/3.png', width: 200, height: 390)),
      Text((this.meetingsMissed == 0) ? "You've been attending all your scheduled events with " + name + " lately. Keep up the good work!" :
      (this.meetingsMissed == 1) ? "Uh-oh! Looks like you missed your last scheduled event with " + name + ". No worries!" :
      (this.meetingsMissed == 2) ? "Looks like you missed two scheduled events with " + name + " in a row. Be careful, your friendship tree is dying!" :
      "You've missed three or more scheduled events with " + name + " in a row. Everything okay?", textAlign: TextAlign.center, style: TextStyle(fontSize: 15),),
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
          }),
    ]);

  }
}
