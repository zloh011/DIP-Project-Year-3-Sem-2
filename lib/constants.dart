import 'package:flutter/material.dart';

enum dayOfWeek {
  Sun,
  Mon,
  Tue,
  Wed,
  Thurs,
  Fri,
  Sat,
}
const List<String> months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
const Map<int,String> dayOfWk = {
  7:'Sun',
  1:'Mon',
  2:'Tue',
  3:'Wed',
  4:'Thurs',
  5:'Fri',
  6:'Sat',
};
const int rows = 6;
const int daysPerWeek = DateTime.daysPerWeek;

Map<int,Color> colourIndicator ={
  1:Colors.red[700],
  2:Colors.orange,
  3:Colors.amber,
  4:Colors.purple,
  5:Colors.green,
  6:Colors.teal[100],
};



Map<DateTime,List<dynamic>> academicWeeks = {
  DateTime.parse('2020-01-13 00:00:00'):["week1",Colors.teal[100]],
  DateTime.parse('2020-01-20 00:00:00'):["week2",Colors.teal[100]],
  DateTime.parse('2020-01-27 00:00:00'):["week3",Colors.teal[100]],
  DateTime.parse('2020-02-03 00:00:00'):["week4",Colors.teal[100]],
  DateTime.parse('2020-02-10 00:00:00'):["week5",Colors.teal[100]],
  DateTime.parse('2020-02-17 00:00:00'):["week6",Colors.teal[100]],
  DateTime.parse('2020-02-24 00:00:00'):["week7",Colors.teal[100]],
  DateTime.parse('2020-03-02 00:00:00'):["recess",null],
  DateTime.parse('2020-03-09 00:00:00'):["week8",Colors.teal[100]],
  DateTime.parse('2020-03-16 00:00:00'):["week9",Colors.teal[100]],
  DateTime.parse('2020-03-23 00:00:00'):["week10",Colors.teal[100]],
  DateTime.parse('2020-03-30 00:00:00'):["week11",Colors.teal[100]],
  DateTime.parse('2020-04-06 00:00:00'):["week12",Colors.teal[100]],
  DateTime.parse('2020-04-13 00:00:00'):["week13",Colors.teal[100]],
  DateTime.parse('2020-04-20 00:00:00'):["exam",Colors.orange[700]],
  DateTime.parse('2020-04-27 00:00:00'):["exam",Colors.orange[700]],
  DateTime.parse('2020-05-04 00:00:00'):["exam",Colors.orange[700]],
};
const String urlAcadCal =
    'https://www.ntu.edu.sg/sasd/oas/AcademicCalendar/Documents/NTU';

// Color(0xFFFFFF); // fully transparent white (invisible)
// Color(0xFFFFFFFF); // fully opaque white (visible)