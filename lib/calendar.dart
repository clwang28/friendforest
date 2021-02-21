import 'dart:convert';
import 'contacts.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hbp_app/contacts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';



void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendar',
      home: MyHomePage(title: 'Calendar'),
      theme: ThemeData(
        primaryColor: Colors.lightGreen[400],
        accentColor: Colors.blue[200],
        fontFamily: 'Avenir'
      )
    );
  }
}

class EventInfo {
  String eventDesc;
  DateTime eventTime;
  String friend;
  bool isCompleted;

  EventInfo(String eventDesc, DateTime eventTime, String friend) {
    this.eventDesc = eventDesc;
    this.eventTime = eventTime;
    this.friend = friend;
    this.isCompleted = false;
  }

  @override
  bool operator ==(Object other) => other is EventInfo
      && other.eventDesc == eventDesc
      && other.eventTime == eventTime
      && other.friend == friend
      && other.isCompleted == isCompleted;

  @override
  int get hashCode => eventDesc.hashCode + eventTime.hashCode + friend.hashCode + isCompleted.hashCode;


  String getEventDesc() {
    return eventDesc;
  }

  DateTime getEventTime() {
    return eventTime;
  }

  String getFriend() {
    return friend;
  }

  bool getIsCompleted() {
    return isCompleted;
  }

