import 'dart:io';

import 'package:dip_taskplanner/components/regExp.dart';
import 'package:dip_taskplanner/database/database_hepler.dart';
import 'package:dip_taskplanner/database/model/course.dart';
import 'package:dip_taskplanner/database/model/user.dart';
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
import 'package:flutter_app_badger/flutter_app_badger.dart';

const activeCardColour = Color(0xFF1D1E33);

class CalendarPage extends StatefulWidget {
  CalendarPage();

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final _scaffoldKey = GlobalKey<
      ScaffoldState>(); //To allow top left table icon button to open scaffold drawer
  final databasehelper = DatabaseHelper();
  List<Course> allCourseInfo;
  bool check = false;
  List<User> allEvents;
  List<User> bottomViewerEvents = [];
  bool triggerDaysLeft = true;
  DateTime dateTime = new DateTime.now();
  List<List<Widget>> twoDList =
      List.generate(rows, (i) => List(DateTime.daysPerWeek), growable: false);
  void updateUI(DateTime dateTime) {
    DateTime startDayIndex = Utils.firstDayOfMonth(dateTime);
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < daysPerWeek; j++) {
        if ((j + 1) == startDayIndex.weekday &&
            startDayIndex.month == dateTime.month) {
          int rank = 9;
          for (int k = 0; k < allEvents.length; k++) {
            String value =
                ListOfCourses().findDateyyyyMMdd(allEvents[k].eventET);
            DateTime endDateTime = DateTime.parse(value);
            if (triggerDaysLeft) {
              int difference = endDateTime.difference(DateTime.now()).inDays;
              bottomViewerEvents.add(new User(
                  allEvents[k].eventName,
                  allEvents[k].eventLocation,
                  allEvents[k].eventST,
                  allEvents[k].eventET,
                  allEvents[k].eventCAT,
                  difference.toString()));
              if (bottomViewerEvents.length == allEvents.length)
                triggerDaysLeft = false;
            }
            if (endDateTime.day == startDayIndex.day &&
                endDateTime.month == startDayIndex.month &&
                startDayIndex.year == endDateTime.year) {
              //Check same date and Time
              switch (allEvents[k].eventCAT) {
                case 'Exam':
                  {
                    if (rank > 1) rank = 1;
                  }
                  break;
                case 'Quiz':
                  {
                    if (rank > 2) rank = 2;
                  }
                  break;
                case 'Homework Assignment':
                  {
                    if (rank > 4) rank = 4;
                  }
                  break;
                case 'Tut':
                  {
                    if (rank > 6) rank = 6;
                  }
                  break;
                case 'IRA/Class Test':
                  {
                    if (rank > 3) rank = 3;
                  }
                  break;
                case 'Others':
                  {
                    if (rank > 5) rank = 5;
                  }
                  break;
                default:
              }
            }
          }
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
            function: () async {
              print([i, j]);
              allEvents = await retrieveAllUser();
              check = deleteFrom2DList(twoDList);
            },
            boxInternalColour: colourIndicator[rank] ?? null,
          );
          startDayIndex = startDayIndex.add(Duration(days: 1));
        } else {
          twoDList[i][j] = CircularButton(
            visible: false,
            location: [i, j],
          ); //SizedBox.shrink(child: Text('data'),);
        }
      }
    }
    triggerDaysLeft = true;
  }

  @override
  void initState() {
    super.initState();
    setState(() {});
    getAllCourseInfo();
  }

  Future<void> getAllCourseInfo() async {
    allCourseInfo = await databasehelper.getCourse();
  }

  Future<List<User>> retrieveAllUser() async {
    return await databasehelper.getAllUsers();
  }

  bool deleteFrom2DList(List<List> list) {
    for (int i = 0; i < list.length; i++) {
      for (int j = 0; j < list[i].length; j++) {
        list[i][j] = null;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    bool showBottomMenu = false;
    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async => false,
      child: FutureBuilder(
        future: retrieveAllUser(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          if (snapshot.hasData) {
            allEvents = snapshot.data;
            updateUI(dateTime);
          }
          return (snapshot.hasData)
              ? SwipeDetector(
                  onSwipeUp: () {
                    if (!showBottomMenu) {
                      setState(() {
                        showBottomMenu = true;
                      });
                    }
                  },
                  onSwipeDown: () {
                    if (showBottomMenu)
                      setState(() {
                        showBottomMenu = false;
                      });
                    deleteFrom2DList(twoDList);
                  },
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
                        dateTime = dateTime.add(
                            Duration(days: Utils.daysInMonth(dateTime).length));

                        deleteFrom2DList(twoDList);
                        // _allEvents =await _retrieveAllUser();
                        // updateUI(dateTime);
                      },
                    );
                  },
                  onSwipeRight: () {
                    setState(() {
                      dateTime = dateTime.subtract(
                          Duration(days: Utils.daysInMonth(dateTime).length));

                      deleteFrom2DList(twoDList);
                      // _allEvents = await _retrieveAllUser();
                      // updateUI(dateTime);
                    });
                  },
                  child: Scaffold(
                    key: _scaffoldKey,
                    drawer: Drawer(
                      child:
                          ListView(padding: EdgeInsets.zero, children: <Widget>[
                        UserAccountsDrawerHeader(
                          currentAccountPicture: Icon(
                            Icons.person,
                          ),
                          accountName: (allCourseInfo != null)
                              ? Text('${allCourseInfo[0].name}')
                              : Text('Name here'),
                          accountEmail: null,
                        ),
                        ListTile(
                          leading: Icon(Icons.event_busy),
                          title: Text('Delete To Do List\n(Press and hold)'),
                          onLongPress: () {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: Text(
                                          'ARE YOU SURE TO DELETE THE TO-DO LIST?'),
                                      content:
                                          Text('This will be irreversible.'),
                                      actions: [
                                        FlatButton(
                                          onPressed: () async {
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
                          leading: Icon(Icons.delete_forever),
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
                                    onPressed: () async {
                                      await databasehelper.coursesExist();
                                      await databasehelper.usersExist();
                                      databasehelper.deleteAllUsers();
                                      databasehelper.deleteAllCourses();
                                      Navigator.of(context).pop();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoadingScreen()));
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
                                            child: Text(
                                                'Application created by SMAPP-C E037\n\nCreators:\nZhi Yuan (Group Leader)\nZhen Ann(UI/UX)\nYi Ting\nDennis Ong\n\nThe purpose of this mobile application is to assist Electrical & Electronics Engineering students with better time management and improve productivity throughout the academic semester.'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            })
                                      ],
                                    ));
                          },
                        ),
                        ListTile(
                          title: Text('EXIT APP'),
                          leading: Icon(Icons.exit_to_app),
                          onTap: () {
                            exit(0);
                          },
                        )
                      ]),
                    ),
                    body: SafeArea(
                      child: Column(children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
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
                              Center(
                                child: SizedBox(
                                  height: 150.0,
                                  child: Center(
                                    child: Text(
                                      '${DateFormat.yMMMM().format(dateTime)}',
                                      style: TextStyle(fontSize: 40.0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Table(
                            defaultColumnWidth: FlexColumnWidth(1.0),
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            children: <TableRow>[
                              TableRow(
                                children: <Widget>[
                                  Center(
                                    child: Text(
                                      'Mon',
                                    ),
                                  ),
                                  Center(child: Text('Tue')),
                                  Center(child: Text('Wed')),
                                  Center(child: Text('Thurs')),
                                  Center(child: Text('Fri')),
                                  Center(child: Text('Sat')),
                                  Center(child: Text('Sun')),
                                ],
                              ),
                              TableRow(
                                children: twoDList[0],
                              ),
                              TableRow(
                                children: twoDList[1],
                              ),
                              TableRow(
                                children: twoDList[2],
                              ),
                              TableRow(
                                children: twoDList[3],
                              ),
                              TableRow(
                                children: twoDList[4],
                              ),
                              TableRow(
                                children: twoDList[5],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: MenuWidget(
                            myEventdata: bottomViewerEvents,
                          ),
                        )
                      ]),
                    ),
                  ),
                )
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  void screenUpdate() {
    setState(() {});
  }
}

class MenuWidget extends StatelessWidget {
  MenuWidget({@required this.myEventdata});
  final List<User> myEventdata;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    List<Widget> temp = [];
    if (myEventdata.isNotEmpty) {
      Map<int, List<int>> rank = {};
      for (int i = 0; i < myEventdata.length; i++) {
        int count = 1;
        int min = int.parse(myEventdata[i].eventDate);
        if (min >= 0) {
          for (int j = 0; j < myEventdata.length; j++) {
            String daysLeft = myEventdata[j].eventDate;
            if (int.parse(daysLeft) >= 0 && int.parse(daysLeft) < min) {
              count++;
            }
          }

          if (rank[count] == null) {
            rank[count] = new List();
          }
          rank[count].add(i);
        }
      }
      List<int> rankKeys = rank.keys.toList();
      rankKeys.sort();
      for (int k = 0; k < rank.length; k++) {
        rank[rankKeys[k]].forEach((element) => temp.add(DaysLeft(
            days: ListOfCourses().findDatedd(myEventdata[element].eventET),
            monthsOfDaysLeft:
                ListOfCourses().findDateMM(myEventdata[element].eventET),
            eventName: myEventdata[element].eventName,
            daysleft: myEventdata[element].eventDate,
            teCAT: myEventdata[element].eventCAT)));
      }
      int element = rank[rankKeys.first].first;
      FlutterAppBadger.updateBadgeCount(
          int.parse(myEventdata[element].eventDate));
      myEventdata.clear();
    }

    return Container(
        padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
        width: width,
        decoration: BoxDecoration(
          color: ThemeData.dark().cardColor,
          borderRadius: BorderRadius.vertical(top: Radius.elliptical(10, 10)),
          boxShadow: [
            BoxShadow(
                blurRadius: 1.0, spreadRadius: 2.0, offset: Offset(-2.0, 0.0))
          ],
        ),
        child: ListView(children: temp));
  }
}

class DaysLeft extends StatelessWidget {
  DaysLeft(
      {this.days,
      this.monthsOfDaysLeft,
      this.eventName,
      this.daysleft,
      this.teCAT});
  final days;
  final monthsOfDaysLeft;
  final eventName;
  final daysleft;
  final teCAT;
  @override
  Widget build(BuildContext context) {
    String letterMonth = months[int.parse(monthsOfDaysLeft) - 1];
    return Container(
      height: 120.0,
      margin: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 24.0,
      ),
      child: Stack(
        children: <Widget>[
          Container(
            height: 124.0,
            margin: EdgeInsets.only(left: 35.0),
            child: Row(
              children: [
                SizedBox(width: 40.0),
                Expanded(
                  flex: 7,
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          '$eventName\n$teCAT',
                          style: TextStyle(fontSize: 20.0),
                        ),
                      )),
                ),
                Expanded(
                  flex: 3,
                  child: Center(
                    child: Text(
                      '$daysleft',
                      style: TextStyle(
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                          color: (int.parse(daysleft) <= 3)
                              ? Colors.redAccent
                              : Colors.white),
                    ),
                  ),
                )
              ],
            ),
            decoration: BoxDecoration(
                color: Colors.grey[900],
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white12,
                    blurRadius: 10.0,
                    offset: Offset(0.0, 10.0),
                  ),
                ]),
          ),
          Container(
            height: 92.0,
            width: 92.0,
            margin: EdgeInsets.symmetric(vertical: 16.0),
            alignment: FractionalOffset.centerLeft,
            child: Card(
              color: Colors.white38,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: RichText(
                  text: TextSpan(children: <TextSpan>[
                    TextSpan(
                        text: '$days',
                        style: TextStyle(
                            fontSize: 40.0, fontWeight: FontWeight.bold)),
                    TextSpan(text: '\n$letterMonth', style: TextStyle())
                  ]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
