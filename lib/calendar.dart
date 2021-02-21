import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
    );
  }
}

class EventInfo {
  String eventDesc;
  DateTime eventTime;
  String friend;

  EventInfo(String eventDesc, DateTime eventTime, String friend) {
    this.eventDesc = eventDesc;
    this.eventTime = eventTime;
    this.friend = friend;
  }

  @override
  bool operator ==(Object other) => other is EventInfo
      && other.eventDesc == eventDesc
      && other.eventTime == eventTime
      && other.friend == friend;

  @override
  int get hashCode => eventDesc.hashCode + eventTime.hashCode + friend.hashCode;


  String getEventDesc() {
    return eventDesc;
  }

  String getEventTime() {
    return _MyHomePageState.dateTimeFormatting(eventTime);
  }

  String getFriend() {
    return friend;
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
  AnimationController _animationController;
  CalendarController _calendarController;
  List<String> _friendsList  = <String>["Jennya", "Claire", "Vrushali", "Nivashini"];
  String dropdownValue = 'Jennya';
  DateTime _dateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _events = {};
    _eventHashes = {};
    _selectedEvents = [];
    _eventController = TextEditingController();
    _calendarController = CalendarController();
    initPrefs();
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
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
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
          // Switch out 2 lines below to play with TableCalendar's settings
          //-----------------------
          _buildTableCalendar(),
          // _buildTableCalendarWithBuilders(),
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
    );
  }

  _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: _eventController,
        ),
        actions: <Widget>[
          TimePickerSpinner(
            is24HourMode: false,
            normalTextStyle: TextStyle(
              fontSize: 24,
              color: Colors.lightGreen
            ),
            highlightedTextStyle: TextStyle(
              fontSize: 24,
              color: Colors.green
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
          DropdownButton<String>(
            value: dropdownValue,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.black),
            underline: Container(
              height: 2,
              color: Colors.black,
            ),
            onChanged: (String newValue) {
              setState(() {
                dropdownValue = newValue;
              });
            },
            items: _friendsList
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList()
          ),
          TextButton(
            child: Text("Save"),
            onPressed: () {
              if (_eventController.text.isEmpty) return;
              setState(() {
                if (_events[_calendarController.selectedDay] != null) {
                  EventInfo e = new EventInfo(_eventController.text, _dateTime, dropdownValue);
                  _events[_calendarController.selectedDay].add(e.hashCode.toString());
                  _eventHashes[e.hashCode.toString()] = e;
                }
                else {
                  EventInfo e = new EventInfo(_eventController.text, _dateTime, dropdownValue);
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
        selectedColor: Colors.deepOrange[400],
        todayColor: Colors.deepOrange[200],
        markersColor: Colors.brown[700],
        outsideDaysVisible: true,
      ),
      headerStyle: HeaderStyle(
        formatButtonVisible: false),
      onDaySelected: _onDaySelected,
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: _calendarController.isSelected(date)
            ? Colors.brown[500]
            : _calendarController.isToday(date)
            ? Colors.brown[300]
            : Colors.blue[400],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildHolidaysMarker() {
    return Icon(
      Icons.add_box,
      size: 20.0,
      color: Colors.blueGrey[800],
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
            child: Container(
              height: 80.0,
              decoration: BoxDecoration(border: Border.all(width: 1.0)),
              padding: EdgeInsets.all(5.0),
              child: Row(
                children: <Widget>[
                  Text(
                    _eventHashes[_selectedEvents[index]].getEventDesc(),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0
                    )
                  ),
                  Text(
                    _eventHashes[_selectedEvents[index]].getEventTime(),
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 15.0
                    )
                  ),
                  Text(
                    _eventHashes[_selectedEvents[index]].getFriend(),
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 15.0
                    )
                  )
                ]
              )
            )
          );
        }
      )
    );
  }
}
