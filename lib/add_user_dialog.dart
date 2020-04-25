import 'dart:async';
import 'package:intl/intl.dart';
import 'package:dip_taskplanner/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:dip_taskplanner/database/database_hepler.dart';
import 'package:dip_taskplanner/database/model/user.dart';
class AddUserDialog extends StatefulWidget {
  AddUserDialog({Key key,this.context, this.myHomePageState,this.isEdit,this.user,this.dateTime,this.courseid}) : super(key: key);
  final context;
  final myHomePageState;
  final bool isEdit;
  final User user;
  final dateTime;
  final List<String> courseid;
  @override
  _AddUserDialogState createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  @override
  Widget build(BuildContext context) {
    return buildAboutDialog(context, widget.myHomePageState, widget.isEdit, user, widget.dateTime, widget.courseid);
  }
  final teEventName = TextEditingController();
  final teEventLocation = TextEditingController();
  final teST = TextEditingController();
  final teET = TextEditingController();
  final teCAT = TextEditingController();
  User user;

  static const TextStyle linkStyle = const TextStyle(
    color: Colors.blue,
    decoration: TextDecoration.underline,
  );

  Widget buildAboutDialog(BuildContext context, _myHomePageState, bool isEdit,
      User user, String dateTime, List<String> courseid) {
    if (user != null) {
      this.user = user;
      teEventName.text = user.eventName;
      teEventLocation.text = user.eventLocation;
      teST.text = user.eventST;
      teET.text = user.eventET;
      teCAT.text = user.eventCAT;
    }

    return new AlertDialog(
      title: new Text(isEdit ? 'Edit' : 'Add new User'),
      content: new SingleChildScrollView(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            getEventName("Event Name", teEventName,courseid), //getTextField("Event Name", teEventName),
            getTextField("Event Location", teEventLocation),
            startDateAndTimePicker("Start Time", teST),//getTextField("Start Time:", teST),
            endDateAndTimePicker("End Time", teET),//getTextField("End Time:", teET),
            getCategoryList("Category", teCAT), //getTextField("Category", teCAT),
            new GestureDetector(
              onTap: () {
                setState(() {
                  // print(teEventName.text);
                  // print(teEventLocation.text);
                  // print(teST.text);
                  // print(teET.text);
                  // print(teCAT.text);
                  addRecord(isEdit, dateTime);
                  //_myHomePageState.displayRecord();
                  Navigator.of(context).pop();
                });

              },
              child: new Container(
                margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                child: getAppBorderButton(isEdit ? "Edit" : "Add",
                    EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getTextField(
      String inputBoxName, TextEditingController inputBoxController) {
    var loginBtn = new Padding(
      padding: const EdgeInsets.all(5.0),
      child: new TextFormField(
        controller: inputBoxController,
        decoration: new InputDecoration(
          hintText: inputBoxName,
        ),
      ),
    );

    return loginBtn;
  }
  String eventNameValue;
  final name = TextEditingController();
  Widget getEventName(String inputBoxName,TextEditingController inputBoxController, List<String> courseid) {
    
    return Row(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                
                value: eventNameValue,
                isDense: true,
                items: courseid.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                hint: Text('CourseID'),
                onChanged: (value) {
                  setState(() {
                    inputBoxController.text = value + ' ' + name.text;
                    eventNameValue = value;
                  });
                }),
          ),
        ),
        SizedBox(width: 5.0),
        Expanded(
          flex: 3,
          child: TextFormField(
            controller: name,
            decoration: InputDecoration(
              hintText: inputBoxName,
            ),
            onFieldSubmitted: (value) {
              inputBoxController.text = inputBoxController.text + ' ' + value;
            },
            autofocus: false,
          ),
        )
      ],
    );
  }
  String categoryValue;
  Widget getCategoryList(
      String inputBoxName, TextEditingController inputBoxController) {
    
    return Padding(
      padding: const EdgeInsets.fromLTRB( 5.0, 0.0,10.0,0.0),
      child: DropdownButton<String>(
        value: categoryValue,
        onChanged: (newValue) {
          setState(() {
            inputBoxController.text = newValue;
            categoryValue = newValue;            
          });
        },
        items: <String>[
          'Tut',
          'Quiz',
          'Homework Assignment',
          'IRA/Class Test',
          'Lab',
          'Exam',
          'Others'
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        hint: Text('Category'),
      ),
    );
  }

  Widget getAppBorderButton(String buttonLabel, EdgeInsets margin) {
    var loginBtn = new Container(
      margin: margin,
      padding: EdgeInsets.all(8.0),
      alignment: FractionalOffset.center,
      decoration: new BoxDecoration(
        border: Border.all(color: Colors.teal[300]), //const Color(0xFF28324E)),
        borderRadius: new BorderRadius.all(const Radius.circular(6.0)),
      ),
      child: new Text(
        buttonLabel,
        style: new TextStyle(
          color: Colors.teal[300],//color: const Color(0xFF28324E),
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
          letterSpacing: 0.3,
        ),
      ),
    );
    return loginBtn;
  }
  DateTime startDateTime = DateTime.now();
  DateTime endDateTime = DateTime.now().add(Duration(days: 1));
  Future<void> _pickStartDate ()async {
    DateTime date = await showDatePicker(
      context: context ,
      initialDate:startDateTime,//starting year of now -5 years 
      firstDate: DateTime(DateTime.now().year-5), 
      lastDate: DateTime(DateTime.now().year+5));
    if (date !=null){
      setState(() {
        startDateTime = DateTime(date.year,date.month,date.day,startDateTime.hour,startDateTime.minute);        
      });
    }  
  }

  Future<void> _pickStartTime () async{
    TimeOfDay t = await showTimePicker(
      context: context, 
      initialTime: TimeOfDay.fromDateTime(startDateTime)
      );
    if(t!=null) setState(() {
      startDateTime = DateTime(startDateTime.year,startDateTime.month,startDateTime.day,t.hour,t.minute);
    });
  }
  Widget startDateAndTimePicker(String hint, TextEditingController controller){
    return ListTile(
      leading:Icon(Icons.date_range) ,
      title: Text(hint),
      subtitle: Text(controller.text = ('${NumberFormat('00').format(startDateTime.day)}-${NumberFormat('00').format(startDateTime.month)}-${startDateTime.year} ${NumberFormat('00').format(startDateTime.hour)}:${NumberFormat('00').format(startDateTime.minute)}')),//('${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.}')),
      trailing: Icon(Icons.more_vert),
      dense:true,
      onTap: (){
        _pickStartDate();
        if(endDateTime.isBefore(startDateTime)){
          var temp = endDateTime;
          endDateTime = startDateTime;
          startDateTime = temp;
        }
        _pickStartTime();
      },
    );
  }
    Future<void> _pickEndDate ()async {
    DateTime date = await showDatePicker(
      context: context ,
      initialDate:endDateTime,//starting year of now -5 years 
      firstDate: DateTime(DateTime.now().year-5), 
      lastDate: DateTime(DateTime.now().year+5));
    if (date !=null){
      setState(() {
        endDateTime = DateTime(date.year,date.month,date.day,endDateTime.hour,endDateTime.minute);        
      });
    }  
  }

  Future<void> _pickEndTime () async{
    TimeOfDay t = await showTimePicker(
      context: context, 
      initialTime: TimeOfDay.fromDateTime(endDateTime)
      );
    if(t!=null) setState(() {
      endDateTime = DateTime(endDateTime.year,endDateTime.month,endDateTime.day,t.hour,t.minute);
    });
  }
  Widget endDateAndTimePicker(String hint, TextEditingController controller){
    return ListTile(
      leading:Icon(Icons.date_range) ,
      title: Text(hint),
      subtitle: Text(controller.text = ('${NumberFormat('00').format(endDateTime.day)}-${NumberFormat('00').format(endDateTime.month)}-${endDateTime.year} ${NumberFormat('00').format(endDateTime.hour)}:${NumberFormat('00').format(endDateTime.minute)}')),
      trailing: Icon(Icons.more_vert),
      dense:true,
      onTap: (){
        _pickEndDate();
        if(endDateTime.isBefore(startDateTime)){
          var temp = endDateTime;
          endDateTime = startDateTime;
          startDateTime = temp;
        }
        _pickEndTime();
      },
    );
  }
  Future addRecord(bool isEdit, String dateTime) async {
    var db = new DatabaseHelper();
    var user = new User(teEventName.text, teEventLocation.text, teST.text,
        teET.text, teCAT.text, dateTime);
    if (isEdit) {
      user.setUserId(this.user.id);
      await db.update(user);
    } else {
      await db.saveUser(user);
    }
  }
}

