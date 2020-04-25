import 'package:dip_taskplanner/database/database_hepler.dart';
import 'package:intl/intl.dart';
import 'dart:ui';
import 'package:dip_taskplanner/constants.dart';
import 'package:dip_taskplanner/Screen/LoadingScreen.dart';
import 'package:dip_taskplanner/components/Reuseable_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:date_utils/date_utils.dart';
import 'package:swipedetector/swipedetector.dart';

const activeCardColour = Color(0xFF1D1E33);

class CalendarPage extends StatefulWidget {
  CalendarPage();

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>(); //To allow top left table icon button to open scaffold drawer
  final databasehelper = DatabaseHelper();
  DateTime dateTime = new DateTime.now();
  List<List<Widget>> twoDList =
      List.generate(rows, (i) => List(DateTime.daysPerWeek), growable: false);
  void updateUI(DateTime dateTime) {
    DateTime startDayIndex = Utils.firstDayOfMonth(dateTime);

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < daysPerWeek; j++) {
        if ((j + 1) == startDayIndex.weekday &&
            startDayIndex.month == dateTime.month) {
          twoDList[i][j] = CircularButton(
            visible: true,
            location: [i, j],
            text: startDayIndex.day.toString(),
            dateTime: startDayIndex,
            boxShadowColor: academicWeeks[startDayIndex.subtract(
                      Duration(
                        days: (startDayIndex.weekday - 1),
                      ),
                    )] ==
                    null
                ? null
                : academicWeeks[startDayIndex.subtract(
                    Duration(
                      days: (startDayIndex.weekday - 1),
                    ),
                  )][1],
            function: () {
              print([i, j]);
            },
          );
          startDayIndex = startDayIndex.add(Duration(days: 1));
        } else {
          twoDList[i][j] = CircularButton(visible: false, location: [i, j]);
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      updateUI(dateTime);
    });
  }

  void deleteFrom2DList(List<List> list) {
    for (int i = 0; i < list.length; i++) {
      for (int j = 0; j < list[i].length; j++) {
        list[i][j] = null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          child: ListView(padding: EdgeInsets.zero, children: <Widget>[
            UserAccountsDrawerHeader(
              currentAccountPicture: Icon(
                Icons.person,
              ),
              accountName: Text('Name here'),
              accountEmail: null,
            ),
            ListTile(
              leading: Icon(Icons.message),
              title: Text('Delete To Do List\n(Press and hold)'),
              onLongPress: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text('ARE YOU SURE TO DELETE THE TO-DO LIST?'),
                          content: Text('This will be irreversible.'),
                          actions: [
                            FlatButton(
                              onPressed: () async{
                                await databasehelper.usersExist();
                                databasehelper.deleteAllUsers();
                                Navigator.of(context).pop();
                              },
                              child: Text('Yes'),
                            ),
                            FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('No'),
                            ),
                          ],
                        ));
              },
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text(
                  'Delete Registered Courses \nand To Do List\n(Press and hold)'),
              onLongPress: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text('ARE YOU SURE TO DELETE ALL?'),
                          content: Text('This will be irreversible.'),
                          actions: [
                            FlatButton(
                              onPressed: () async{
                                databasehelper.deleteAllUsers();
                                databasehelper.deleteAllCourses();
                                await databasehelper.coursesExist();
                                await databasehelper.usersExist(); 
                                Navigator.of(context).pop();
                                Navigator.push(context,MaterialPageRoute(builder: (context)=>LoadingScreen()));
                              },
                              child: Text('Yes'),
                            ),
                            FlatButton(
                              onPressed: () {                                
                                Navigator.of(context).pop();
                              },
                              child: Text('No'),
                            ),
                          ],
                        ),
                      );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('About'),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => SimpleDialog(
                          title: Text('About Us'),
                          children: <Widget>[
                            SimpleDialogOption(
                                child: Text('Okay'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                })
                          ],
                        ));
              },
            ),
          ]),
        ),
        body: SafeArea(
          child: SwipeDetector(
            swipeConfiguration: SwipeConfiguration(
                verticalSwipeMinVelocity: 100.0,
                verticalSwipeMinDisplacement: 50.0,
                verticalSwipeMaxWidthThreshold: 100.0,
                horizontalSwipeMaxHeightThreshold: 50.0,
                horizontalSwipeMinDisplacement: 50.0,
                horizontalSwipeMinVelocity: 200.0),
            onSwipeLeft: () {
              setState(
                () {
                  dateTime = dateTime
                      .add(Duration(days: Utils.daysInMonth(dateTime).length));

                  deleteFrom2DList(twoDList);
                  updateUI(dateTime);
                },
              );
            },
            onSwipeRight: () {
              setState(() {
                dateTime = dateTime.subtract(
                    Duration(days: Utils.daysInMonth(dateTime).length));

                deleteFrom2DList(twoDList);
                updateUI(dateTime);
              });
            },
            child: Column(children: <Widget>[
              Row(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: FlatButton(
                      onPressed: () {
                        _scaffoldKey.currentState.openDrawer();
                      },
                      child: Icon(
                        Icons.list,
                        size: 25.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 150.0,
                    child: Center(
                        child: Text(
                      '${DateFormat.yMMMM().format(dateTime)}',
                      style: TextStyle(fontSize: 50.0),
                    )),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Center(
                        child: Text(
                      'Mon',
                    )),
                  ),
                  Expanded(
                    child: Center(child: Text('Tue')),
                  ),
                  Expanded(
                    child: Center(child: Text('Wed')),
                  ),
                  Expanded(
                    child: Center(child: Text('Thurs')),
                  ),
                  Expanded(
                    child: Center(child: Text('Fri')),
                  ),
                  Expanded(
                    child: Center(child: Text('Sat')),
                  ),
                  Expanded(
                    child: Center(child: Text('Sun')),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Row(
                    children: twoDList[0],
                  ),
                  Row(
                    children: twoDList[1],
                  ),
                  Row(
                    children: twoDList[2],
                  ),
                  Row(
                    children: twoDList[3],
                  ),
                  Row(
                    children: twoDList[4],
                  ),
                  Row(
                    children: twoDList[5],
                  ),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
