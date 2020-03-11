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
  CalendarPage({@required this.academicCalendar});
  final PdfPageImage academicCalendar;

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime dateTime = new DateTime.now();
  List<List<Widget>> twoDList =
      List.generate(rows, (i) => List(DateTime.daysPerWeek), growable: false);
  void updateUI(DateTime dateTime) {
    DateTime startDayIndex = Utils.firstDayOfMonth(dateTime);
    DateTime nameOfEndDay = Utils.lastDayOfMonth(dateTime);

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < daysPerWeek; j++) {
        if ((j + 1) == startDayIndex.weekday &&
            startDayIndex.month == dateTime.month) {
          twoDList[i][j] = CircularButton(
            visible: true,
            location: [i, j],
            text: startDayIndex.day.toString(),
            function: () {
              print([i, j]);
            }, //TODO: if pressed, what will pop up. Need to return location btw
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
    // TODO: implement initState

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
    return Scaffold(
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
                dateTime = dateTime.subtract(
                    Duration(days: Utils.daysInMonth(dateTime).length));
                print('$dateTime');
                deleteFrom2DList(twoDList);
                updateUI(dateTime);
              },
            );
          },
          onSwipeRight: () {
            setState(() {
              dateTime = dateTime
                  .add(Duration(days: Utils.daysInMonth(dateTime).length));
              print('$dateTime');
              deleteFrom2DList(twoDList);
              updateUI(dateTime);
            });
          },
          child: Column(children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 25.0,
                ),
              ),
            ),
            SizedBox(
              height: 150.0,
              child: Center(
                  child: Text(
                '${DateFormat.MMMM().format(dateTime)}',
                style: TextStyle(fontSize: 50.0),
              )),
            ),
            Row(
              
              children: <Widget>[
                Expanded(
                  child: Center(child: Text('Mon',)),
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
    );
  }
}
