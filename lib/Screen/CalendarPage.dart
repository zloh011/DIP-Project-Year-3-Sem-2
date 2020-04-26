import 'package:dip_taskplanner/components/regExp.dart';
import 'package:dip_taskplanner/database/database_hepler.dart';
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

const activeCardColour = Color(0xFF1D1E33);
class CalendarPage extends StatefulWidget {
  CalendarPage();
  
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>(); //To allow top left table icon button to open scaffold drawer
  final databasehelper = DatabaseHelper();
  bool check =false;
  List<User> allEvents; 
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
          for(int k=0; k<allEvents.length;k++){
            String value = ListOfCourses().findDateyyyyMMdd(allEvents[k].eventET);
            DateTime endDateTime = DateTime.parse(value);
            if(endDateTime.day==startDayIndex.day&&endDateTime.month==startDayIndex.month&&startDayIndex.year==endDateTime.year){//Check same date and Time
              switch (allEvents[k].eventCAT) {          
                case 'Exam' :{if(rank>1)rank=1;}
                  break;
                case 'Quiz' :{if(rank>2)rank=2;}
                  break;
                case 'Homework Assignment':{if(rank>4)rank=4;}
                  break;
                case 'Tut':{if(rank>6)rank=6;}
                  break;
                case 'IRA/ClassTest':{if(rank>3)rank=3;}
                  break;
                case 'Others':{if(rank>5)rank=5;}
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
            boxInternalColour: colourIndicator[rank]??null,
            
          );
          startDayIndex = startDayIndex.add(Duration(days: 1));
        } else {
          twoDList[i][j] = CircularButton(visible: false, location: [i, j],);
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {});
  }
  Future<List<User>> retrieveAllUser () async{
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
              leading: Icon(Icons.event_busy),
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
                              onPressed: () async{
                                await databasehelper.coursesExist();
                                await databasehelper.usersExist(); 
                                databasehelper.deleteAllUsers();
                                databasehelper.deleteAllCourses();
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
              FutureBuilder(
                future: retrieveAllUser(),
                builder: (context,snapshot){
                  if(snapshot.hasError)print(snapshot.error);
                  if(snapshot.hasData){
                    allEvents = snapshot.data;
                    updateUI(dateTime);
                  }
                  return (snapshot.hasData)
                  ?Column(
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
              ):Align(alignment:Alignment.bottomCenter ,child: CircularProgressIndicator());
                },),
            ]),
          ),
        ),
      ),
    );
  }
  void screenUpdate() {
    setState(() {});
  }

}