  void toggleIsCompleted() {
    isCompleted = !isCompleted;
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  Map<DateTime, List<dynamic>> _events;
  Map<String, EventInfo>_eventHashes;
  List _selectedEvents;
  TextEditingController _eventController;
  SharedPreferences prefs;

  CalendarController _calendarController;
  String _dropdownValue;
  List<String> _friendsList  = new ContactsPageState().getContactNames();
  DateTime _dateTime = DateTime.now();

  @override
  void initState() {
    _events = {};
    _eventHashes = {};
    _selectedEvents = [];
    _eventController = TextEditingController();
    _calendarController = CalendarController();
    _dropdownValue = _friendsList.first;
    initPrefs();
    super.initState();
  }

  initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _events = Map<DateTime,List<dynamic>>.from(json.decode(prefs.getString("events") ?? "{}"));
    });
  }

  Map<String,dynamic> encodeMap(Map<DateTime,dynamic> map) {
    Map<String,dynamic> newMap = {};
    map.forEach((key,value) {
      newMap[key.toString()] = map[key];
    });
    return newMap;
  }

  Map<DateTime,dynamic> decodeMap(Map<String,dynamic> map) {
    Map<DateTime,dynamic> newMap = {};
    map.forEach((key,value) {
      newMap[DateTime.parse(key)] = map[key];
    });
    return newMap;
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedEvents = events;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _buildTableCalendar(),
          const SizedBox(height: 8.0),
          _buildButtons(),
          const SizedBox(height: 8.0),
          Expanded(child: _buildEventList(context)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _showAddDialog,
      ),
      persistentFooterButtons: [
        IconButton(
            icon: Icon(Icons.contacts),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ContactsPage()),
              );
            }
        )
      ],
    );
  }

  _showAddDialog() {
    final dropdownMenuOptions = _friendsList.map((String item) => new DropdownMenuItem<String>(
      value: item, child: Text(item)
    )).toList();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: _eventController,
          maxLength: 20,
        ),
        actions: <Widget>[
          TimePickerSpinner(
            is24HourMode: false,
            normalTextStyle: TextStyle(
              fontSize: 24,
              color: Colors.green[200],
            ),
            highlightedTextStyle: TextStyle(
              fontSize: 24,
              color: Colors.green[900]
            ),
            spacing: 50,
            itemHeight: 80,
            minutesInterval: 15,
            isForce2Digits: true,
            onTimeChange: (time) {
              setState(() {
                _dateTime = time;
              });
            },
          ),
          new DropdownButton<String>(
              value: _dropdownValue,
                items: dropdownMenuOptions,
              icon: Icon(Icons.arrow_drop_down),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.black, fontFamily: 'Avenir'),
                underline: Container(
                  height: 2,
                  color: Colors.black,
                ),
                onChanged: (s) {
                  setState(() {
                    _dropdownValue = s;
                  });
                },
            ),
          TextButton(
            child: Text("Save"),
            onPressed: () {
              if (_eventController.text.isEmpty) return;
              setState(() {
                if (_events[_calendarController.selectedDay] != null) {
                  EventInfo e = new EventInfo(_eventController.text, _dateTime, _dropdownValue);
                  _events[_calendarController.selectedDay].add(e.hashCode.toString());
                  _eventHashes[e.hashCode.toString()] = e;
                }
                else {
                  EventInfo e = new EventInfo(_eventController.text, _dateTime, _dropdownValue);
                  _events[_calendarController.selectedDay] = [e.hashCode.toString()];
                  _eventHashes[e.hashCode.toString()] = e;
                }
                prefs.setString("events", json.encode(encodeMap(_events)));
                _eventController.clear();
                Navigator.pop(context);
              });
            }
          )
        ],
      )
    );
  }

  static String dateTimeFormatting(DateTime dt) {
    String amOrPm;
    int h;
    String m;

    if (dt.hour == 12) {
      h = dt.hour;
      amOrPm = "pm";
    }
    else if (dt.hour > 12) {
      h = dt.hour % 12;
      amOrPm = "pm";
    }
    else if (dt.hour == 0) {
      h = 12;
      amOrPm = "am";
    }
    else {
      h = dt.hour;
      amOrPm = "am";
    }

    if (dt.minute < 10) {
      m = "0" + dt.minute.toString();
    }
    else {
      m = dt.minute.toString();
    }

    String thing = h.toString() + ":" + m + amOrPm;

    return thing;
  }

  // Simple TableCalendar configuration (using Styles)
  Widget _buildTableCalendar() {
    return TableCalendar(
      calendarController: _calendarController,
      events: _events,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      calendarStyle: CalendarStyle(
        selectedColor: Colors.lightGreen[400],
        todayColor: Colors.lightGreen[200],
        markersColor: Colors.brown[700],
        outsideDaysVisible: true,
        outsideStyle: TextStyle(fontSize: 18, fontFamily: 'Avenir', color: Colors.grey),
        eventDayStyle: TextStyle(fontSize: 18, fontFamily: 'Avenir'),
        selectedStyle: TextStyle(fontSize: 18, fontFamily: 'Avenir', color: Colors.white),
          weekdayStyle: TextStyle(fontSize: 18, fontFamily: 'Avenir'),
          todayStyle: TextStyle(fontSize: 18, fontFamily: 'Avenir'),
        weekendStyle: TextStyle(color: Colors.blue[800], fontSize: 18, fontFamily: 'Avenir'),
        outsideWeekendStyle: TextStyle(color: Colors.blue[200], fontSize: 18, fontFamily: 'Avenir')
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(fontSize: 18, fontFamily: 'Avenir'),
        weekendStyle: TextStyle(color: Colors.blue[800], fontSize: 18, fontFamily: 'Avenir')
      ),
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
      centerHeaderTitle: true,
      titleTextStyle: TextStyle(fontSize: 25, fontFamily: 'Avenir', fontWeight: FontWeight.bold)),
      onDaySelected: _onDaySelected,
    );
  }

  Widget _buildButtons() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
          ],
        ),
        const SizedBox(height: 8.0),
      ],
    );
  }

  Widget _buildEventList(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: _selectedEvents.length,
        itemBuilder: (context, index) {
          return Dismissible(
            background: Container(
              alignment: AlignmentDirectional.centerEnd,
              color: Colors.red,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: Icon(Icons.delete,
                            color: Colors.white)
              )
            ),
            key: Key(_selectedEvents[index]),
            onDismissed: (direction) {
              setState(() {
                _selectedEvents.removeAt(index);
              });
            },
              child: GestureDetector (
                onDoubleTap: () {
                  _eventHashes[_selectedEvents[index]].toggleIsCompleted();
                },
            child: Container(
              height: 80.0,
              decoration: BoxDecoration(border: Border.all(width: 1.0),
                  color:
                  (_eventHashes[_selectedEvents[index]].getIsCompleted() && DateTime.now().difference(_eventHashes[_selectedEvents[index]].getEventTime()).inHours <= 0) ? Colors.lightGreen[200] :
                   (!_eventHashes[_selectedEvents[index]].getIsCompleted() && DateTime.now().difference(_eventHashes[_selectedEvents[index]].getEventTime()).inHours <= 0) ? Colors.red[200] :
                    Colors.white),
              padding: EdgeInsets.all(5.0),
              alignment: Alignment.centerLeft,
              child: Row(
                children: <Widget>[
                  Container(alignment: Alignment.centerLeft,
                  width: 190,
                  child: Text(
                    _eventHashes[_selectedEvents[index]].getEventDesc(),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontFamily: 'Avenir',
                    ),
                  )),
                  Container(alignment: Alignment.centerRight,
                  width: 190,
                  child: Text(
                      dateTimeFormatting(_eventHashes[_selectedEvents[index]].getEventTime()) + "\n" + _eventHashes[_selectedEvents[index]].getFriend(),
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 15.0,
                        fontFamily: 'Avenir'
                      ),
                      textAlign: TextAlign.right,
                    ))

                ]
              )
            )
              )
          );
        }
      )
    );
  }
}
