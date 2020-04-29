import 'package:dip_taskplanner/Screen/CalendarPage.dart';
import 'package:flutter/material.dart';
import 'package:dip_taskplanner/homescreen.dart';
import 'package:intl/intl.dart';
class CircularButton extends StatelessWidget {
  CircularButton({this.text, this.function,this.visible,this.location,this.dateTime,this.boxShadowColor,this.boxInternalColour,});
  final List<int> location;
  final String text;
  final Function function;
  final DateTime dateTime;
  final bool visible; //disappear if false
  final Color boxShadowColor; //BoxShadow Color for the studying week and exam week 
  final Color boxInternalColour;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible==null ?true :visible,
      child: GestureDetector(
        onTap: () {
          
          print(dateTime.toString());
          Navigator.push(context,MaterialPageRoute(builder: (context){return MyHomePage(title:"Hi",dateTime: DateFormat('yyyy-MM-dd').format(dateTime),);})).then((value) => function);
          function();
          
        },
        child: Container(
          margin: EdgeInsets.all(8.0),
          height: 45.0,
          width: 45.0,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: boxInternalColour == null? Colors.grey[800]:boxInternalColour,
            boxShadow: [
              BoxShadow(
                  color: boxShadowColor == null? Colors.grey[900]: boxShadowColor,
                  offset: Offset(2.0, 2.0),
                  spreadRadius: 2.0,
                  blurRadius: 2.0),
            ],
          ),
          child: Text('$text'),
        ),
      ),
    );
  }
}

