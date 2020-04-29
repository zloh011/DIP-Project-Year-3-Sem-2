

import 'package:dip_taskplanner/database/database_hepler.dart';
import 'package:dip_taskplanner/database/model/course.dart';
import 'package:flutter/material.dart';
class ListOfCourses {
  /*Set of hidden Strings to add to database more easily */
  String _courseId;
  String _courseName;
  String _courseVenue;
  String _startTime;
  String _endTime;
  String _category;
  String _teachingWeek;
  String _courseType;
  String _academicUnit;
  String _name;
  /*Regular expressions to retrieve specific information according to the regexp name*/
  RegExp courseName = RegExp(r'[^\d]+[^\d]*[^\d]*[^\d]*[^\d]*\b');
  RegExp classType = RegExp(r'(TUT|LAB|LEC\/STUDIO|PRJ)');
  RegExp courseVenue = RegExp(r'(TR[+]*\d\d\d*|LH[SN]-TR+\d\d\d*|(TCT|LKC|LHN|LHS)-LT|LT\d\d*A*)');
  RegExp startTime = RegExp(r'\d\d\d\d-');
  RegExp endTime = RegExp(r'-\d\d\d\d');
  RegExp teachingWeek = RegExp(r'Teaching Wk\d[\d-]*-*\d*\d*');
  RegExp courseType = RegExp(r'(CORE|PRESCRIBED)');
  RegExp academicUnit = RegExp(r'\b[1-4]\b');
  RegExp day1 = RegExp(r'\d*\d');
  RegExp month1 = RegExp(r'-\d*\d-');
  RegExp year1 = RegExp(r'\d\d\d\d');
  RegExp timeOfDay = RegExp(r'\d\d:\d\d');

  String findTimeOfDay (val){
    return retrieveInfoOf(timeOfDay, val);
  }

  String findOtherThanPattern(String val){
    try {
      RegExp regExp = RegExp(r'[a-zA-Z][a-zA-Z]*\d{4}L*\s');
      Match match = regExp.firstMatch(val);
      return val.substring(match.end);      
    } catch (e) {
      print(e);
      return val;
    }

  }

  String findDateyyyyMMdd (val){
    String day = retrieveInfoOf(day1,val);
    String month = retrieveInfoOf(month1, val);
    String year = retrieveInfoOf(year1, val);
    return year+month+day;
  }
  String findDatedd (val){
    String day = retrieveInfoOf(day1,val);
    return day;
  }
  String findDateMM (val){
    String month = retrieveInfoOf(month1, val);
    String monthValue = retrieveInfoOf(day1, month);
    return monthValue;
  }  

  String inBetween(String val,String start,String end) {//subString function with input as Strings and Strings
    String str = val;
    final startIndex = str.indexOf(start);
    final endIndex = str.indexOf(end, startIndex + start.length);
    
    return (str.substring(startIndex + start.length, endIndex));
  }
  Iterable<Match> listOfCoursesId(val) {
    String foo = inBetween(val,'Remark','TOTAL');
    RegExp regExp = RegExp(r'[a-zA-Z][a-zA-Z]*\d{4}L*');
    Iterable<RegExpMatch> courses = regExp.allMatches(foo);
    return courses;
  }
  String name(val){
    return inBetween(val,'Name','Course');

  }
  /*Function to add to database  */
  bool addToDatabase (String text,BuildContext context){
    if(text.isEmpty){
      return false;
    }
    try {
      String info = inBetween(text,'Remark', 'TOTAL');
      Iterable<Match> iterable = listOfCoursesId(text);
      for(int i=0;i<iterable.length;i++){
        if(i+1 !=iterable.length){
          Match match = iterable.elementAt(i);
          int j=i+1;
          Match match1 = iterable.elementAt(j);
          String subStrings = info.substring(match.start,match1.start);
          _courseId = info.substring(match.start,match.end);
          _name = name(text);
          updateStrings(subStrings);
          addRecord();  
        }
        else{
          Match match = iterable.elementAt(i);
          String subStrings = info.substring(match.start);
          _courseId = info.substring(match.start,match.end);
          _name = name(text);
          updateStrings(subStrings);
          addRecord();
        }  
      }
      return true;      
    } catch (e) {
      
      //print(e);
      return false;
    }
  }
  void updateStrings (String subStrings){
               
    _courseName   = retrieveInfoOf(courseName,subStrings);
    _courseVenue  = retrieveInfoOf(courseVenue,subStrings);
    _startTime    = retrieveInfoOf(startTime,subStrings);
    _endTime      = retrieveInfoOf(endTime,subStrings);
    _category     = retrieveInfoOf(classType,subStrings);
    _teachingWeek = retrieveInfoOf(teachingWeek,subStrings);
    _courseType   = retrieveInfoOf(courseType,subStrings);
    _academicUnit = retrieveInfoOf(academicUnit,subStrings);
    
  }
  String retrieveInfoOf (RegExp regExp,String subStrings){
    try {
      Match match = regExp.firstMatch(subStrings);
      return subStrings.substring(match.start,match.end);
    } catch (e) {
      print(e);
      return null;
    }

  }

  Future addRecord() async {
    var db = new DatabaseHelper();
    var course = new Course(_courseId, _courseName, _courseVenue, _startTime, _endTime, _category, _teachingWeek, _courseType, _academicUnit,_name);
    await db.saveCourse(course);
  }

}
